import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/api/app_exception.dart';
import '../../../data/models/facility_batch_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

class CreateEditBatchScreen extends ConsumerStatefulWidget {
  const CreateEditBatchScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
    this.batch,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;
  final FacilityBatchModel? batch;

  @override
  ConsumerState<CreateEditBatchScreen> createState() => _CreateEditBatchScreenState();
}

class _CreateEditBatchScreenState extends ConsumerState<CreateEditBatchScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _roomCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _capacityCtrl;
  late TextEditingController _feeCtrl;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<int> _selectedDays = [1, 2, 3, 4, 5]; // Mon to Fri default
  int _autoCheckoutBufferMinutes = 15;
  String _status = 'active';
  bool _allowWaitlist = false;

  bool _submitting = false;

  final Map<int, String> _dayLabels = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  void initState() {
    super.initState();
    final b = widget.batch;
    _nameCtrl = TextEditingController(text: b?.name ?? '');
    _categoryCtrl = TextEditingController(text: b?.category ?? '');
    _roomCtrl = TextEditingController(text: b?.room ?? '');
    _descriptionCtrl = TextEditingController(text: b?.description ?? '');
    _capacityCtrl = TextEditingController(text: b?.capacity.toString() ?? '30');
    _feeCtrl = TextEditingController(text: b?.fee != null ? b!.fee!.toStringAsFixed(0) : '');

    if (b?.startTime != null) {
      _startTime = _parseTimeOfDay(b!.startTime!);
    } else {
      _startTime = const TimeOfDay(hour: 6, minute: 0);
    }

    if (b?.endTime != null) {
      _endTime = _parseTimeOfDay(b!.endTime!);
    } else {
      _endTime = const TimeOfDay(hour: 7, minute: 30);
    }

    if (b?.daysOfWeek != null && b!.daysOfWeek.isNotEmpty) {
      _selectedDays = List<int>.from(b.daysOfWeek);
    }

    _autoCheckoutBufferMinutes = b?.autoCheckoutBufferMinutes ?? 15;
    _status = b?.status ?? 'active';
    _allowWaitlist = b?.allowWaitlist ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _roomCtrl.dispose();
    _descriptionCtrl.dispose();
    _capacityCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTimeOfDay(String str) {
    try {
      final parts = str.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (_) {}
    return null;
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  String _timeOfDayToTimeString(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isEdit = widget.batch != null;
    final primaryColor = widget.kind == FacilityKind.gym
        ? const Color(0xFF0D9488)
        : (widget.kind == FacilityKind.activity
            ? const Color(0xFF1565D8)
            : const Color(0xFF0284C7));

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Batch' : 'Create Batch'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Update' : 'Create', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: AmbientBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // BASIC DETAILS SECTION
              _buildSectionHeader('BATCH DETAILS', scheme),
              const SizedBox(height: 8),
              GlassContainer(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Batch Name *',
                        hintText: 'e.g. Morning Aerobics / Karate Beginners',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter batch name' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _categoryCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              hintText: 'e.g. Fitness / Swimming',
                              prefixIcon: Icon(Icons.category_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _roomCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Room / Studio / Court',
                              hintText: 'e.g. Studio 1 / Court B',
                              prefixIcon: Icon(Icons.meeting_room_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Brief summary of what this batch covers...',
                        prefixIcon: Icon(Icons.description_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // TIMINGS & DAYS SECTION
              _buildSectionHeader('TIMINGS & RECURRING DAYS', scheme),
              const SizedBox(height: 8),
              GlassContainer(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerTile(
                            context,
                            'Start Time',
                            _startTime,
                            (t) => setState(() => _startTime = t),
                            primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTimePickerTile(
                            context,
                            'End Time',
                            _endTime,
                            (t) => setState(() => _endTime = t),
                            primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Recurring Days of Week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _dayLabels.entries.map((entry) {
                        final isSelected = _selectedDays.contains(entry.key);
                        return FilterChip(
                          label: Text(entry.value),
                          selected: isSelected,
                          selectedColor: primaryColor.withValues(alpha: 0.2),
                          checkmarkColor: primaryColor,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedDays.add(entry.key);
                                _selectedDays.sort();
                              } else {
                                _selectedDays.remove(entry.key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // CAPACITY & FEE SECTION
              _buildSectionHeader('CAPACITY & BATCH FEES', scheme),
              const SizedBox(height: 8),
              GlassContainer(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _capacityCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Max Capacity *',
                              hintText: 'e.g. 25',
                              prefixIcon: Icon(Icons.people_rounded),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Enter capacity';
                              final n = int.tryParse(val.trim());
                              if (n == null || n <= 0) return 'Must be > 0';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _feeCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Batch Fee (₹)',
                              hintText: 'e.g. 1500',
                              prefixIcon: Icon(Icons.currency_rupee_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Allow Waitlist when Full', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Permit citizens to queue when capacity is reached', style: TextStyle(fontSize: 12)),
                      value: _allowWaitlist,
                      activeTrackColor: primaryColor,
                      onChanged: (val) => setState(() => _allowWaitlist = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // AUTO-CHECKOUT & BUFFER SECTION
              _buildSectionHeader('AUTO-CHECKOUT & ATTENDANCE RULES', scheme),
              const SizedBox(height: 8),
              GlassContainer(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Auto-Checkout Buffer Time',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Background cron will auto check-out members who do not scan out $_autoCheckoutBufferMinutes mins after batch end time.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [0, 10, 15, 30, 45, 60].map((mins) {
                        final isSelected = mins == _autoCheckoutBufferMinutes;
                        return ChoiceChip(
                          label: Text('$mins mins'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _autoCheckoutBufferMinutes = mins);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Batch Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'active', label: Text('Active')),
                            ButtonSegment(value: 'inactive', label: Text('Inactive')),
                          ],
                          selected: {_status},
                          onSelectionChanged: (val) => setState(() => _status = val.first),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerTile(
    BuildContext context,
    String label,
    TimeOfDay? time,
    ValueChanged<TimeOfDay> onSelected,
    Color primaryColor,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? const TimeOfDay(hour: 6, minute: 0),
        );
        if (picked != null) onSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 16, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  _formatTime(time),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: scheme.primary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify start and end timings')),
      );
      return;
    }

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    final payload = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      if (_categoryCtrl.text.trim().isNotEmpty) 'category': _categoryCtrl.text.trim(),
      if (_roomCtrl.text.trim().isNotEmpty) 'room': _roomCtrl.text.trim(),
      if (_descriptionCtrl.text.trim().isNotEmpty) 'description': _descriptionCtrl.text.trim(),
      'capacity': int.tryParse(_capacityCtrl.text.trim()) ?? 30,
      if (_feeCtrl.text.trim().isNotEmpty) 'fee': double.tryParse(_feeCtrl.text.trim()),
      'start_time': _timeOfDayToTimeString(_startTime!),
      'end_time': _timeOfDayToTimeString(_endTime!),
      'days_of_week': _selectedDays,
      'auto_checkout_buffer_minutes': _autoCheckoutBufferMinutes,
      'status': _status,
      'allow_waitlist': _allowWaitlist,
    };

    try {
      if (widget.batch != null) {
        await repo.updateBatch(widget.kind, widget.facilityId, widget.batch!.id, payload);
      } else {
        await repo.createBatch(widget.kind, widget.facilityId, payload);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.batch != null ? 'Batch updated successfully' : 'Batch created successfully'),
            backgroundColor: const Color(0xFF0D9488),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppException.extractMessage(e, fallback: 'Operation failed. Please try again.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(errorMsg, style: const TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
