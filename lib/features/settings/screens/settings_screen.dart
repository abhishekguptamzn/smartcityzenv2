import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/locale_controller.dart';
import '../../../core/providers/theme_mode_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';
import '../../../shared/widgets/user_avatar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeControllerProvider);

    final languages = [
      {'code': 'en', 'name': 'English', 'native': 'English'},
      {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
      {'code': 'es', 'name': 'Spanish', 'native': 'Español'},
      {'code': 'fr', 'name': 'French', 'native': 'Français'},
      {'code': 'ar', 'name': 'Arabic', 'native': 'العربية'},
    ];

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                for (final lang in languages)
                  ListTile(
                    title: Text(lang['name']!),
                    subtitle: Text(lang['native']!),
                    trailing: currentLocale.languageCode == lang['code']
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF0D9488),
                          )
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      ref
                          .read(localeControllerProvider.notifier)
                          .setLocale(Locale(lang['code']!));
                      Navigator.pop(modalContext);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFaqSheet(BuildContext context) {
    final faqs = [
      {
        'q': 'How do I access city gyms and libraries with my citizen pass?',
        'a':
            'Show your digital Citizen ID card QR at the entrance, or tap "Check-in" from the bottom navigation bar to scan the gym or library QR code.'
      },
      {
        'q': 'How do I update my profile picture or phone number?',
        'a':
            'Go to Settings > Edit Profile. Tap your profile picture to take a photo or pick from gallery, update your details, and tap "Save Changes".'
      },
      {
        'q': 'Are emergency helplines free to call?',
        'a':
            'Yes. 112 (Police), 101 (Fire), 108 (Ambulance), and 1090 (Women Safety) are toll-free 24/7 municipal helplines accessible from the Services tab.'
      },
      {
        'q': 'How do I view payment invoices and receipts?',
        'a':
            'Go to Settings > Payments & Invoices to view all transaction history and download official municipal fee receipts.'
      },
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Frequently Asked Questions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                for (final faq in faqs)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faq['q']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            faq['a']!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacyPolicySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Citizen Privacy Policy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Smart Cityzen is committed to protecting citizen personal data and identity records under the Municipal Digital Governance Act.\n\n• Your identity, phone number, and location data are encrypted end-to-end.\n• QR Check-in records are used exclusively for facility safety and occupancy monitoring.\n• We never sell or share citizen data with third-party advertisers.',
                style: TextStyle(fontSize: 13.5, height: 1.45),
              ),
              const SizedBox(height: 20),
              Center(
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.logout),
          content: const Text(
            'Are you sure you want to log out from this device?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeControllerProvider);
    final user = ref.watch(authControllerProvider).value;
    final locale = ref.watch(localeControllerProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        automaticallyImplyLeading: false,
      ),
      body: AmbientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            // 1. User Profile Card
            if (user != null)
              _buildUserProfileCard(context, user, scheme, l10n)
            else
              const Shimmer(
                child: SkeletonCard(
                  height: 90,
                  child: Row(
                    children: [
                      SkeletonCircle(size: 56),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SkeletonText(width: 140, height: 16),
                            SizedBox(height: 6),
                            SkeletonText(width: 180, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 2. Account & Citizen Services
            _buildSectionHeader(context, 'Account & Citizen Services'),
            const SizedBox(height: 10),
            GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  _SettingsMenuTile(
                    icon: Icons.person_outline_rounded,
                    accent: const Color(0xFF0D9488),
                    title: l10n.editProfile,
                    subtitle: 'Name, email, phone & city',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  _buildDivider(scheme),
                  _SettingsMenuTile(
                    icon: Icons.receipt_long_rounded,
                    accent: const Color(0xFF7C3AED),
                    title: l10n.myPayments,
                    subtitle: 'Invoices, transaction history & receipts',
                    onTap: () => context.push('/payments'),
                  ),
                  _buildDivider(scheme),
                  _SettingsMenuTile(
                    icon: Icons.security_rounded,
                    accent: const Color(0xFF0F766E),
                    title: l10n.security,
                    subtitle: 'App lock, PIN, biometrics & login sessions',
                    onTap: () => context.push('/security'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. App Appearance & Theme
            _buildSectionHeader(context, l10n.appearance),
            const SizedBox(height: 10),
            GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  _ThemeModeOption(
                    icon: Icons.light_mode_rounded,
                    title: l10n.themeLight,
                    subtitle: l10n.themeLightSubtitle,
                    selected: themeMode == ThemeMode.light,
                    onTap: () => ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(ThemeMode.light),
                    scheme: scheme,
                  ),
                  _buildDivider(scheme),
                  _ThemeModeOption(
                    icon: Icons.dark_mode_rounded,
                    title: l10n.themeDark,
                    subtitle: l10n.themeDarkSubtitle,
                    selected: themeMode == ThemeMode.dark,
                    onTap: () => ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(ThemeMode.dark),
                    scheme: scheme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Preferences & System
            _buildSectionHeader(context, 'Preferences & System'),
            const SizedBox(height: 10),
            GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  _SettingsMenuTile(
                    icon: Icons.language_rounded,
                    accent: const Color(0xFF2563EB),
                    title: 'Language / भाषा',
                    subtitle:
                        'Current: ${_getLanguageName(locale.languageCode)}',
                    onTap: () => _showLanguageSelector(context, ref),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5. Help & Support
            _buildSectionHeader(context, 'Help & Support'),
            const SizedBox(height: 10),
            GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  _SettingsMenuTile(
                    icon: Icons.support_agent_rounded,
                    accent: const Color(0xFF0D9488),
                    title: 'Support & Helpdesk',
                    subtitle: 'Track tickets, submit inquiries & replies',
                    onTap: () => context.push('/support'),
                  ),
                  _buildDivider(scheme),
                  _SettingsMenuTile(
                    icon: Icons.help_outline_rounded,
                    accent: const Color(0xFF0284C7),
                    title: l10n.faqs,
                    subtitle: 'Quick answers & user guide',
                    onTap: () => _showFaqSheet(context),
                  ),
                  _buildDivider(scheme),
                  _SettingsMenuTile(
                    icon: Icons.privacy_tip_outlined,
                    accent: const Color(0xFF6366F1),
                    title: l10n.privacyPolicy,
                    subtitle: 'Citizen data protection rules',
                    onTap: () => _showPrivacyPolicySheet(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 6. Danger Zone / Logout
            GlassContainer(
              level: GlassLevel.card,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: Color(0xFFDC2626),
                  ),
                ),
                title: Text(
                  l10n.logout,
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Sign out of your session on this device'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFDC2626),
                ),
                onTap: () => _confirmLogout(context, ref),
              ),
            ),

            const SizedBox(height: 24),

            // 7. App Version Footer
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '1.0.0';
                return Center(
                  child: Text(
                    'Smart Cityzen v$version • Build 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(
    BuildContext context,
    UserModel user,
    ColorScheme scheme,
    AppLocalizations l10n,
  ) {
    return GlassContainer(
      level: GlassLevel.largeCard,
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/profile/edit'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                UserAvatar(
                  user: user,
                  radius: 34,
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? const Color(0xFF059669).withValues(alpha: 0.12)
                            : const Color(0xFFDC2626).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: user.isActive
                              ? const Color(0xFF059669)
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onPressed: () => context.push('/profile/edit'),
            tooltip: l10n.editProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.1,
            ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme scheme) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: scheme.outlineVariant.withValues(alpha: 0.25),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'hi':
        return 'हिन्दी (Hindi)';
      case 'es':
        return 'Español (Spanish)';
      case 'fr':
        return 'Français (French)';
      case 'ar':
        return 'العربية (Arabic)';
      default:
        return 'English';
    }
  }
}

class _SettingsMenuTile extends StatelessWidget {
  const _SettingsMenuTile({
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: accent),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  const _ThemeModeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.scheme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: 0.14)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF0D9488),
              size: 20,
            )
          : Icon(
              Icons.circle_outlined,
              color: scheme.outlineVariant,
              size: 20,
            ),
    );
  }
}
