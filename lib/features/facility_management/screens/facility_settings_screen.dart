import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/image_url_resolver.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_physical_presence_sheet.dart';
import '../widgets/facility_qr_modal.dart';
import 'facility_dashboard_screen.dart';

final facilityDetailSettingsProvider = FutureProvider.autoDispose
    .family<FacilityModel, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getFacilityDetails(args.$1, args.$2);
});

class FacilitySettingsScreen extends ConsumerStatefulWidget {
  const FacilitySettingsScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilitySettingsScreen> createState() =>
      _FacilitySettingsScreenState();
}

class _FacilitySettingsScreenState extends ConsumerState<FacilitySettingsScreen> {
  FacilityModel? _currentFacility;

  @override
  void initState() {
    super.initState();
    _currentFacility = widget.facility;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.kind == FacilityKind.gym
        ? const Color(0xFF0D9488)
        : (widget.kind == FacilityKind.activity
            ? const Color(0xFF1565D8)
            : const Color(0xFF0284C7));

    final facilityAsync = ref.watch(
      facilityDetailSettingsProvider((widget.kind, widget.facilityId)),
    );

    final f = facilityAsync.value ?? _currentFacility ?? widget.facility;
    final isGym = widget.kind == FacilityKind.gym;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/client/facilities');
            }
          },
        ),
        title: const Text('Facility Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Settings',
            onPressed: () {
              ref.invalidate(
                facilityDetailSettingsProvider((widget.kind, widget.facilityId)),
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            // Top Facility Summary Card
            if (f != null)
              _buildFacilityHeaderCard(
                context,
                f,
                isDark,
                primaryColor,
                isGym,
                scheme,
              ),
            const SizedBox(height: 20),

            // SECTION 1: PROFILE & GENERAL DETAILS
            _buildSectionHeader('PROFILE & GENERAL DETAILS', scheme),
            const SizedBox(height: 8),
            _buildSettingsTile(
              context: context,
              icon: Icons.edit_note_rounded,
              iconColor: const Color(0xFF0D9488),
              iconBg: const Color(0xFFECFDF5),
              title: 'Edit Facility Details',
              subtitle: 'Name, address, contact, amenities & photos',
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () async {
                HapticFeedback.lightImpact();
                await context.push(
                  '/client/manage/edit/${widget.kind.pathSegment}/${widget.facilityId}',
                  extra: f,
                );
                ref.invalidate(
                  facilityDetailSettingsProvider((widget.kind, widget.facilityId)),
                );
                ref.invalidate(myOwnedFacilitiesProvider);
              },
            ),
            const SizedBox(height: 8),
            _buildSettingsTile(
              context: context,
              icon: Icons.schedule_rounded,
              iconColor: const Color(0xFF2563EB),
              iconBg: const Color(0xFFEFF6FF),
              title: 'Operating Hours',
              subtitle: _formatOperatingHoursSubtitle(f),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      f?.operatingHoursMap != null ? 'Weekly' : 'Daily',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
              onTap: () async {
                HapticFeedback.lightImpact();
                await context.push(
                  '/client/manage/operating-hours/${widget.kind.pathSegment}/${widget.facilityId}',
                  extra: f,
                );
                ref.invalidate(
                  facilityDetailSettingsProvider((widget.kind, widget.facilityId)),
                );
                ref.invalidate(myOwnedFacilitiesProvider);
              },
            ),
            const SizedBox(height: 24),

            // SECTION 2: ATTENDANCE & CHECK-OUT CONFIGURATION
            _buildSectionHeader('ATTENDANCE & CHECK-OUT CONFIGURATION', scheme),
            const SizedBox(height: 8),
            _buildSettingsToggleTile(
              context: context,
              icon: Icons.qr_code_scanner_rounded,
              iconColor: const Color(0xFFF59E0B),
              iconBg: const Color(0xFFFEF3C7),
              title: 'Member Check-Out Tracking',
              subtitle: f?.checkoutEnabled == true
                  ? 'ON: Citizens check-in and check-out (2 scans). Active visits tracked in real time.'
                  : 'OFF (Single-Scan Mode): Check-in immediately records completed visit. Check-out notifications suppressed.',
              value: f?.checkoutEnabled ?? true,
              onChanged: (val) => _saveFacilitySetting('checkout_enabled', val),
            ),
            if (f?.checkoutEnabled == true) ...[
              const SizedBox(height: 8),
              _buildSettingsTile(
                context: context,
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFFEA580C),
                iconBg: const Color(0xFFFFEDD5),
                title: 'Auto-Checkout Duration Limit',
                subtitle: f?.defaultCheckoutDurationMinutes != null && f!.defaultCheckoutDurationMinutes > 0
                    ? 'Active: Visits exceeding ${f.defaultCheckoutDurationMinutes} min are auto checked out'
                    : 'Disabled (Tap to set duration limit)',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (f?.defaultCheckoutDurationMinutes != null && f!.defaultCheckoutDurationMinutes > 0)
                            ? const Color(0xFFEA580C).withValues(alpha: 0.12)
                            : Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (f?.defaultCheckoutDurationMinutes != null && f!.defaultCheckoutDurationMinutes > 0)
                            ? '${f.defaultCheckoutDurationMinutes} min'
                            : 'None',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (f?.defaultCheckoutDurationMinutes != null && f!.defaultCheckoutDurationMinutes > 0)
                              ? const Color(0xFFC2410C)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 20),
                  ],
                ),
                onTap: () => _showDurationPicker(context, f?.defaultCheckoutDurationMinutes ?? 120),
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                context: context,
                icon: Icons.alarm_on_rounded,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                title: 'Fixed Daily Auto-Checkout Time',
                subtitle: (f?.defaultCheckoutTime != null && f!.defaultCheckoutTime!.isNotEmpty)
                    ? 'Active: All checked-in members will be auto checked out at ${f.defaultCheckoutTime}'
                    : 'Set a fixed daily closing time to auto check out all members',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (f?.defaultCheckoutTime != null && f!.defaultCheckoutTime!.isNotEmpty)
                            ? const Color(0xFFD97706).withValues(alpha: 0.15)
                            : Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (f?.defaultCheckoutTime != null && f!.defaultCheckoutTime!.isNotEmpty)
                            ? f.defaultCheckoutTime!
                            : 'None',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (f?.defaultCheckoutTime != null && f!.defaultCheckoutTime!.isNotEmpty)
                              ? const Color(0xFFB45309)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 20),
                  ],
                ),
                onTap: () => _showTimePickerForAutoCheckout(context, f?.defaultCheckoutTime),
              ),
            ],
            const SizedBox(height: 24),

            // SECTION 3: BATCH MANAGEMENT
            _buildSectionHeader('BATCH MANAGEMENT', scheme),
            const SizedBox(height: 8),
            _buildSettingsToggleTile(
              context: context,
              icon: Icons.groups_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBg: const Color(0xFFE0F2FE),
              title: 'Batch Management',
              subtitle: f?.batchManagementEnabled == true
                  ? 'Active: Fixed time slots, capacity limits, batch fees & daily roster attendance.'
                  : 'Disabled: All members follow open general access / standard fee plans.',
              value: f?.batchManagementEnabled ?? false,
              onChanged: (val) => _saveFacilitySetting('batch_management_enabled', val),
            ),
            if (f?.batchManagementEnabled == true) ...[
              const SizedBox(height: 8),
              _buildSettingsTile(
                context: context,
                icon: Icons.event_note_rounded,
                iconColor: const Color(0xFF1565D8),
                iconBg: const Color(0xFFEFF6FF),
                title: 'Manage Batches',
                subtitle: 'View batches, schedules, participant capacities & daily rosters',
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(
                    '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}',
                    extra: f,
                  );
                },
              ),
            ],
            const SizedBox(height: 24),

            // SECTION 4: PHYSICAL PRESENCE & SECURITY
            _buildSectionHeader('PHYSICAL PRESENCE & SECURITY', scheme),
            const SizedBox(height: 8),
            _buildSettingsTile(
              context: context,
              icon: Icons.bluetooth_searching_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBg: const Color(0xFFF0F9FF),
              title: 'Physical Presence (BLE Settings)',
              subtitle: f?.bleVerificationEnabled == true
                  ? 'Active • ${f?.bleStrictMode == true ? "Strict Enforcement" : "Dynamic Fallback"} (${f?.bleProximitySensitivity.toUpperCase() ?? "HIGH"})'
                  : 'Disabled • Turn on dual-verification at counter',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (f?.bleVerificationEnabled == true
                              ? const Color(0xFF10B981)
                              : Colors.grey)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      f?.bleVerificationEnabled == true ? 'ACTIVE' : 'OFF',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: f?.bleVerificationEnabled == true
                            ? const Color(0xFF059669)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
              onTap: () async {
                HapticFeedback.lightImpact();
                final updated = await showFacilityPhysicalPresenceSheet(
                  context: context,
                  kind: widget.kind,
                  facilityId: widget.facilityId,
                  facility: f,
                );
                if (updated != null) {
                  setState(() => _currentFacility = updated);
                  ref.invalidate(
                    facilityDetailSettingsProvider((widget.kind, widget.facilityId)),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            _buildSettingsTile(
              context: context,
              icon: Icons.qr_code_2_rounded,
              iconColor: const Color(0xFF8B5CF6),
              iconBg: const Color(0xFFF5F3FF),
              title: 'Live QR Turnstile Screen',
              subtitle: 'Display live counter QR with rotating TOTP & BLE broadcast',
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              onTap: () {
                HapticFeedback.lightImpact();
                if (f != null) {
                  showFacilityQrModal(
                    context: context,
                    kind: widget.kind,
                    facilityId: widget.facilityId,
                    facilityName: f.name,
                    facility: f,
                  );
                }
              },
            ),
            const SizedBox(height: 24),

            // SECTION 5: OPERATIONS & MANAGEMENT SHORTCUTS
            _buildSectionHeader('MEMBERSHIP & COMMUNICATION', scheme),
            const SizedBox(height: 8),
            _buildSettingsTile(
              context: context,
              icon: Icons.payments_rounded,
              iconColor: const Color(0xFF10B981),
              iconBg: const Color(0xFFECFDF5),
              title: 'Fee Plans & Pricing',
              subtitle: 'Create, modify and archive facility plans',
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.push(
                '/client/manage/plans/${widget.kind.pathSegment}/${widget.facilityId}',
                extra: f,
              ),
            ),
            const SizedBox(height: 8),
            _buildSettingsTile(
              context: context,
              icon: Icons.send_rounded,
              iconColor: const Color(0xFF2563EB),
              iconBg: const Color(0xFFEFF6FF),
              title: 'Broadcast & Member Communication',
              subtitle: 'Send SMS, email or notifications to registered members',
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.push(
                '/client/manage/communication/${widget.kind.pathSegment}/${widget.facilityId}',
                extra: f,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFacilitySetting(String key, dynamic value) async {
    await _saveFacilitySettings({key: value});
  }

  Future<void> _saveFacilitySettings(Map<String, dynamic> patch) async {
    HapticFeedback.selectionClick();
    final previous = _currentFacility;

    // Optimistically update local state so switches/inputs respond instantly
    if (previous != null) {
      setState(() {
        var updated = previous;
        if (patch.containsKey('checkout_enabled')) {
          updated = updated.copyWith(checkoutEnabled: patch['checkout_enabled'] as bool);
        }
        if (patch.containsKey('batch_management_enabled')) {
          updated = updated.copyWith(batchManagementEnabled: patch['batch_management_enabled'] as bool);
        }
        if (patch.containsKey('default_checkout_duration_minutes')) {
          updated = updated.copyWith(
            defaultCheckoutDurationMinutes: (patch['default_checkout_duration_minutes'] as int?) ?? 0,
            defaultCheckoutTime: patch.containsKey('default_checkout_time') ? (patch['default_checkout_time'] as String?) : updated.defaultCheckoutTime,
          );
        }
        if (patch.containsKey('default_checkout_time')) {
          updated = updated.copyWith(
            defaultCheckoutTime: patch['default_checkout_time'] as String?,
          );
        }
        _currentFacility = updated;
      });
    }

    try {
      final updated = await ref
          .read(clientFacilityRepositoryProvider)
          .updateFacilityDetails(widget.kind, widget.facilityId, patch);
      setState(() => _currentFacility = updated);
      ref.invalidate(facilityDetailSettingsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Setting updated successfully'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (previous != null) {
        setState(() => _currentFacility = previous);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update setting: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _showTimePickerForAutoCheckout(BuildContext context, String? currentTime) async {
    HapticFeedback.lightImpact();
    TimeOfDay initial = const TimeOfDay(hour: 22, minute: 0);
    if (currentTime != null && currentTime.isNotEmpty) {
      final parts = currentTime.split(':');
      if (parts.length >= 2) {
        initial = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 22,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: 'SELECT DAILY AUTO-CHECKOUT TIME',
      confirmText: 'SET TIME',
      cancelText: 'CANCEL',
    );

    if (picked != null) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      await _saveFacilitySettings({
        'default_checkout_time': formatted,
        'default_checkout_duration_minutes': null,
      });
    }
  }

  void _showDurationPicker(BuildContext context, int currentMinutes) {
    HapticFeedback.lightImpact();
    final options = [30, 45, 60, 90, 120, 150, 180, 240, 360, 480];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Default Auto-Checkout Limit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Visits exceeding this duration are automatically checked out. Setting this will clear the fixed daily time.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((mins) {
                  final isSelected = mins == currentMinutes;
                  return ChoiceChip(
                    label: Text(
                      mins >= 60 ? '${mins ~/ 60}h ${mins % 60 > 0 ? "${mins % 60}m" : ""}'.trim() : '$mins mins',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        Navigator.pop(ctx);
                        _saveFacilitySettings({
                          'default_checkout_duration_minutes': mins,
                          'default_checkout_time': null,
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsToggleTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: scheme.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.25,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ));
  }

  Widget _buildFacilityHeaderCard(
    BuildContext context,
    FacilityModel f,
    bool isDark,
    Color primaryColor,
    bool isGym,
    ColorScheme scheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFEDF2F7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFDBEAFE),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: (f.logoUrl != null && f.logoUrl!.trim().isNotEmpty)
                  ? AppNetworkImage(
                      imageUrl: ImageUrlResolver.resolve(f.logoUrl!.trim()),
                      fit: BoxFit.cover,
                      width: 46,
                      height: 46,
                    )
                  : Center(
                      child: Icon(
                        isGym ? Icons.fitness_center_rounded : Icons.menu_book_rounded,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        f.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  f.address ?? f.city?.name ?? 'Assigned Facility',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatOperatingHoursSubtitle(FacilityModel? f) {
    if (f == null) return 'Configure daily timings';
    final opHours = f.operatingHoursMap;
    if (opHours != null && opHours.isNotEmpty) {
      final closedDays = <String>[];
      final daysOrder = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
      final shortNames = {'monday': 'Mon', 'tuesday': 'Tue', 'wednesday': 'Wed', 'thursday': 'Thu', 'friday': 'Fri', 'saturday': 'Sat', 'sunday': 'Sun'};
      
      for (final k in daysOrder) {
        if (opHours[k] is Map && (opHours[k]['is_closed'] == true || opHours[k]['closed'] == true)) {
          closedDays.add(shortNames[k] ?? k);
        }
      }

      final mon = opHours['monday'] is Map ? opHours['monday'] as Map : null;
      final openStr = mon?['open'] ?? f.openingTime ?? '07:00';
      final closeStr = mon?['close'] ?? f.closingTime ?? '20:00';

      if (closedDays.isNotEmpty) {
        return '$openStr – $closeStr (${closedDays.join(", ")} Closed)';
      }
      return '$openStr – $closeStr (Open 7 Days)';
    }

    return '${f.openingTime ?? "07:00 AM"} – ${f.closingTime ?? "08:00 PM"}';
  }
}

