import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/onboard_model.dart';
import '../../../data/repositories/onboard_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/loading_button.dart';

class OnboardReviewScreen extends ConsumerStatefulWidget {
  const OnboardReviewScreen({super.key});

  @override
  ConsumerState<OnboardReviewScreen> createState() =>
      _OnboardReviewScreenState();
}

class _OnboardReviewScreenState extends ConsumerState<OnboardReviewScreen> {
  bool _isSubmitting = false;

  Color _getAccentColor(OnboardType type) {
    switch (type) {
      case OnboardType.user:
        return const Color(0xFF6366F1);
      case OnboardType.library:
        return const Color(0xFF10B981);
      case OnboardType.gym:
        return const Color(0xFFF97316);
    }
  }

  Future<void> _submit() async {
    final draft = ref.read(onboardDraftControllerProvider);
    final repo = ref.read(onboardRepositoryProvider);

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (draft.type == OnboardType.user) {
        await repo.submitUser(
          name: draft.name,
          email: draft.email,
          phone: draft.phone,
          cityId: draft.cityId,
        );
      } else if (draft.type == OnboardType.library) {
        await repo.submitLibrary(
          name: draft.name,
          email: draft.email,
          phone: draft.phone,
          address: draft.address,
          cityId: draft.cityId,
          ownerId: draft.ownerId,
        );
      } else if (draft.type == OnboardType.gym) {
        await repo.submitGym(
          name: draft.name,
          email: draft.email,
          phone: draft.phone,
          address: draft.address,
          cityId: draft.cityId,
          ownerId: draft.ownerId,
        );
      }

      if (mounted) {
        context.go('/onboard/sent');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit onboarding: $e'),
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
    final draft = ref.watch(onboardDraftControllerProvider);
    final accent = _getAccentColor(draft.type);
    final isFacility = draft.type != OnboardType.user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/onboard');
            }
          },
        ),
        title: Text('${draft.type.displayName} Onboard — Review'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  children: [
                    // Progress Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isFacility) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Review Your Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Please review your information before submitting',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Review Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: accent.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _ReviewRow(
                              icon: Icons.badge_outlined,
                              label: isFacility
                                  ? '${draft.type.displayName} Name'
                                  : 'Full Name',
                              value: draft.name,
                              accent: accent,
                            ),
                            _buildDivider(),
                            _ReviewRow(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email Address',
                              value: draft.email,
                              accent: accent,
                            ),
                            _buildDivider(),
                            _ReviewRow(
                              icon: Icons.phone_outlined,
                              label: isFacility
                                  ? 'Contact Number'
                                  : 'Mobile Number',
                              value: draft.phone,
                              accent: accent,
                            ),
                            if (isFacility) ...[
                              _buildDivider(),
                              _ReviewRow(
                                icon: Icons.location_on_outlined,
                                label: 'Address',
                                value: draft.address,
                                accent: accent,
                              ),
                            ],
                            _buildDivider(),
                            _ReviewRow(
                              icon: Icons.location_city_outlined,
                              label: 'City',
                              value: draft.cityName.isNotEmpty
                                  ? draft.cityName
                                  : draft.cityId,
                              accent: accent,
                            ),
                            if (isFacility && draft.ownerName.isNotEmpty) ...[
                              _buildDivider(),
                              _ReviewRow(
                                icon: Icons.person_outline_rounded,
                                label: 'Owner',
                                value:
                                    '${draft.ownerName}\n${draft.ownerEmail}',
                                accent: accent,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Actions: Edit Details & Submit
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accent,
                          side: BorderSide(color: accent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text(
                          'Edit Details',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: LoadingButton.filled(
                        backgroundColor: accent,
                        isLoading: _isSubmitting,
                        loadingText: 'Submitting Application...',
                        onPressed: _isSubmitting ? null : _submit,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: accent),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : '-',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
