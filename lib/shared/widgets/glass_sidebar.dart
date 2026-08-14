import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/auth_controller.dart';
import '../../l10n/gen/app_localizations.dart';
import 'glass_container.dart';

enum _SidebarMenuAction {
  profile,
  faqs,
  privacyPolicy,
  contactUs,
  feedback,
  logout,
}

class GlassSidebar extends ConsumerWidget {
  const GlassSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    _SidebarMenuAction action,
    AppLocalizations l10n,
  ) async {
    if (action == _SidebarMenuAction.profile) {
      context.push('/profile');
      return;
    }
    if (action != _SidebarMenuAction.logout) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
      return;
    }
    await ref.read(authControllerProvider.notifier).logout();
    if (context.mounted) context.go('/login');
  }

  Future<void> _openMenu(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final scheme = Theme.of(context).colorScheme;
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final action = await showMenu<_SidebarMenuAction>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        _menuItem(
          _SidebarMenuAction.profile,
          Icons.person_outline_rounded,
          l10n.profile,
        ),
        _menuItem(
          _SidebarMenuAction.faqs,
          Icons.help_outline_rounded,
          l10n.faqs,
        ),
        _menuItem(
          _SidebarMenuAction.privacyPolicy,
          Icons.privacy_tip_outlined,
          l10n.privacyPolicy,
        ),
        _menuItem(
          _SidebarMenuAction.contactUs,
          Icons.mail_outline_rounded,
          l10n.contactUs,
        ),
        _menuItem(
          _SidebarMenuAction.feedback,
          Icons.chat_bubble_outline_rounded,
          l10n.feedback,
        ),
        const PopupMenuDivider(),
        _menuItem(
          _SidebarMenuAction.logout,
          Icons.logout_rounded,
          l10n.logout,
          color: scheme.error,
        ),
      ],
    );
    if (action != null && context.mounted) {
      await _handleMenuAction(context, ref, action, l10n);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(authControllerProvider).value;
    final items = <(IconData, IconData, String)>[
      (Icons.home_outlined, Icons.home_rounded, l10n.home),
      (Icons.grid_view_outlined, Icons.grid_view_rounded, l10n.services),
      (Icons.qr_code_scanner_rounded, Icons.qr_code_scanner_rounded, 'Check-in'),
      (Icons.badge_outlined, Icons.badge_rounded, l10n.id),
      (Icons.settings_outlined, Icons.settings_rounded, l10n.settings),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 24),
      child: GlassContainer(
        level: GlassLevel.navigation,
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (menuContext) => Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openMenu(menuContext, ref, l10n),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: scheme.primary.withValues(
                            alpha: 0.14,
                          ),
                          child: Text(
                            user?.initials ?? '?',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: scheme.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.appName,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.sora(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.expand_more_rounded,
                          size: 18,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _SidebarItem(
                  outlineIcon: items[i].$1,
                  filledIcon: items[i].$2,
                  label: items[i].$3,
                  selected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<_SidebarMenuAction> _menuItem(
    _SidebarMenuAction value,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(label, style: color != null ? TextStyle(color: color) : null),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.outlineIcon,
    required this.filledIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData outlineIcon;
  final IconData filledIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.secondary : scheme.onSurfaceVariant;
    return Material(
      color: selected
          ? scheme.secondaryContainer.withValues(alpha: 0.25)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(selected ? filledIcon : outlineIcon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
