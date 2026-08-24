import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';

enum _ScanStep { scanning, scanned, processing, success, error }

/// Creative Citizen QR Scanner Popup Modal for Facility Manual Check-In
class CitizenManualCheckinQrModal extends ConsumerStatefulWidget {
  const CitizenManualCheckinQrModal({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
    this.onScanComplete,
    this.onCodeScanned,
  });

  final FacilityKind kind;
  final String facilityId;
  final dynamic facility;
  final VoidCallback? onScanComplete;
  final ValueChanged<String>? onCodeScanned;

  static Future<void> show({
    required BuildContext context,
    required FacilityKind kind,
    required String facilityId,
    dynamic facility,
    VoidCallback? onScanComplete,
    ValueChanged<String>? onCodeScanned,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CitizenManualCheckinQrModal(
        kind: kind,
        facilityId: facilityId,
        facility: facility,
        onScanComplete: onScanComplete,
        onCodeScanned: onCodeScanned,
      ),
    );
  }

  @override
  ConsumerState<CitizenManualCheckinQrModal> createState() =>
      _CitizenManualCheckinQrModalState();
}

class _CitizenManualCheckinQrModalState
    extends ConsumerState<CitizenManualCheckinQrModal>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _scannerController;
  late final AnimationController _laserAnimController;

  _ScanStep _currentStep = _ScanStep.scanning;
  String _scannedCode = '';
  String _statusMessage = '';
  String _errorMessage = '';
  bool _torchOn = false;
  bool _isCheckInAction = true;
  DateTime? _actionTimestamp;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _laserAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserAnimController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  String _getFacilityName() {
    final fac = widget.facility;
    if (fac is FacilityModel) {
      return fac.name;
    } else if (fac is Map) {
      return fac['name']?.toString() ??
          fac['title']?.toString() ??
          _defaultFacilityName();
    }
    return _defaultFacilityName();
  }

  String _defaultFacilityName() {
    switch (widget.kind) {
      case FacilityKind.gym:
        return 'Fitness & Gym Center';
      case FacilityKind.library:
        return 'Heritage Library';
      case FacilityKind.activity:
        return 'Activity Center';
    }
  }

  IconData _getFacilityIcon() {
    switch (widget.kind) {
      case FacilityKind.gym:
        return Icons.fitness_center_rounded;
      case FacilityKind.library:
        return Icons.local_library_rounded;
      case FacilityKind.activity:
        return Icons.sports_basketball_rounded;
    }
  }

  Color _getPrimaryColor() {
    switch (widget.kind) {
      case FacilityKind.gym:
        return const Color(0xFF0D9488);
      case FacilityKind.library:
        return const Color(0xFF0284C7);
      case FacilityKind.activity:
        return const Color(0xFFEA580C);
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_currentStep != _ScanStep.scanning) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final raw = barcodes.first.rawValue;
    if (raw == null || raw.trim().isEmpty) return;

    HapticFeedback.mediumImpact();
    final extractedCode = _extractCitizenCode(raw.trim());

    setState(() {
      _scannedCode = extractedCode;
      _currentStep = _ScanStep.scanned;
    });

    widget.onCodeScanned?.call(extractedCode);
  }

  String _extractCitizenCode(String raw) {
    if (raw.startsWith('{') && raw.endsWith('}')) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return decoded['member_id']?.toString() ??
            decoded['citizen_id']?.toString() ??
            decoded['user_id']?.toString() ??
            decoded['pass_id']?.toString() ??
            decoded['code']?.toString() ??
            decoded['id']?.toString() ??
            raw;
      } catch (_) {}
    }
    return raw;
  }

  Future<void> _executeDeskAction(bool isCheckIn) async {
    if (_scannedCode.isEmpty) return;

    setState(() {
      _isCheckInAction = isCheckIn;
      _currentStep = _ScanStep.processing;
      _errorMessage = '';
    });

    final repo = ref.read(clientFacilityRepositoryProvider);
    final facilityName = _getFacilityName();

    try {
      HapticFeedback.mediumImpact();
      if (isCheckIn) {
        final res = await repo.checkIn(
          widget.kind,
          widget.facilityId,
          memberId: _scannedCode,
          allowOverride: true,
        );
        final already = res['already_checked_in'] == true;
        _actionTimestamp = DateTime.now();

        setState(() {
          _currentStep = _ScanStep.success;
          _statusMessage = already
              ? 'Citizen $_scannedCode is already checked in to $facilityName.'
              : 'Done! Scanned Check-In & Entry Successful to $facilityName.';
        });
      } else {
        await repo.checkOut(
          widget.kind,
          widget.facilityId,
          memberId: _scannedCode,
        );
        _actionTimestamp = DateTime.now();

        setState(() {
          _currentStep = _ScanStep.success;
          _statusMessage =
              'Done! Scanned Check-Out Recorded for $_scannedCode from $facilityName.';
        });
      }

      widget.onScanComplete?.call();
    } catch (e) {
      setState(() {
        _currentStep = _ScanStep.error;
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    }
  }

  void _resetToScanning() {
    setState(() {
      _scannedCode = '';
      _currentStep = _ScanStep.scanning;
      _errorMessage = '';
      _statusMessage = '';
    });
  }

  void _toggleTorch() async {
    try {
      await _scannerController.toggleTorch();
      setState(() => _torchOn = !_torchOn);
    } catch (_) {}
  }

  void _switchCamera() async {
    try {
      await _scannerController.switchCamera();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = _getPrimaryColor();
    final facilityName = _getFacilityName();
    final facilityIcon = _getFacilityIcon();
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Top Header: Facility Center & Scan QR Info
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 14, 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(facilityIcon, color: primaryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.kind.displayName.toUpperCase(),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Desk Check-In',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          facilityName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Torch Toggle & Switch Camera
                  if (_currentStep == _ScanStep.scanning) ...[
                    IconButton(
                      icon: Icon(
                        _torchOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        color: _torchOn
                            ? const Color(0xFFF59E0B)
                            : (isDark ? Colors.white70 : Colors.black54),
                        size: 20,
                      ),
                      tooltip: 'Toggle Flashlight',
                      onPressed: _toggleTorch,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.flip_camera_ios_rounded,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 20,
                      ),
                      tooltip: 'Switch Camera',
                      onPressed: _switchCamera,
                    ),
                  ],
                  // Close Button
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Guidance Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code_scanner_rounded,
                      color: primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Scan QR of citizen to manual check-in to $facilityName',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : const Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Dynamic Body Section Based on Step
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildStepContent(context, primaryColor, isDark),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(
      BuildContext context, Color primaryColor, bool isDark) {
    switch (_currentStep) {
      case _ScanStep.scanning:
        return _buildScannerViewport(primaryColor, isDark);
      case _ScanStep.scanned:
        return _buildScannedActionCard(primaryColor, isDark);
      case _ScanStep.processing:
        return _buildProcessingCard(primaryColor, isDark);
      case _ScanStep.success:
        return _buildSuccessCard(primaryColor, isDark);
      case _ScanStep.error:
        return _buildErrorCard(primaryColor, isDark);
    }
  }

  /// Scanning Viewport with MobileScanner & Glowing Corner Overlay
  Widget _buildScannerViewport(Color primaryColor, bool isDark) {
    const frameSize = 250.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: frameSize,
          height: frameSize,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onBarcodeDetected,
                  errorBuilder: (ctx, error) => Container(
                    color: const Color(0xFF0F172A),
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.camera_alt_outlined,
                            color: Colors.white54, size: 36),
                        const SizedBox(height: 8),
                        const Text(
                          'Camera Access Needed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please allow camera permissions to scan citizen QR codes.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Corner Frame Painter
                CustomPaint(
                  size: const Size(frameSize, frameSize),
                  painter: _ScannerCornerPainter(
                    color: const Color(0xFF10B981), // Glowing Emerald
                  ),
                ),

                // Scanning Laser Animation
                AnimatedBuilder(
                  animation: _laserAnimController,
                  builder: (context, child) {
                    final position =
                        _laserAnimController.value * (frameSize - 30);
                    return Positioned(
                      top: 15 + position,
                      left: 18,
                      right: 18,
                      child: Container(
                        height: 2.5,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFF10B981),
                              Color(0xFF34D399),
                              Color(0xFF10B981),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.center_focus_strong_rounded,
                size: 14, color: Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              'Align Citizen QR code inside the box to scan',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Scanned Action Card: Display scanned code with 1-tap Check-In / Check-Out
  Widget _buildScannedActionCard(Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: Color(0xFF10B981),
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Citizen QR Scanned!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_pin_rounded, size: 16, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  _scannedCode,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Action Buttons: Check In & Check Out
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _executeDeskAction(true),
                  icon: const Icon(Icons.login_rounded, size: 16),
                  label: const Text('Check In & Entry',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _executeDeskAction(false),
                  icon: const Icon(Icons.logout_rounded, size: 16),
                  label: const Text('Check Out',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _resetToScanning,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Scan Another QR Code'),
          ),
        ],
      ),
    );
  }

  /// Processing State Card
  Widget _buildProcessingCard(Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                _isCheckInAction ? const Color(0xFF059669) : const Color(0xFFDC2626)),
          ),
          const SizedBox(height: 16),
          Text(
            _isCheckInAction
                ? 'Logging manual check-in entry...'
                : 'Logging check-out...',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Processing Citizen Code: $_scannedCode',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  /// Success State Card: Displays Done! Scanned check-in and entry
  Widget _buildSuccessCard(Color primaryColor, bool isDark) {
    final timeStr = _actionTimestamp != null
        ? DateFormat('hh:mm a').format(_actionTimestamp!)
        : 'Just now';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Check Badge
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFECFDF5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF059669),
              size: 42,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isCheckInAction ? 'Entry Logged Done! 🎉' : 'Check-Out Done! 👋',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF059669),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),

          // Details summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.badge_rounded,
                        size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Text(
                      '#$_scannedCode',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetToScanning,
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                  label: const Text('Scan Next Citizen',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Error State Card
  Widget _buildErrorCard(Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF2F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFEF4444),
              size: 32,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Action Failed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _errorMessage.isNotEmpty
                ? _errorMessage
                : 'Could not log entry for citizen pass. Please check citizen validity or network.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetToScanning,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Scan Again'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => _executeDeskAction(_isCheckInAction),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Retry Entry'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom corner brackets painter for the scanner viewfinder
class _ScannerCornerPainter extends CustomPainter {
  const _ScannerCornerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const armLength = 26.0;
    const inset = 6.0;

    void drawCorner(Offset origin, Offset dx, Offset dy) {
      canvas.drawLine(origin, origin + dx * armLength, paint);
      canvas.drawLine(origin, origin + dy * armLength, paint);
    }

    // Top-left
    drawCorner(
        const Offset(inset, inset), const Offset(1, 0), const Offset(0, 1));
    // Top-right
    drawCorner(Offset(size.width - inset, inset), const Offset(-1, 0),
        const Offset(0, 1));
    // Bottom-left
    drawCorner(Offset(inset, size.height - inset), const Offset(1, 0),
        const Offset(0, -1));
    // Bottom-right
    drawCorner(Offset(size.width - inset, size.height - inset),
        const Offset(-1, 0), const Offset(0, -1));
  }

  @override
  bool shouldRepaint(_ScannerCornerPainter oldDelegate) =>
      oldDelegate.color != color;
}
