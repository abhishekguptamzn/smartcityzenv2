import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/notifications_provider.dart';
import '../../../data/models/notification_model.dart';

class NotificationCard extends ConsumerWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onDismissed,
  });

  final NotificationModel notification;
  final VoidCallback? onDismissed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final typeConfig = _getTypeConfig(notification.type);

    return Dismissible(
      key: Key('notif_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
            SizedBox(width: 6),
            Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) async {
        final removed = await ref
            .read(notificationsListProvider.notifier)
            .deleteNotification(notification.id);

        if (context.mounted && removed != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification removed'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Undo',
                textColor: const Color(0xFF6366F1),
                onPressed: () {
                  ref
                      .read(notificationsListProvider.notifier)
                      .restoreNotification(removed);
                },
              ),
            ),
          );
        }
        onDismissed?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark
              ? (notification.isUnread
                  ? const Color(0xFF1E293B).withValues(alpha: 0.9)
                  : const Color(0xFF0F172A).withValues(alpha: 0.7))
              : (notification.isUnread
                  ? Colors.white
                  : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isUnread
                ? typeConfig.color.withValues(alpha: 0.35)
                : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
            width: notification.isUnread ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: notification.isUnread
                  ? typeConfig.color.withValues(alpha: isDark ? 0.15 : 0.08)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (notification.isUnread) {
                ref
                    .read(notificationsListProvider.notifier)
                    .markAsRead(notification.id);
              }
              if (notification.hasAction) {
                _handleAction(context, ref, notification.actionRoute!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Category Icon, Badge, Timestamp & Close Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: typeConfig.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          typeConfig.icon,
                          size: 18,
                          color: typeConfig.color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: typeConfig.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          typeConfig.label.toUpperCase(),
                          style: TextStyle(
                            color: typeConfig.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      if (notification.isUrgent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'URGENT',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (notification.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6366F1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        notification.createdAtFormatted ?? 'Just now',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Close / Dismiss 'X' button
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        tooltip: 'Dismiss',
                        onPressed: () {
                          ref
                              .read(notificationsListProvider.notifier)
                              .deleteNotification(notification.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          notification.isUnread ? FontWeight.w700 : FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Message
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                    ),
                  ),

                  // Custom Action Buttons
                  if (notification.hasAction || notification.hasSecondaryAction) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (notification.hasAction)
                          FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  typeConfig.color.withValues(alpha: 0.14),
                              foregroundColor: typeConfig.color,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                            label: Text(
                              notification.actionLabel ?? 'View Details',
                            ),
                            onPressed: () {
                              ref
                                  .read(notificationsListProvider.notifier)
                                  .executeAction(notification.id);
                              _handleAction(
                                context,
                                ref,
                                notification.actionRoute!,
                              );
                            },
                          ),
                        if (notification.hasSecondaryAction) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: scheme.onSurfaceVariant,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(
                              notification.secondaryActionLabel ?? 'More',
                            ),
                            onPressed: () {
                              _handleAction(
                                context,
                                ref,
                                notification.secondaryActionRoute!,
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String route) {
    if (route.startsWith('http://') || route.startsWith('https://')) {
      final uri = Uri.tryParse(route);
      if (uri != null) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      context.push(route);
    }
  }

  _TypeConfig _getTypeConfig(String type) {
    switch (type.toLowerCase()) {
      case 'checkin':
        return const _TypeConfig(
          label: 'Check-in',
          color: Color(0xFF10B981),
          icon: Icons.login_rounded,
        );
      case 'checkout':
        return const _TypeConfig(
          label: 'Check-out',
          color: Color(0xFF06B6D4),
          icon: Icons.logout_rounded,
        );
      case 'membership':
        return const _TypeConfig(
          label: 'Membership',
          color: Color(0xFF8B5CF6),
          icon: Icons.card_membership_rounded,
        );
      case 'payment':
        return const _TypeConfig(
          label: 'Payment',
          color: Color(0xFFF59E0B),
          icon: Icons.account_balance_wallet_rounded,
        );
      case 'ticket':
        return const _TypeConfig(
          label: 'Support',
          color: Color(0xFF3B82F6),
          icon: Icons.support_agent_rounded,
        );
      case 'facility':
        return const _TypeConfig(
          label: 'Facility',
          color: Color(0xFF6366F1),
          icon: Icons.business_rounded,
        );
      case 'security':
        return const _TypeConfig(
          label: 'Security',
          color: Color(0xFFEF4444),
          icon: Icons.security_rounded,
        );
      default:
        return const _TypeConfig(
          label: 'Notification',
          color: Color(0xFF64748B),
          icon: Icons.notifications_rounded,
        );
    }
  }
}

class _TypeConfig {
  const _TypeConfig({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}
