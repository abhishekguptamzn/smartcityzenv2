import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/onboard_model.dart';
import '../../../shared/widgets/glass_container.dart';

class OnboardHomeScreen extends ConsumerWidget {
  const OnboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboard'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const SizedBox(height: 8),
              Text(
                'Choose what you want to onboard to CityZen',
                style: TextStyle(
                  fontSize: 15,
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // 1. User Card
              _OnboardOptionCard(
                icon: Icons.person_rounded,
                title: 'User',
                subtitle: 'Create a personal account',
                accentColor: const Color(0xFF6366F1),
                onTap: () {
                  ref
                      .read(onboardDraftControllerProvider.notifier)
                      .setType(OnboardType.user);
                  context.push('/onboard/select/user');
                },
              ),
              const SizedBox(height: 18),

              // 2. Library Card
              _OnboardOptionCard(
                icon: Icons.menu_book_rounded,
                title: 'Library',
                subtitle: 'Onboard your library',
                accentColor: const Color(0xFF10B981),
                onTap: () {
                  ref
                      .read(onboardDraftControllerProvider.notifier)
                      .setType(OnboardType.library);
                  context.push('/onboard/select/library');
                },
              ),
              const SizedBox(height: 18),

              // 3. Gym Card
              _OnboardOptionCard(
                icon: Icons.fitness_center_rounded,
                title: 'Gym',
                subtitle: 'Onboard your gym',
                accentColor: const Color(0xFFF97316),
                onTap: () {
                  ref
                      .read(onboardDraftControllerProvider.notifier)
                      .setType(OnboardType.gym);
                  context.push('/onboard/select/gym');
                },
              ),

              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
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
}

class _OnboardOptionCard extends StatelessWidget {
  const _OnboardOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accentColor, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: accentColor,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
