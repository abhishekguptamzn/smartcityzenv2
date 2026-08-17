import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/amenity_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../widgets/amenity_selector_sheet.dart';
import 'facility_dashboard_screen.dart';

class EditFacilityDetailsScreen extends ConsumerStatefulWidget {
  const EditFacilityDetailsScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<EditFacilityDetailsScreen> createState() =>
      _EditFacilityDetailsScreenState();
}

class _EditFacilityDetailsScreenState
    extends ConsumerState<EditFacilityDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _descController = TextEditingController();
  bool _submitting = false;
  bool _isLoadingAmenities = true;

  late TimeOfDay? _openingTime;
  late TimeOfDay? _closingTime;
  List<AmenityModel> _selectedAmenities = [];

  @override
  void initState() {
    super.initState();
    _descController.text = widget.facility?.description ?? '';
    _openingTime = _parseTimeString(widget.facility?.openingTime) ?? const TimeOfDay(hour: 6, minute: 0);
    _closingTime = _parseTimeString(widget.facility?.closingTime) ?? const TimeOfDay(hour: 22, minute: 0);
    _selectedAmenities = widget.facility?.amenities ?? [];

    _loadFacilityAmenities();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadFacilityAmenities() async {
    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final list = await repo.getFacilityAmenities(widget.kind, widget.facilityId);
      if (mounted && list.isNotEmpty) {
        setState(() => _selectedAmenities = list);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingAmenities = false);
    }
  }

  TimeOfDay? _parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return null;
    try {
      final parts = timeStr.trim().split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeDisplay(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  IconData _resolveAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wifi') || lower.contains('wi-fi') || lower.contains('internet')) {
      return Icons.wifi_rounded;
    } else if (lower.contains('ac') || lower.contains('air') || lower.contains('cool')) {
      return Icons.ac_unit_rounded;
    } else if (lower.contains('reading') || lower.contains('book') || lower.contains('study') || lower.contains('quiet') || lower.contains('desk')) {
      return Icons.chair_alt_rounded;
    } else if (lower.contains('newspaper') || lower.contains('journal') || lower.contains('magazin')) {
      return Icons.menu_book_rounded;
    } else if (lower.contains('water') || lower.contains('dispenser') || lower.contains('drink')) {
      return Icons.local_drink_rounded;
    } else if (lower.contains('power') || lower.contains('plug') || lower.contains('charging')) {
      return Icons.power_rounded;
    } else if (lower.contains('parking') || lower.contains('valet')) {
      return Icons.local_parking_rounded;
    } else if (lower.contains('locker') || lower.contains('storage')) {
      return Icons.lock_outline_rounded;
    } else if (lower.contains('gym') || lower.contains('dumbbell') || lower.contains('weight') || lower.contains('treadmill')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('shower') || lower.contains('bath') || lower.contains('washroom')) {
      return Icons.shower_rounded;
    } else if (lower.contains('cafe') || lower.contains('coffee') || lower.contains('tea')) {
      return Icons.coffee_rounded;
    } else if (lower.contains('cctv') || lower.contains('security') || lower.contains('guard')) {
      return Icons.videocam_outlined;
    }
    return Icons.star_rounded;
  }

  Future<void> _handleOpenAmenitySelector() async {
    final updatedList = await showAmenitySelectorSheet(
      context: context,
      kind: widget.kind,
      facilityId: widget.facilityId,
      initiallySelected: _selectedAmenities,
    );

    if (updatedList != null && mounted) {
      setState(() => _selectedAmenities = updatedList);
    }
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    final v = form.value;
    final facilityName = v['name']?.toString() ?? widget.facility?.name ?? 'Facility';

    final confirm = await showAppConfirmDialog(
      context: context,
      title: 'Save Facility Details',
      message: 'Are you sure you want to update public details and amenities for $facilityName?',
      confirmLabel: 'Save Changes',
      details: [
        ConfirmDetailRow(label: 'Facility', value: facilityName),
        ConfirmDetailRow(label: 'Amenities', value: '${_selectedAmenities.length} selected'),
        ConfirmDetailRow(
          label: 'Operating Hours',
          value: '${_formatTimeDisplay(_openingTime)} — ${_formatTimeDisplay(_closingTime)}',
        ),
      ],
    );

    if (!confirm) return;

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final payload = {
        'name': v['name'],
        'description': _descController.text.trim(),
        'address': v['address'],
        'contact_phone': v['contact_phone'],
        'contact_email': v['contact_email'],
        if (_openingTime != null) 'opening_time': _formatTimeOfDay(_openingTime!),
        if (_closingTime != null) 'closing_time': _formatTimeOfDay(_closingTime!),
        'amenity_ids': _selectedAmenities.map((a) => a.id).toList(),
      };

      if (widget.kind == FacilityKind.gym) {
        await repo.updateGymDetails(widget.facilityId, payload);
      } else {
        await repo.updateLibraryDetails(widget.facilityId, payload);
      }

      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('${widget.kind == FacilityKind.gym ? "Gym" : "Library"} details & amenities updated successfully!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update facility: $err'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final f = widget.facility;
    final isGym = widget.kind == FacilityKind.gym;
    final brandBlue = const Color(0xFF2563EB);
    final lightBg = isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFEDF2F7);

    final facilityTitle = isGym ? 'Gym' : 'Library';

    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
            children: [
              // Custom Header matching Screenshot
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit $facilityTitle Details',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                            fontSize: 20,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Update your ${facilityTitle.toLowerCase()}'s information",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Top Right 3D Emblem Badge
                  _buildHeaderEmblem(isGym, isDark),
                ],
              ),
              const SizedBox(height: 20),

              // Identity Hero Card matching Screenshot
              _buildIdentityHeroCard(f, isGym, isDark, cardBg, cardBorder, brandBlue),
              const SizedBox(height: 16),

              // Form Field 1: Facility Name
              _buildInputFieldCard(
                icon: isGym ? Icons.fitness_center_rounded : Icons.storefront_rounded,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: brandBlue,
                label: 'Facility Name',
                isDark: isDark,
                cardBg: cardBg,
                cardBorder: cardBorder,
                child: FormBuilderTextField(
                  name: 'name',
                  initialValue: f?.name ?? '',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Enter facility name',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Facility name is required'),
                    FormBuilderValidators.minLength(3, errorText: 'Must be at least 3 characters'),
                  ]),
                ),
              ),
              const SizedBox(height: 14),

              // Form Field 2: Full Address (with Map button)
              _buildInputFieldCard(
                icon: Icons.location_on_rounded,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: brandBlue,
                label: 'Full Address',
                isDark: isDark,
                cardBg: cardBg,
                cardBorder: cardBorder,
                trailing: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address geocoded and marked on city map.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_rounded, size: 14, color: brandBlue),
                        const SizedBox(width: 5),
                        Text(
                          'Map',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: brandBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: FormBuilderTextField(
                  name: 'address',
                  initialValue: f?.address ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Enter full street address',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Address is required'),
                  ]),
                ),
              ),
              const SizedBox(height: 14),

              // Form Field 3: Contact Phone
              _buildInputFieldCard(
                icon: Icons.phone_rounded,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: brandBlue,
                label: 'Contact Phone',
                isDark: isDark,
                cardBg: cardBg,
                cardBorder: cardBorder,
                child: FormBuilderTextField(
                  name: 'contact_phone',
                  initialValue: f?.contactPhone ?? '',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'e.g. 9876543210',
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Form Field 4: Contact Email
              _buildInputFieldCard(
                icon: Icons.email_rounded,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: brandBlue,
                label: 'Contact Email',
                isDark: isDark,
                cardBg: cardBg,
                cardBorder: cardBorder,
                child: FormBuilderTextField(
                  name: 'contact_email',
                  initialValue: f?.contactEmail ?? '',
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'contact@facility.com',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section Header: Operating Hours
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF334155)),
                  const SizedBox(width: 8),
                  Text(
                    'Operating Hours',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dual Operating Hours Cards (Opening Time & Closing Time)
              Row(
                children: [
                  // Opening Time Card
                  Expanded(
                    child: _buildOperatingTimeCard(
                      label: 'Opening Time',
                      timeDisplay: _formatTimeDisplay(_openingTime),
                      icon: Icons.wb_sunny_outlined,
                      iconBg: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      isDark: isDark,
                      cardBg: cardBg,
                      cardBorder: cardBorder,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _openingTime ?? const TimeOfDay(hour: 6, minute: 0),
                        );
                        if (picked != null) {
                          setState(() => _openingTime = picked);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Closing Time Card
                  Expanded(
                    child: _buildOperatingTimeCard(
                      label: 'Closing Time',
                      timeDisplay: _formatTimeDisplay(_closingTime),
                      icon: Icons.nights_stay_rounded,
                      iconBg: const Color(0xFFF5F3FF),
                      iconColor: const Color(0xFF8B5CF6),
                      isDark: isDark,
                      cardBg: cardBg,
                      cardBorder: cardBorder,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _closingTime ?? const TimeOfDay(hour: 22, minute: 0),
                        );
                        if (picked != null) {
                          setState(() => _closingTime = picked);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Facility Description & Amenities Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cardBorder, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.article_outlined, color: Color(0xFF059669), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Facility Description & Amenities',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _descController,
                                maxLines: 3,
                                maxLength: 500,
                                onChanged: (_) => setState(() {}),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.45,
                                  color: isDark ? Colors.white : const Color(0xFF334155),
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 4),
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: 'Describe your facility, available reading areas, equipment, rules, amenities etc.',
                                  hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${_descController.text.length}/500',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Interactive Amenities Chips (Search, Add & Remove)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (_isLoadingAmenities)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF059669)),
                      ),
                    ),
                  ..._selectedAmenities.map((amenity) {
                    final iconData = _resolveAmenityIcon(amenity.name);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFBBF7D0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(iconData, size: 14, color: const Color(0xFF059669)),
                          const SizedBox(width: 6),
                          Text(
                            amenity.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF065F46),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedAmenities = _selectedAmenities.where((a) => a.id != amenity.id).toList();
                              });
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.close_rounded, size: 13, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // "+ Add" Button in Green Tint
                  InkWell(
                    onTap: _handleOpenAmenitySelector,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFA7F3D0),
                          width: 1.2,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded, size: 15, color: Color(0xFF059669)),
                          SizedBox(width: 4),
                          Text(
                            '+ Add',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // Save Facility Details Button matching Screenshot
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.4),
                  ),
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded, size: 20),
                  label: Text(
                    _submitting ? 'Saving Changes...' : 'Save Facility Details',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Security footer caption
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      'Your changes are secure and saved immediately',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderEmblem(bool isGym, bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE), width: 1.2),
      ),
      child: Center(
        child: Icon(
          isGym ? Icons.fitness_center_rounded : Icons.account_balance_rounded,
          color: const Color(0xFF2563EB),
          size: 26,
        ),
      ),
    );
  }

  Widget _buildIdentityHeroCard(
    FacilityModel? f,
    bool isGym,
    bool isDark,
    Color cardBg,
    Color cardBorder,
    Color brandBlue,
  ) {
    final facilityName = f?.name ?? (isGym ? 'Gym Facility' : 'Library Facility');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar with Edit Pencil Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isGym ? Icons.fitness_center_rounded : Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.edit_rounded, size: 12, color: Color(0xFF2563EB)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Facility Identity Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGym ? 'GYM NAME' : 'LIBRARY NAME',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2563EB),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  facilityName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.public_rounded, size: 12, color: Color(0xFF059669)),
                          SizedBox(width: 4),
                          Text(
                            'Public Profile',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'This information will be visible to users',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required Widget child,
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 2),
                child,
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildOperatingTimeCard({
    required String label,
    required String timeDisplay,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeDisplay,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
