import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/notifications_provider.dart';
import '../../../data/models/notification_model.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import 'notification_card.dart';

/// Shows the notifications list as a bottom sheet modal directly on screen.
Future<void> showNotificationBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const NotificationSheet(),
  );
}

class NotificationSheet extends ConsumerWidget {
  const NotificationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeCategory = ref.watch(notificationFilterCategoryProvider);
    final notificationsAsync = ref.watch(notificationsListProvider);
    final unreadCount =
        ref.watch(unreadNotificationCountProvider).value ?? 0;

    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = mediaQuery.size.height * 0.85;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
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
                const Spacer(),
                if (unreadCount > 0)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.done_all_rounded, size: 16),
                    label: const Text('Mark Read', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      ref
                          .read(notificationsListProvider.notifier)
                          .markAllAsRead();
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.open_in_full_rounded, size: 18),
                  tooltip: 'Full Screen',
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/notifications');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  tooltip: 'Close',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Category Filter Chips
          _buildFilterTabs(context, ref, activeCategory),
          const Divider(height: 1, thickness: 0.5),

          // List of Notifications
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
                error: (err, _) => Center(
                  child: ErrorStateView(
                    error: err,
                    onRetry: () =>
                        ref.invalidate(notificationsListProvider),
                  ),
                ),
                data: (notifications) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<NotificationModel> _applyCategoryFilter(
    List<NotificationModel> list,
    String category,
  ) {
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
        const SizedBox(height: 60),
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
