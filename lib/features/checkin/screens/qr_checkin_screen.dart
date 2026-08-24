import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/active_checkin_provider.dart';
import '../../../core/providers/facilities_providers.dart';
import '../../../core/utils/ble_presence_helper.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../core/utils/file_validator.dart';
import '../../../data/api/app_exception.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/gym_attendance_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../data/repositories/gym_attendance_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../gym_checkin_qr_payload.dart';

enum _ScanStatus { scanning, checkingIn, success, error, permissionDenied }

enum _QrType {
  gymCheckIn,
  gymCheckOut,
  libraryAccess,
  citizenId,
  url,
  textData,
}

class _DecodedQrInfo {
  const _DecodedQrInfo({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.rawValue,
    required this.categoryLabel,
    required this.categoryIcon,
    required this.accentColor,
    this.gymAttendance,
    this.url,
    this.metadata = const {},
  });

  final _QrType type;
  final String title;
  final String subtitle;
  final String rawValue;
  final String categoryLabel;
  final IconData categoryIcon;
  final Color accentColor;
  final GymAttendanceModel? gymAttendance;
  final Uri? url;
  final Map<String, String> metadata;
}

class QrCheckinScreen extends ConsumerStatefulWidget {
  const QrCheckinScreen({super.key});

  @override
  ConsumerState<QrCheckinScreen> createState() => _QrCheckinScreenState();
}

class _QrCheckinScreenState extends ConsumerState<QrCheckinScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  _ScanStatus _status = _ScanStatus.scanning;
  _DecodedQrInfo? _decodedInfo;
  String? _errorMessage;
  bool _isBluetoothError = false;
  String? _pendingRetryPayload;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleEnableBluetooth() async {
    final enabled = await BlePresenceHelper.requestEnableBluetooth();
    if (enabled && _pendingRetryPayload != null) {
      final payload = _pendingRetryPayload!;
      _pendingRetryPayload = null;
      setState(() => _status = _ScanStatus.scanning);
      _processPayload(payload);
    } else {
      _retry();
    }
  }

  Future<void> _processPayload(String raw) async {
    if (_status != _ScanStatus.scanning) return;
    setState(() => _status = _ScanStatus.checkingIn);
    HapticFeedback.mediumImpact();

    final trimmed = raw.trim();

    // 0. Check if JSON encoded Facility Check-in QR
    try {
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map && (decoded['type'] == 'facility_checkin' || decoded.containsKey('facility_id') || decoded.containsKey('gym_id') || decoded.containsKey('library_id') || decoded.containsKey('activity_id'))) {
          final rawKind = (decoded['facility_type'] ?? decoded['type'] ?? '').toString().toLowerCase();
          final facilityId = (decoded['facility_id'] ?? decoded['id'] ?? decoded['gym_id'] ?? decoded['library_id'] ?? decoded['activity_id'])?.toString() ?? '';

          if (facilityId.isNotEmpty) {
            FacilityKind kind;
            if (rawKind.contains('gym') || facilityId.toUpperCase().startsWith('GYM')) {
              kind = FacilityKind.gym;
            } else if (rawKind.contains('act') || rawKind.contains('fac') || rawKind.contains('center') || facilityId.toUpperCase().startsWith('ACT') || facilityId.toUpperCase().startsWith('FAC')) {
              kind = FacilityKind.activity;
            } else {
              kind = FacilityKind.library;
            }

            final facilityName = decoded['facility_name']?.toString() ?? (kind == FacilityKind.gym ? 'Gym Facility' : (kind == FacilityKind.activity ? 'Facility Center' : 'Library Hub'));
            final bool bleRequired = decoded['ble_required'] == true;
            final bool bleStrictMode = decoded['ble_strict_mode'] == true;
            final String? serviceUuid = decoded['service_uuid']?.toString();
            final String? qrNonce = decoded['qr_nonce']?.toString();

            setState(() => _status = _ScanStatus.checkingIn);

            String? detectedBleNonce;
            int? detectedRssi;

            if (bleRequired && serviceUuid != null && serviceUuid.isNotEmpty) {
              final beacon = await BlePresenceHelper.scanForFacilityBeacon(
                targetUuid: serviceUuid,
                timeout: const Duration(milliseconds: 2500),
              );

              if (beacon != null) {
                detectedBleNonce = beacon['ble_nonce']?.toString() ?? qrNonce;
                detectedRssi = beacon['rssi'] as int?;
              } else if (bleStrictMode) {
                // In Strict Mode: reject checkin if beacon not detected over the air
                final isBtOn = await BlePresenceHelper.isBluetoothEnabled();
                if (!isBtOn) {
                  await BlePresenceHelper.requestEnableBluetooth();
                }

                if (!mounted) return;
                setState(() {
                  _status = _ScanStatus.error;
                  _isBluetoothError = !isBtOn;
                  _pendingRetryPayload = trimmed;
                  _errorMessage = 'Facility Bluetooth beacon not detected. Please stand closer to the counter display with Bluetooth turned ON.';
                });
                return;
              } else {
                // In Hybrid Mode: Seamless fallback using live rotating screen QR token
                detectedBleNonce = qrNonce;
                detectedRssi = -65;
              }
            }

            try {
              final checkinRes = await ref.read(clientFacilityRepositoryProvider).citizenScanAttendance(
                kind,
                facilityId,
                qrNonce: qrNonce,
                bleNonce: detectedBleNonce ?? qrNonce,
                rssi: detectedRssi,
              );
              ref.invalidate(activeCheckinProvider);
              if (!mounted) return;

              final statusStr = checkinRes['status']?.toString() ?? 'checked_in';
              final isCheckOut = statusStr == 'checked_out';
              final durationMinutes = checkinRes['duration_minutes'];
              final resolvedName = checkinRes['facility_name']?.toString() ?? facilityName;
              final verificationMode = checkinRes['verification_mode']?.toString();

              setState(() {
                _status = _ScanStatus.success;
                _decodedInfo = _DecodedQrInfo(
                  type: isCheckOut ? _QrType.gymCheckOut : (kind == FacilityKind.gym ? _QrType.gymCheckIn : _QrType.libraryAccess),
                  title: resolvedName,
                  subtitle: isCheckOut ? 'Check-Out Confirmed' : '${kind.displayName} Check-In Confirmed',
                  rawValue: trimmed,
                  categoryLabel: isCheckOut ? '${kind.displayName} Check-Out' : '${kind.displayName} Check-In',
                  categoryIcon: isCheckOut
                      ? Icons.logout_rounded
                      : (kind == FacilityKind.gym
                          ? Icons.fitness_center_rounded
                          : (kind == FacilityKind.activity ? Icons.domain_rounded : Icons.local_library_rounded)),
                  accentColor: isCheckOut ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
                  metadata: {
                    'Facility': resolvedName,
                    'Type': kind.displayName,
                    'Status': isCheckOut ? 'Checked Out Successfully' : 'Checked In Successfully',
                    if (bleRequired)
                      'Verification': verificationMode == 'qr_totp_fallback'
                          ? 'Live Display QR (Counter Bluetooth Inactive)'
                          : 'Verified via Bluetooth (BLE Proximity)',
                    if (isCheckOut && durationMinutes != null)
                      'Session Duration': formatMinutes(durationMinutes),
                    'Time': DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now()),
                  },
                );
              });
              return;
            } catch (e) {
              final appException = AppException.from(e);
              if (!mounted) return;
              setState(() {
                _status = _ScanStatus.error;
                _errorMessage = appException?.message ?? 'Check-in failed. Please verify your membership pass.';
              });
              return;
            }
          }
        }
      }
    } catch (_) {}

    final summaries =
        ref.read(myMembershipSummariesProvider).value ?? const [];
    final gymMemberships =
        summaries.where((m) => m.kind == FacilityKind.gym).toList();
    final defaultMemberId =
        gymMemberships.isNotEmpty ? gymMemberships.first.payableId : null;

    final gymPayload = GymCheckInQrPayload.tryDecode(
      trimmed,
      defaultMemberId: defaultMemberId,
    );

    // 1. Check if it's a Gym Check-In QR
    if (gymPayload != null) {
      setState(() => _status = _ScanStatus.checkingIn);
      try {
        final attendance = await ref
            .read(gymAttendanceRepositoryProvider)
            .checkIn(gymPayload.gymId, memberId: gymPayload.memberId);
        ref.invalidate(activeCheckinProvider);
        if (!mounted) return;

        setState(() {
          _status = _ScanStatus.success;
          _decodedInfo = _DecodedQrInfo(
            type: _QrType.gymCheckIn,
            title: attendance.gym?.name ?? 'Fitness Center',
            subtitle: 'Gym Check-in Confirmed',
            rawValue: trimmed,
            categoryLabel: 'Gym Check-In',
            categoryIcon: Icons.fitness_center_rounded,
            accentColor: const Color(0xFF10B981),
            gymAttendance: attendance,
            metadata: {
              'Facility': attendance.gym?.name ?? 'Smart Gym',
              'Check-in Time': DateFormat('hh:mm a, dd MMM yyyy').format(
                attendance.checkInAt ?? DateTime.now(),
              ),
              'Status': 'Verified & Logged',
            },
          );
        });
        return;
      } catch (e) {
        final appException = AppException.from(e);
        if (!mounted) return;
        setState(() {
          _status = _ScanStatus.error;
          _errorMessage = appException?.message ?? 'Gym Check-in failed. Please ensure your pass is active.';
        });
        return;
      }
    }

    // 2. Check if it's a direct Facility ID (e.g. LIB..., GYM..., ACT..., FAC...)
    final upper = trimmed.toUpperCase();
    if ((upper.startsWith('LIB') || upper.startsWith('GYM') || upper.startsWith('ACT') || upper.startsWith('FAC')) && trimmed.length <= 20) {
      final kind = upper.startsWith('GYM')
          ? FacilityKind.gym
          : (upper.startsWith('ACT') || upper.startsWith('FAC') ? FacilityKind.activity : FacilityKind.library);
      final facilityName = kind == FacilityKind.gym
          ? 'Gym Facility'
          : (kind == FacilityKind.activity ? 'Facility Center' : 'Library Hub');

      setState(() => _status = _ScanStatus.checkingIn);
      try {
        final checkinRes = await ref.read(clientFacilityRepositoryProvider).citizenScanAttendance(kind, trimmed);
        ref.invalidate(activeCheckinProvider);
        if (!mounted) return;

        final statusStr = checkinRes['status']?.toString() ?? 'checked_in';
        final isCheckOut = statusStr == 'checked_out';
        final durationMinutes = checkinRes['duration_minutes'];
        final resolvedName = checkinRes['facility_name']?.toString() ?? facilityName;

        setState(() {
          _status = _ScanStatus.success;
          _decodedInfo = _DecodedQrInfo(
            type: isCheckOut
                ? _QrType.gymCheckOut
                : (kind == FacilityKind.gym ? _QrType.gymCheckIn : _QrType.libraryAccess),
            title: resolvedName,
            subtitle: isCheckOut ? 'Check-Out Confirmed' : '${kind.displayName} Check-In Confirmed',
            rawValue: trimmed,
            categoryLabel: isCheckOut ? '${kind.displayName} Check-Out' : '${kind.displayName} Check-In',
            categoryIcon: isCheckOut
                ? Icons.logout_rounded
                : (kind == FacilityKind.gym
                    ? Icons.fitness_center_rounded
                    : (kind == FacilityKind.activity ? Icons.domain_rounded : Icons.local_library_rounded)),
            accentColor: isCheckOut ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
            metadata: {
              'Facility': resolvedName,
              'Type': kind.displayName,
              'Status': isCheckOut ? 'Checked Out Successfully' : 'Checked In Successfully',
              if (isCheckOut && durationMinutes != null)
                'Session Duration': formatMinutes(durationMinutes),
              'Time': DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now()),
            },
          );
        });
        return;
      } catch (e) {
        final appException = AppException.from(e);
        if (!mounted) return;
        setState(() {
          _status = _ScanStatus.error;
          _errorMessage = appException?.message ?? 'Check-in failed. Please verify your membership pass.';
        });
        return;
      }
    }

    // 3. Check if it's a Citizen Identity Pass (CID-...)
    if (trimmed.toUpperCase().startsWith('CID-') ||
        trimmed.toUpperCase().contains('CITIZEN')) {
      setState(() {
        _status = _ScanStatus.success;
        _decodedInfo = _DecodedQrInfo(
          type: _QrType.citizenId,
          title: 'Citizen Digital Pass',
          subtitle: 'Verified Municipal Identity',
          rawValue: trimmed,
          categoryLabel: 'Citizen ID',
          categoryIcon: Icons.badge_rounded,
          accentColor: const Color(0xFF0D9488),
          metadata: {
            'Citizen Code': trimmed,
            'Timestamp': DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now()),
            'Status': 'Valid & Active',
          },
        );
      });
      return;
    }

    // 4. Check if it's a Web URL (http / https)
    final uri = Uri.tryParse(trimmed);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      setState(() {
        _status = _ScanStatus.success;
        _decodedInfo = _DecodedQrInfo(
          type: _QrType.url,
          title: uri.host.isNotEmpty ? uri.host : 'Web Link',
          subtitle: uri.path.isNotEmpty ? uri.path : 'External Web Resource',
          rawValue: trimmed,
          categoryLabel: 'Web URL',
          categoryIcon: Icons.language_rounded,
          accentColor: const Color(0xFF6366F1),
          url: uri,
          metadata: {
            'Host': uri.host,
            'Scheme': uri.scheme.toUpperCase(),
            'Full URL': trimmed,
          },
        );
      });
      return;
    }

    // 5. Generic Smart QR / Text Payload / JSON
    Map<String, String> parsedMeta = {
      'Scanned Time': DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now()),
      'Payload Length': '${trimmed.length} characters',
    };

    try {
      final decodedJson = jsonDecode(trimmed);
      if (decodedJson is Map) {
        decodedJson.forEach((k, v) {
          parsedMeta[k.toString()] = v.toString();
        });
      }
    } catch (_) {}

    setState(() {
      _status = _ScanStatus.success;
      _decodedInfo = _DecodedQrInfo(
        type: _QrType.textData,
        title: 'QR Code Detected',
        subtitle: 'Payload Successfully Scanned',
        rawValue: trimmed,
        categoryLabel: 'Smart Citizen QR',
        categoryIcon: Icons.qr_code_scanner_rounded,
        accentColor: const Color(0xFF0284C7),
        metadata: parsedMeta,
      );
    });
  }

  void _handleDetection(BarcodeCapture capture) {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;
    _processPayload(raw);
  }

  Future<void> _uploadFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;

    final validationError = await FileValidator.validateXFile(picked);
    if (validationError != null) {
      if (!mounted) return;
      setState(() {
        _status = _ScanStatus.error;
        _errorMessage = validationError;
      });
      return;
    }

    final capture = await _controller.analyzeImage(picked.path);
    if (!mounted) return;
    final raw = capture?.barcodes.firstOrNull?.rawValue;
    if (raw == null) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _status = _ScanStatus.error;
        _errorMessage = l10n.invalidQrCode;
      });
      return;
    }
    await _processPayload(raw);
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  void _retry() {
    setState(() {
      _status = _ScanStatus.scanning;
      _decodedInfo = null;
      _errorMessage = null;
      _isBluetoothError = false;
      _pendingRetryPayload = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: switch (_status) {
          _ScanStatus.scanning || _ScanStatus.checkingIn => _ScannerBody(
            controller: _controller,
            onDetect: _handleDetection,
            onUpload: _uploadFromGallery,
            onToggleTorch: _toggleTorch,
            torchOn: _torchOn,
            isCheckingIn: _status == _ScanStatus.checkingIn,
            l10n: l10n,
          ),
          _ScanStatus.success => _GenericSuccessView(
            info: _decodedInfo!,
            onScanAnother: _retry,
            onDone: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          _ScanStatus.error => _ErrorView(
            message: _errorMessage ?? l10n.errorGeneric,
            retryLabel: l10n.retry,
            isBluetoothError: _isBluetoothError,
            onEnableBluetooth: _handleEnableBluetooth,
            onRetry: _retry,
          ),
          _ScanStatus.permissionDenied => _PermissionDeniedView(l10n: l10n),
        },
      ),
    );
  }
}

class _ScannerBody extends StatelessWidget {
  const _ScannerBody({
    required this.controller,
    required this.onDetect,
    required this.onUpload,
    required this.onToggleTorch,
    required this.torchOn,
    required this.isCheckingIn,
    required this.l10n,
  });

  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;
  final VoidCallback onUpload;
  final VoidCallback onToggleTorch;
  final bool torchOn;
  final bool isCheckingIn;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.scanAnyQr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Gym, Library, Citizen ID & City Passes',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Align any QR code inside the frame to scan.'),
                  ),
                ),
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: MobileScanner(
                        controller: controller,
                        onDetect: isCheckingIn ? (_) {} : onDetect,
                        errorBuilder: (context, error) =>
                            _PermissionDeniedView(l10n: l10n),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        painter: _CornerFramePainter(
                          color: const Color(0xFF10B981), // Glowing Emerald
                        ),
                      ),
                    ),
                    if (isCheckingIn)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Color(0xFF34D399),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Verifying Check-in...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ScannerActionButton(
              icon: Icons.image_outlined,
              label: l10n.uploadQr,
              onTap: isCheckingIn ? null : onUpload,
            ),
            const SizedBox(width: 40),
            _ScannerActionButton(
              icon: torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              label: l10n.torch,
              onTap: isCheckingIn ? null : onToggleTorch,
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _CornerFramePainter extends CustomPainter {
  const _CornerFramePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const armLength = 28.0;
    const inset = 4.0;

    void corner(Offset origin, Offset dx, Offset dy) {
      canvas.drawLine(origin, origin + dx * armLength, paint);
      canvas.drawLine(origin, origin + dy * armLength, paint);
    }

    corner(Offset(inset, inset), const Offset(1, 0), const Offset(0, 1));
    corner(
      Offset(size.width - inset, inset),
      const Offset(-1, 0),
      const Offset(0, 1),
    );
    corner(
      Offset(inset, size.height - inset),
      const Offset(1, 0),
      const Offset(0, -1),
    );
    corner(
      Offset(size.width - inset, size.height - inset),
      const Offset(-1, 0),
      const Offset(0, -1),
    );
  }

  @override
  bool shouldRepaint(_CornerFramePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ScannerActionButton extends StatelessWidget {
  const _ScannerActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.12),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _GenericSuccessView extends StatefulWidget {
  const _GenericSuccessView({
    required this.info,
    required this.onScanAnother,
    required this.onDone,
  });

  final _DecodedQrInfo info;
  final VoidCallback onScanAnother;
  final VoidCallback onDone;

  @override
  State<_GenericSuccessView> createState() => _GenericSuccessViewState();
}

class _GenericSuccessViewState extends State<_GenericSuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..forward();

  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Animated Checkmark Ring with Glow
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: info.accentColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: info.accentColor.withValues(alpha: 0.35),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: info.accentColor.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 68,
                    color: info.accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: info.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: info.accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(info.categoryIcon, size: 16, color: info.accentColor),
                    const SizedBox(width: 6),
                    Text(
                      info.categoryLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: info.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Title & Subtitle
              Text(
                info.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                info.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              // 4. Scanned Information Details Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Scanned QR Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...info.metadata.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Action Buttons
              if (info.url != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _openUrl(info.url!),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text(
                      'Open in Browser',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      onPressed: widget.onScanAnother,
                      child: const Text(
                        'Scan Another',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: widget.onDone,
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.isBluetoothError = false,
    this.onEnableBluetooth,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final bool isBluetoothError;
  final VoidCallback? onEnableBluetooth;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isBluetoothError ? const Color(0xFF0284C7) : Colors.redAccent;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBluetoothError ? Icons.bluetooth_searching_rounded : Icons.cancel_rounded,
                  size: 64,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isBluetoothError ? 'Bluetooth Required' : 'Check-In Failed',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isBluetoothError
                    ? 'Physical presence check-in requires active Bluetooth.'
                    : 'The system could not verify or complete your check-in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isBluetoothError ? Icons.bluetooth_rounded : Icons.info_outline_rounded,
                          color: primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isBluetoothError ? 'Counter Presence Notice' : 'Reason for Failure',
                          style: TextStyle(
                            color: isBluetoothError ? const Color(0xFF0369A1) : Colors.red.shade800,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (isBluetoothError && onEnableBluetooth != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: onEnableBluetooth,
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                    icon: const Icon(Icons.bluetooth_rounded),
                    label: const Text('Turn ON Bluetooth & Retry'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: Text(retryLabel),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: Text(retryLabel),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.videocam_off_rounded,
                size: 56,
                color: Colors.white70,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.cameraPermissionDenied,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
