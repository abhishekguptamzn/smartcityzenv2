import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/onboard_model.dart';
import '../../../shared/widgets/glass_container.dart';

class OnboardSelectTypeScreen extends ConsumerWidget {
  const OnboardSelectTypeScreen({
    super.key,
    required this.type,
  });

  final OnboardType type;

  Color _getAccentColor() {
    switch (type) {
      case OnboardType.user:
        return const Color(0xFF6366F1);
      case OnboardType.library:
        return const Color(0xFF10B981);
      case OnboardType.gym:
        return const Color(0xFFF97316);
    }
  }

  IconData _getIcon() {
    switch (type) {
      case OnboardType.user:
        return Icons.person_rounded;
      case OnboardType.library:
        return Icons.menu_book_rounded;
      case OnboardType.gym:
        return Icons.fitness_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = _getAccentColor();
    final icon = _getIcon();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Type'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  children: [
                    const SizedBox(height: 16),
                    // Large centered icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accent.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(icon, size: 52, color: accent),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title & Subtitle
                    Center(
                      child: Column(
                        children: [
                          Text(
                            type.displayName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Feature highlights list
                    for (final highlight in type.highlights)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.14),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: accent,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                highlight,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom Continue Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(onboardDraftControllerProvider.notifier)
                          .setType(type);
                      if (type == OnboardType.user) {
                        context.push('/onboard/user/details');
                      } else {
                        context.push('/onboard/facility/details/${type.name}');
                      }
                    },
                    child: const Text(
                      'Continue',
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
        ),
      ),
    );
  }
}
