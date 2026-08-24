import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/ble_presence_helper.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/helpers/app_snack_bar.dart';
import '../screens/facility_dashboard_screen.dart';

/// Opens the dedicated Physical Presence & BLE Security settings bottom sheet.
Future<FacilityModel?> showFacilityPhysicalPresenceSheet({
  required BuildContext context,
  required FacilityKind kind,
  required String facilityId,
  required FacilityModel? facility,
}) {
  return showModalBottomSheet<FacilityModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FacilityPhysicalPresenceSheet(
      kind: kind,
      facilityId: facilityId,
      facility: facility,
    ),
  );
}

class _FacilityPhysicalPresenceSheet extends ConsumerStatefulWidget {
  const _FacilityPhysicalPresenceSheet({
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<_FacilityPhysicalPresenceSheet> createState() =>
      _FacilityPhysicalPresenceSheetState();
}

class _FacilityPhysicalPresenceSheetState
    extends ConsumerState<_FacilityPhysicalPresenceSheet> {
  bool _bleEnabled = false;
  bool _bleStrictMode = false;
  String _bleSensitivity = 'high';
  String _bleServiceUuid = '';
  int _qrInterval = 15;
  bool _isSaving = false;
  bool _isBluetoothOn = true;

  @override
  void initState() {
    super.initState();
    _bleEnabled = widget.facility?.bleVerificationEnabled ?? false;
    _bleStrictMode = widget.facility?.bleStrictMode ?? false;
    _bleSensitivity = widget.facility?.bleProximitySensitivity ?? 'high';
    _bleServiceUuid = widget.facility?.bleServiceUuid ?? const Uuid().v4();
    _qrInterval = widget.facility?.qrRotationInterval ?? 15;

    _checkBluetoothHardware();
  }

  Future<void> _checkBluetoothHardware() async {
    try {
      final isEnabled = await BlePresenceHelper.isBluetoothEnabled();
      if (mounted) {
        setState(() => _isBluetoothOn = isEnabled);
      }
    } catch (_) {}
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final newUuid = const Uuid().v4();
      _bleServiceUuid = newUuid;
      final payload = <String, dynamic>{
        'ble_verification_enabled': _bleEnabled,
        'ble_strict_mode': _bleStrictMode,
        'ble_proximity_sensitivity': _bleSensitivity,
        'ble_service_uuid': newUuid,
        'qr_rotation_interval': _qrInterval,
      };

      final updated = await repo.updateFacilityDetails(
        widget.kind,
        widget.facilityId,
        payload,
      );

      ref.invalidate(myOwnedFacilitiesProvider);
      ref.invalidate(
        facilityStatsProvider((widget.kind, widget.facilityId)),
      );

      if (!mounted) return;
      AppSnackBar.success(
        context,
        'Physical presence & BLE settings updated successfully',
      );
      Navigator.of(context).pop(updated);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        'Failed to update BLE settings: $e',
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    const bluetoothBlue = Color(0xFF0284C7);
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bluetoothBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bluetooth_searching_rounded,
                    color: bluetoothBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Physical Presence Settings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'BLE proximity & anti-spoofing turnstile rules',
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Settings Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                // Master Verification Toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _bleEnabled
                          ? bluetoothBlue.withValues(alpha: 0.5)
                          : cardBorder,
                      width: _bleEnabled ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BLE Physical Presence Check',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Requires citizens to be physically present in front of counter beacon when scanning QR.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: scheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch.adaptive(
                        value: _bleEnabled,
                        activeTrackColor: bluetoothBlue,
                        activeThumbColor: Colors.white,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _bleEnabled = val;
                            if (_bleEnabled && _bleServiceUuid.isEmpty) {
                              _bleServiceUuid = const Uuid().v4();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (_bleEnabled) ...[
                  // Hardware Status Alert if Bluetooth is off
                  if (!_isBluetoothOn)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFD97706), size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Device Bluetooth is currently disabled. Enable Bluetooth to broadcast turnstile beacon.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final turnedOn =
                                  await BlePresenceHelper.requestEnableBluetooth();
                              setState(() => _isBluetoothOn = turnedOn);
                            },
                            child: const Text('Enable'),
                          ),
                        ],
                      ),
                    ),

                  // Enforcement Mode Selector
                  Text(
                    'ENFORCEMENT MODE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _bleStrictMode = false);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: !_bleStrictMode
                                  ? bluetoothBlue.withValues(alpha: 0.1)
                                  : cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !_bleStrictMode
                                    ? bluetoothBlue
                                    : cardBorder,
                                width: !_bleStrictMode ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sync_rounded,
                                      size: 16,
                                      color: !_bleStrictMode
                                          ? bluetoothBlue
                                          : scheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Dynamic Fallback',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: !_bleStrictMode
                                            ? bluetoothBlue
                                            : scheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Permits secure rotating TOTP if beacon is temporarily unavailable.',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _bleStrictMode = true);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _bleStrictMode
                                  ? const Color(0xFFDC2626).withValues(alpha: 0.1)
                                  : cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _bleStrictMode
                                    ? const Color(0xFFDC2626)
                                    : cardBorder,
                                width: _bleStrictMode ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lock_rounded,
                                      size: 16,
                                      color: _bleStrictMode
                                          ? const Color(0xFFDC2626)
                                          : scheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Strict Only',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: _bleStrictMode
                                            ? const Color(0xFFDC2626)
                                            : scheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Strictly mandates live BLE radio reception near counter.',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Proximity Range Sensitivity
                  Text(
                    'PROXIMITY RANGE SENSITIVITY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSensitivityChip('low', 'Wide (10m)', cardBg, cardBorder),
                      const SizedBox(width: 8),
                      _buildSensitivityChip('medium', 'Normal (4m)', cardBg, cardBorder),
                      const SizedBox(width: 8),
                      _buildSensitivityChip('high', 'Strict (1.5m)', cardBg, cardBorder),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // QR Rotation Interval
                  Text(
                    'ANTI-SPOOFING QR ROTATION INTERVAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [10, 15, 30, 60].map((sec) {
                      final isSelected = _qrInterval == sec;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                '${sec}s',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : scheme.onSurface,
                                ),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: bluetoothBlue,
                            onSelected: (val) {
                              if (val) setState(() => _qrInterval = sec);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Save Button
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(
                  _isSaving ? 'Saving Changes...' : 'Save Settings',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bluetoothBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isSaving ? null : _saveSettings,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensitivityChip(
    String value,
    String label,
    Color cardBg,
    Color cardBorder,
  ) {
    final isSelected = _bleSensitivity == value;
    const bluetoothBlue = Color(0xFF0284C7);

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _bleSensitivity = value);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? bluetoothBlue.withValues(alpha: 0.12)
                : cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? bluetoothBlue : cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? bluetoothBlue : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
