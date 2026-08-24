import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/onboard_model.dart';
import '../../../data/repositories/onboard_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/loading_button.dart';
import '../widgets/onboard_skeletons.dart';

class OnboardCompleteScreen extends ConsumerStatefulWidget {
  const OnboardCompleteScreen({
    super.key,
    required this.token,
  });

  final String token;

  @override
  ConsumerState<OnboardCompleteScreen> createState() =>
      _OnboardCompleteScreenState();
}

class _OnboardCompleteScreenState extends ConsumerState<OnboardCompleteScreen> {
  final _formKey = GlobalKey<FormState>();

  // User extended fields
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();
  DateTime? _dob;
  String _gender = 'male';

  // Facility extended fields
  final _descriptionController = TextEditingController();
  TimeOfDay _openingTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 20, minute: 0);
  final Set<String> _selectedAmenityIds = {};

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(1995, 5, 12),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  Future<void> _pickTime({required bool isOpening}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isOpening ? _openingTime : _closingTime,
    );
    if (picked != null) {
      setState(() {
        if (isOpening) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _submit(TokenVerificationResult verification) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final repo = ref.read(onboardRepositoryProvider);
    final isUser = verification.type == 'user';

    try {
      final payload = <String, dynamic>{
        'token': widget.token,
      };

      if (isUser) {
        payload['password'] = _passwordController.text;
        payload['password_confirmation'] = _confirmPasswordController.text;
        if (_dob != null) {
          payload['dob'] =
              '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}';
        }
        payload['gender'] = _gender;
        if (_bioController.text.isNotEmpty) {
          payload['bio'] = _bioController.text.trim();
        }
      } else {
        payload['opening_time'] = _formatTime(_openingTime);
        payload['closing_time'] = _formatTime(_closingTime);
        if (_descriptionController.text.isNotEmpty) {
          payload['description'] = _descriptionController.text.trim();
        }
        payload['amenity_ids'] = _selectedAmenityIds.toList();
      }

      final result = await repo.complete(payload);

      // If user onboarding, refresh auth state
      if (isUser && result['token'] != null) {
        try {
          await ref.read(authControllerProvider.notifier).refreshMe();
        } catch (_) {}
      }

      if (mounted) {
        context.go('/onboard/success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete onboarding: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationAsync =
        ref.watch(verifyOnboardTokenProvider(token: widget.token));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
        title: const Text('Complete Your Profile'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: verificationAsync.when(
            loading: () => const OnboardVerificationState(),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Invalid or Expired Link',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This onboarding link is either invalid, already completed, or expired (valid for 24 hours only).',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go('/onboard'),
                      child: const Text('Start New Onboarding'),
                    ),
                  ],
                ),
              ),
            ),
            data: (verification) {
              final payload = verification.payload;
              final isUser = verification.type == 'user';
              final accent = isUser
                  ? const Color(0xFF6366F1)
                  : (verification.type == 'library'
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF97316));

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        children: [
                          // Header
                          const Text(
                            'Complete Your Profile',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Let\'s finish setting up your account',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Section: Pre-populated Info
                          Card(
                            color: accent.withValues(alpha: 0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: accent.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 18,
                                        color: accent,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Verified Basic Information',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    payload['name']?.toString() ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${verification.email} • ${payload['phone'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // USER SPECIFIC EXTENDED FIELDS
                          if (isUser) ...[
                            // Date of Birth & Gender Row
                            Row(
                              children: [
                                // DOB Picker
                                Expanded(
                                  child: InkWell(
                                    onTap: _pickDob,
                                    borderRadius: BorderRadius.circular(14),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Date of Birth',
                                        prefixIcon: const Icon(
                                            Icons.cake_outlined,
                                            size: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        _dob != null
                                            ? '${_dob!.day.toString().padLeft(2, '0')} / ${_dob!.month.toString().padLeft(2, '0')} / ${_dob!.year}'
                                            : '12 / 09 / 1995',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Gender Dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _gender,
                                    decoration: InputDecoration(
                                      labelText: 'Gender',
                                      prefixIcon: const Icon(
                                          Icons.person_outline_rounded,
                                          size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'male', child: Text('Male')),
                                      DropdownMenuItem(
                                          value: 'female',
                                          child: Text('Female')),
                                      DropdownMenuItem(
                                          value: 'other', child: Text('Other')),
                                    ],
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          _gender = v;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Bio
                            TextFormField(
                              controller: _bioController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Bio (Optional)',
                                hintText: 'Tell us about yourself',
                                prefixIcon: const Icon(Icons.notes_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Minimum 8 characters',
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),

                            // Confirm Password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Re-enter password',
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              validator: (v) {
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],

                          // FACILITY SPECIFIC EXTENDED FIELDS (LIBRARY / GYM)
                          if (!isUser) ...[
                            // Opening & Closing Hours Row
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _pickTime(isOpening: true),
                                    borderRadius: BorderRadius.circular(14),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Opening Time',
                                        prefixIcon: const Icon(
                                            Icons.access_time_rounded,
                                            size: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        _formatTime(_openingTime),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _pickTime(isOpening: false),
                                    borderRadius: BorderRadius.circular(14),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Closing Time',
                                        prefixIcon: const Icon(
                                            Icons.access_time_filled_rounded,
                                            size: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        _formatTime(_closingTime),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Description
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText:
                                    'Tell us about facilities, environment & rules',
                                prefixIcon: const Icon(Icons.description_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Amenities Checklist
                            if (verification.amenities.isNotEmpty) ...[
                              Text(
                                'Available Amenities',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: accent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: verification.amenities.map((amenity) {
                                  final id = amenity['id'] as String;
                                  final name = amenity['name'] as String;
                                  final isSelected =
                                      _selectedAmenityIds.contains(id);

                                  return FilterChip(
                                    selected: isSelected,
                                    label: Text(name),
                                    selectedColor:
                                        accent.withValues(alpha: 0.18),
                                    checkmarkColor: accent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: isSelected
                                            ? accent
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedAmenityIds.add(id);
                                        } else {
                                          _selectedAmenityIds.remove(id);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),

                    // Bottom Submit Button
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: LoadingButton.filled(
                          backgroundColor: accent,
                          isLoading: _isSubmitting,
                          loadingText: 'Activating Profile...',
                          onPressed: _isSubmitting
                              ? null
                              : () => _submit(verification),
                          child: const Text(
                            'Complete & Activate Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
