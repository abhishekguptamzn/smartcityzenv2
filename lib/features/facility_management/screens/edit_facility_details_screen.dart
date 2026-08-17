import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
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
  bool _submitting = false;

  late TimeOfDay? _openingTime;
  late TimeOfDay? _closingTime;

  @override
  void initState() {
    super.initState();
    _openingTime = _parseTimeString(widget.facility?.openingTime) ?? const TimeOfDay(hour: 6, minute: 0);
    _closingTime = _parseTimeString(widget.facility?.closingTime) ?? const TimeOfDay(hour: 22, minute: 0);
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

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => _submitting = true);
    final v = form.value;
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final payload = {
        'name': v['name'],
        'description': v['description'],
        'address': v['address'],
        'contact_phone': v['contact_phone'],
        'contact_email': v['contact_email'],
        if (_openingTime != null) 'opening_time': _formatTimeOfDay(_openingTime!),
        if (_closingTime != null) 'closing_time': _formatTimeOfDay(_closingTime!),
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
          content: Text('${widget.kind == FacilityKind.gym ? "Gym" : "Library"} details updated successfully!'),
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
    final scheme = theme.colorScheme;
    final f = widget.facility;
    final isGym = widget.kind == FacilityKind.gym;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${isGym ? "Gym" : "Library"} Details'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GlassContainer(
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isGym
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFF0284C7))
                              .withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isGym
                              ? Icons.fitness_center_rounded
                              : Icons.local_library_rounded,
                          color: isGym
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f?.name ?? 'Manage Facility',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Update public profile, operating hours & contact info',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  FormBuilderTextField(
                    name: 'name',
                    initialValue: f?.name ?? '',
                    decoration: InputDecoration(
                      labelText: 'Facility Name',
                      prefixIcon: Icon(
                        Icons.store_mall_directory_outlined,
                        color: scheme.primary,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: 'Facility name is required'),
                      FormBuilderValidators.minLength(3, errorText: 'Must be at least 3 characters'),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  FormBuilderTextField(
                    name: 'address',
                    initialValue: f?.address ?? '',
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Full Address',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: scheme.primary,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: 'Address is required'),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'contact_phone',
                          initialValue: f?.contactPhone ?? '',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Contact Phone',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'contact_email',
                          initialValue: f?.contactEmail ?? '',
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Contact Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Operating Hours',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _openingTime ?? const TimeOfDay(hour: 6, minute: 0),
                            );
                            if (picked != null) {
                              setState(() => _openingTime = picked);
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_rounded, color: scheme.primary, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Opening Time',
                                        style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatTimeDisplay(_openingTime),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _closingTime ?? const TimeOfDay(hour: 22, minute: 0),
                            );
                            if (picked != null) {
                              setState(() => _closingTime = picked);
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_filled_rounded, color: scheme.primary, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Closing Time',
                                        style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatTimeDisplay(_closingTime),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  FormBuilderTextField(
                    name: 'description',
                    initialValue: f?.description ?? '',
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Facility Description & Amenities',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Icon(
                          Icons.description_outlined,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '💾 Save Facility Details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
