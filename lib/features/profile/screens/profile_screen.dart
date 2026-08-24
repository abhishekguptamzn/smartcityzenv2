import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../widgets/profile_payment_support_skeletons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(authControllerProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settings');
            }
          },
        ),
        title: Text(l10n.myProfile),
      ),
      body: AmbientBackground(
        child: userAsync.when(
          loading: () => const ProfileSkeleton(),
          error: (_, _) => Center(child: Text(l10n.errorGeneric)),
          data: (user) {
            if (user == null) return const SizedBox.shrink();
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GlassContainer(
                  level: GlassLevel.largeCard,
                  borderRadius: BorderRadius.circular(24),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/profile/edit'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            UserAvatar(
                              user: user,
                              radius: 40,
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0D9488),
                                      Color(0xFF0284C7),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Chip(
                            avatar: Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: scheme.primary,
                            ),
                            label: Text(user.role),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            avatar: Icon(
                              user.isActive
                                  ? Icons.check_circle_rounded
                                  : Icons.error_rounded,
                              size: 16,
                              color: user.isActive
                                  ? scheme.secondary
                                  : scheme.error,
                            ),
                            label: Text(user.status),
                            backgroundColor: user.isActive
                                ? scheme.secondary.withValues(alpha: 0.12)
                                : scheme.error.withValues(alpha: 0.12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      if (user.isClientUser) ...[
                        _ProfileMenuTile(
                          icon: Icons.business_center_rounded,
                          accent: const Color(0xFF0D9488),
                          title: 'Manage My Facilities',
                          onTap: () => context.push('/client/facilities'),
                        ),
                        const Divider(height: 1),
                      ],
                      if (user.isOnboardingUser) ...[
                        _ProfileMenuTile(
                          icon: Icons.rocket_launch_rounded,
                          accent: const Color(0xFF6366F1),
                          title: 'Onboarding Portal',
                          onTap: () => context.push('/onboard'),
                        ),
                        const Divider(height: 1),
                      ],
                      _ProfileMenuTile(
                        icon: Icons.edit_rounded,
                        accent: scheme.primary,
                        title: l10n.editProfile,
                        onTap: () => context.push('/profile/edit'),
                      ),
                      const Divider(height: 1),
                      _ProfileMenuTile(
                        icon: Icons.badge_rounded,
                        accent: scheme.secondary,
                        title: l10n.cityzenIdentity,
                        onTap: () => context.push('/id-card'),
                      ),
                      const Divider(height: 1),
                      _ProfileMenuTile(
                        icon: Icons.payments_rounded,
                        accent: scheme.tertiary,
                        title: l10n.myPayments,
                        onTap: () => context.push('/payments'),
                      ),
                      const Divider(height: 1),
                      _ProfileMenuTile(
                        icon: Icons.security_rounded,
                        accent: scheme.primary,
                        title: l10n.security,
                        onTap: () => context.push('/security'),
                      ),
                      const Divider(height: 1),
                      _ProfileMenuTile(
                        icon: Icons.settings_rounded,
                        accent: scheme.onSurfaceVariant,
                        title: l10n.settings,
                        onTap: () => context.push('/settings'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '';
                    return Center(
                      child: Text(
                        version.isEmpty ? '' : 'v$version',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.accent,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: accent),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
