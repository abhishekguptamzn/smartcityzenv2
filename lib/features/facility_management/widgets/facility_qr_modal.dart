import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/utils/ble_presence_helper.dart';
import '../../../data/models/facility_model.dart';

void showFacilityQrModal({
  required BuildContext context,
  required FacilityKind kind,
  required String facilityId,
  required String facilityName,
  FacilityModel? facility,
  bool? bleVerificationEnabled,
  bool? bleStrictMode,
  String? bleServiceUuid,
  String? bleSecretKey,
  int? qrRotationInterval,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FacilityQrModalContent(
      kind: kind,
      facilityId: facilityId,
      facilityName: facilityName,
      facility: facility,
      bleVerificationEnabled: bleVerificationEnabled ?? facility?.bleVerificationEnabled ?? false,
      bleStrictMode: bleStrictMode ?? facility?.bleStrictMode ?? false,
      bleServiceUuid: bleServiceUuid ?? facility?.bleServiceUuid,
      bleSecretKey: bleSecretKey ?? facility?.bleSecretKey,
      qrRotationInterval: qrRotationInterval ?? facility?.qrRotationInterval ?? 15,
    ),
  );
}

class _FacilityQrModalContent extends StatefulWidget {
  const _FacilityQrModalContent({
    required this.kind,
    required this.facilityId,
    required this.facilityName,
    this.facility,
    this.bleVerificationEnabled = false,
    this.bleStrictMode = false,
    this.bleServiceUuid,
    this.bleSecretKey,
    this.qrRotationInterval = 15,
  });

  final FacilityKind kind;
  final String facilityId;
  final String facilityName;
  final FacilityModel? facility;
  final bool bleVerificationEnabled;
  final bool bleStrictMode;
  final String? bleServiceUuid;
  final String? bleSecretKey;
  final int qrRotationInterval;

  @override
  State<_FacilityQrModalContent> createState() => _FacilityQrModalContentState();
}

class _FacilityQrModalContentState extends State<_FacilityQrModalContent> {
  final FlutterBlePeripheral _blePeripheral = FlutterBlePeripheral();
  Timer? _timer;

  String _currentQrNonce = '';
  String _currentBleNonce = '';
  int _remainingSeconds = 15;
  int _totalInterval = 15;
  bool _isBroadcasting = false;
  bool _isBluetoothOn = true;

  @override
  void initState() {
    super.initState();
    _totalInterval = widget.qrRotationInterval > 4 ? widget.qrRotationInterval : 15;
    _updateNoncesAndBroadcast();

    if (widget.bleVerificationEnabled) {
      _checkAndPromptBluetooth();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickTimer();
    });
  }

  Future<void> _checkAndPromptBluetooth() async {
    try {
      final isEnabled = await BlePresenceHelper.isBluetoothEnabled();
      if (mounted) {
        setState(() => _isBluetoothOn = isEnabled);
      }
      if (!isEnabled) {
        final turnedOn = await BlePresenceHelper.requestEnableBluetooth();
        if (mounted) {
          setState(() => _isBluetoothOn = turnedOn);
        }
        if (turnedOn) {
          _updateNoncesAndBroadcast();
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopBleBroadcast();
    super.dispose();
  }

  void _tickTimer() {
    if (!mounted) return;

    final secret = widget.bleSecretKey ?? 'smart-cityzen-secret-${widget.facilityId}';
    final nonces = BlePresenceHelper.generateNonces(
      facilityId: widget.facilityId,
      secretKey: secret,
      intervalSeconds: _totalInterval,
    );

    final remaining = nonces['remaining_seconds'] as int;
    final newQrNonce = nonces['qr_nonce'] as String;
    final newBleNonce = nonces['ble_nonce'] as String;

    if (newQrNonce != _currentQrNonce || remaining > _remainingSeconds) {
      // Time window rotated
      setState(() {
        _currentQrNonce = newQrNonce;
        _currentBleNonce = newBleNonce;
        _remainingSeconds = remaining;
      });
      _startBleBroadcast(newBleNonce);
    } else {
      setState(() {
        _remainingSeconds = remaining;
      });
    }
  }

  void _updateNoncesAndBroadcast() {
    final secret = widget.bleSecretKey ?? 'smart-cityzen-secret-${widget.facilityId}';
    final nonces = BlePresenceHelper.generateNonces(
      facilityId: widget.facilityId,
      secretKey: secret,
      intervalSeconds: _totalInterval,
    );

    _currentQrNonce = nonces['qr_nonce'] as String;
    _currentBleNonce = nonces['ble_nonce'] as String;
    _remainingSeconds = nonces['remaining_seconds'] as int;

    if (widget.bleVerificationEnabled) {
      _startBleBroadcast(_currentBleNonce);
    }
  }

  Future<void> _startBleBroadcast(String bleNonce) async {
    if (!widget.bleVerificationEnabled) return;
    if (!Platform.isAndroid && !Platform.isIOS && !Platform.isMacOS) return;

    try {
      final serviceUuid = widget.bleServiceUuid ?? '0000aaaa-0000-1000-8000-00805f9b34fb';
      final advertiseData = AdvertiseData(
        serviceUuid: serviceUuid,
        serviceData: utf8.encode(bleNonce),
        includeDeviceName: false,
      );

      final isSupported = await _blePeripheral.isSupported;
      if (isSupported) {
        if (_isBroadcasting) {
          await _blePeripheral.stop();
        }
        await _blePeripheral.start(advertiseData: advertiseData);
        if (mounted) setState(() => _isBroadcasting = true);
      }
    } catch (_) {
      // Fail gracefully if peripheral mode is not permitted
    }
  }

  Future<void> _stopBleBroadcast() async {
    try {
      if (_isBroadcasting) {
        await _blePeripheral.stop();
        _isBroadcasting = false;
      }
    } catch (_) {}
  }

  String _buildQrPayload() {
    final Map<String, dynamic> data = {
      'type': 'facility_checkin',
      'facility_type': widget.kind.pathSegment,
      'facility_id': widget.facilityId,
      'facility_name': widget.facilityName,
    };

    if (widget.bleVerificationEnabled) {
      data['ble_required'] = true;
      data['ble_strict_mode'] = widget.bleStrictMode;
      data['qr_nonce'] = _currentQrNonce;
      data['service_uuid'] = widget.bleServiceUuid;
      data['interval'] = _totalInterval;
    }

    return jsonEncode(data);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor = isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);
    final qrPayload = _buildQrPayload();

    final progress = _totalInterval > 0 ? (_remainingSeconds / _totalInterval) : 1.0;

    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag pill
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),

              // Title and Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isGym
                              ? Icons.fitness_center_rounded
                              : (widget.kind == FacilityKind.library ? Icons.local_library_rounded : Icons.category_rounded),
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.facilityName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.kind.displayName} Check-in / Check-out QR',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // BLE Presence Active Indicator Banner
              if (widget.bleVerificationEnabled) ...[
                if (_isBluetoothOn)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bluetooth_searching_rounded,
                          size: 18,
                          color: Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'BLE Beacon Active (${widget.bleStrictMode ? "Strict Proximity" : "Hybrid Mode"})',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ),
                        // Countdown Ring
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 2.5,
                                color: const Color(0xFF0284C7),
                                backgroundColor: const Color(0xFF0284C7).withValues(alpha: 0.2),
                              ),
                            ),
                            Text(
                              '$_remainingSeconds',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      final turnedOn = await BlePresenceHelper.requestEnableBluetooth();
                      if (mounted) {
                        setState(() => _isBluetoothOn = turnedOn);
                      }
                      if (turnedOn) {
                        _updateNoncesAndBroadcast();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCD34D)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bluetooth_disabled_rounded,
                            size: 18,
                            color: Color(0xFFD97706),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Counter Bluetooth is OFF',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                                Text(
                                  'Running in Live Display QR Fallback Mode',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD97706),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Turn ON',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],

              // QR Code Container Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final logoUrl = widget.facility?.resolvedLogoUrl;
                        final hasLogo = logoUrl != null && logoUrl.isNotEmpty;

                        return SizedBox(
                          width: 210,
                          height: 210,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              QrImageView(
                                data: qrPayload,
                                version: QrVersions.auto,
                                size: 210,
                                backgroundColor: Colors.white,
                                eyeStyle: QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: isGym ? const Color(0xFF0F766E) : const Color(0xFF0369A1),
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Color(0xFF0F172A),
                                ),
                                errorCorrectionLevel: QrErrorCorrectLevel.M,
                              ),
                              if (hasLogo)
                                Opacity(
                                  opacity: 0.35,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        logoUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Scan Instruction Pill
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.qr_code_scanner_rounded, size: 20, color: primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.bleVerificationEnabled
                            ? 'Citizens scanning this QR must have Bluetooth turned on and stand near the counter. The code rotates every $_totalInterval seconds.'
                            : 'Citizens and members can scan this QR code with their Smart Cityzen app scanner to check-in or check-out.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: scheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                  label: const Text('Done'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
