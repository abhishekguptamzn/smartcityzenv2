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

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => _submitting = true);
    final v = form.value;
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      if (widget.kind == FacilityKind.gym) {
        await repo.updateGymDetails(widget.facilityId, {
          'name': v['name'],
          'description': v['description'],
          'address': v['address'],
          'contact_phone': v['contact_phone'],
          'contact_email': v['contact_email'],
          if (v['opening_time'] != null && (v['opening_time'] as String).isNotEmpty)
            'opening_time': v['opening_time'],
          if (v['closing_time'] != null && (v['closing_time'] as String).isNotEmpty)
            'closing_time': v['closing_time'],
        });
      } else {
        await repo.updateLibraryDetails(widget.facilityId, {
          'name': v['name'],
          'description': v['description'],
          'address': v['address'],
          'contact_phone': v['contact_phone'],
          'contact_email': v['contact_email'],
          if (v['opening_time'] != null && (v['opening_time'] as String).isNotEmpty)
            'opening_time': v['opening_time'],
          if (v['closing_time'] != null && (v['closing_time'] as String).isNotEmpty)
            'closing_time': v['closing_time'],
        });
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
      ),
      body: AmbientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: f?.name ?? '',
                    decoration: InputDecoration(
                      labelText: 'Facility Name *',
                      prefixIcon: Icon(
                        isGym ? Icons.fitness_center : Icons.local_library,
                        color: scheme.primary,
                      ),
                    ),
                    validator: FormBuilderValidators.required(
                      errorText: 'Facility name is required',
                    ),
                  ),
                  const SizedBox(height: 16),

                  FormBuilderTextField(
                    name: 'address',
                    initialValue: f?.address ?? '',
                    decoration: InputDecoration(
                      labelText: 'Full Address *',
                      prefixIcon: Icon(
                        Icons.place_outlined,
                        color: scheme.primary,
                      ),
                    ),
                    validator: FormBuilderValidators.required(
                      errorText: 'Address is required',
                    ),
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
                            hintText: '10-digit phone number',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: scheme.primary,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.match(
                              RegExp(r'^\d{10}$'),
                              errorText: 'Contact phone must be exactly 10 digits',
                            ),
                          ]),
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

                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'opening_time',
                          initialValue: f?.openingTime ?? '06:00',
                          decoration: InputDecoration(
                            labelText: 'Opening Time (HH:MM)',
                            prefixIcon: Icon(
                              Icons.access_time_rounded,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'closing_time',
                          initialValue: f?.closingTime ?? '22:00',
                          decoration: InputDecoration(
                            labelText: 'Closing Time (HH:MM)',
                            prefixIcon: Icon(
                              Icons.access_time_filled_rounded,
                              color: scheme.primary,
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
