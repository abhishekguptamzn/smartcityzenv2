import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/notifications_provider.dart';
import '../../../shared/widgets/app_bar_back_button.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../widgets/notification_card.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final activeCategory = ref.watch(notificationFilterCategoryProvider);
    final notificationsAsync = ref.watch(notificationsListProvider);
    final unreadCount =
        ref.watch(unreadNotificationCountProvider).value ?? 0;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: scheme.onSurfaceVariant,
            ),
            tooltip: 'Options',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (value) async {
              if (value == 'mark_all_read') {
                await ref
                    .read(notificationsListProvider.notifier)
                    .markAllAsRead();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } else if (value == 'clear_all') {
                final confirmed = await showAppConfirmDialog(
                  context: context,
                  title: 'Clear All Notifications?',
                  message:
                      'This will permanently remove all notifications from your list.',
                  confirmLabel: 'Clear All',
                  isDestructive: true,
                );
                if (confirmed == true) {
                  await ref
                      .read(notificationsListProvider.notifier)
                      .clearAll();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All notifications cleared'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 18, color: Color(0xFF6366F1)),
                    SizedBox(width: 10),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFEF4444)),
                    SizedBox(width: 10),
                    Text('Clear all notifications'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs Bar
          _buildFilterTabs(context, ref, activeCategory),

          // Notification List Area
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(notificationsListProvider);
                ref.invalidate(unreadNotificationCountProvider);
                await ref.read(notificationsListProvider.future);
              },
              child: notificationsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, stack) => Center(
                  child: ErrorStateView(
                    error: err,
                    onRetry: () =>
                        ref.invalidate(notificationsListProvider),
                  ),
                ),
                data: (notifications) {
                  // Client-side filtering when needed
                  final filteredList = _applyCategoryFilter(
                    notifications,
                    activeCategory,
                  );

                  if (filteredList.isEmpty) {
                    return _buildEmptyState(activeCategory);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return NotificationCard(
                        key: ValueKey(item.id),
                        notification: item,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(
    BuildContext context,
    WidgetRef ref,
    String activeCategory,
  ) {
    final categories = [
      {'id': 'all', 'label': 'All'},
      {'id': 'unread', 'label': 'Unread'},
      {'id': 'alerts', 'label': 'Alerts'},
      {'id': 'announcements', 'label': 'Announcements'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final isSelected = activeCategory == cat['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat['label']!),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(notificationFilterCategoryProvider.notifier)
                        .setCategory(cat['id']!);
                  }
                },
                selectedColor: const Color(0xFF6366F1),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<dynamic> _applyCategoryFilter(List<dynamic> list, String category) {
    if (category == 'unread') {
      return list.where((n) => n.isUnread).toList();
    } else if (category == 'alerts') {
      return list.where((n) => n.categoryGroup == 'alerts').toList();
    } else if (category == 'announcements') {
      return list.where((n) => n.categoryGroup == 'announcements').toList();
    }
    return list;
  }

  Widget _buildEmptyState(String category) {
    String title;
    String subtitle;
    IconData icon;

    switch (category) {
      case 'unread':
        title = "You're all caught up!";
        subtitle = 'No unread notifications at the moment.';
        icon = Icons.done_all_rounded;
        break;
      case 'alerts':
        title = 'No active alerts';
        subtitle = 'Check-in, payment, and pass alerts will show here.';
        icon = Icons.notifications_none_rounded;
        break;
      case 'announcements':
        title = 'No announcements';
        subtitle = 'Facility and city notices will appear here.';
        icon = Icons.campaign_outlined;
        break;
      default:
        title = 'No notifications yet';
        subtitle = 'When you receive updates and alerts, they will appear here.';
        icon = Icons.notifications_off_outlined;
    }

    return ListView(
      children: [
        const SizedBox(height: 100),
        Center(
          child: EmptyStateView(
            icon: icon,
            message: '$title\n$subtitle',
          ),
        ),
      ],
    );
  }
}
