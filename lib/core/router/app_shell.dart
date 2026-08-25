import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/active_checkin_provider.dart';
import '../services/push_notification_service.dart';
import '../services/realtime_notification_service.dart';
import '../../data/api/notifications_api.dart';
import '../../data/models/notification_model.dart';
import '../../shared/widgets/glass_bottom_nav.dart';
import '../../shared/widgets/glass_sidebar.dart';
import '../../shared/widgets/in_app_notification_toast.dart';
import '../../shared/widgets/no_connection_banner.dart';

const double kWideBreakpoint = 800;

/// The persistent authenticated-area scaffold: a left [GlassSidebar] on wide
/// viewports, a [GlassBottomNav] below the breakpoint, and a centered
/// max-width column for [body] so cards don't stretch edge-to-edge on very
/// wide screens. Also displays a persistent Checked-In indicator across all pages
/// and listens for incoming real-time notifications to show animated toasts.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  StreamSubscription<NotificationModel>? _notificationSub;
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final realtimeService = ref.read(realtimeNotificationServiceProvider);
      _notificationSub = realtimeService.notificationStream.listen((notification) {
        if (mounted) {
          InAppNotificationToast.show(context, ref, notification);
        }
      });

      // Automatically register & sync FCM device token with Laravel backend
      final notifApi = ref.read(notificationsApiProvider);
      PushNotificationService.instance.syncDeviceToken(notifApi);

      // Listen for token refresh events
      _tokenRefreshSub = PushNotificationService.instance.onTokenRefresh.listen((newToken) {
        if (mounted) {
          PushNotificationService.instance.syncDeviceToken(notifApi);
        }
      });
    });
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    _tokenRefreshSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= kWideBreakpoint;
    final activeCheckinAsync = ref.watch(activeCheckinProvider);

    Widget? activeSessionBanner;
    activeCheckinAsync.whenData((session) {
      if (session['has_active_session'] == true) {
        final facilityName = session['facility_name'] ?? 'Facility';
        final facilityType = session['facility_type'] ?? '';
        final checkInAt = session['check_in_at_formatted'] ?? 'Active';

        activeSessionBanner = Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.92),
                const Color(0xFF059669).withValues(alpha: 0.92),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sensors_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34D399),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Currently Checked In',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$facilityName ${facilityType.isNotEmpty ? "($facilityType)" : ""} • $checkInAt',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.invalidate(activeCheckinProvider);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 1200 ? 1200.0 : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: Column(
              children: [
                if (activeSessionBanner != null) activeSessionBanner!,
                Expanded(child: widget.body),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: NoConnectionBanner(
        child: isWide
            ? Row(
                children: [
                  GlassSidebar(currentIndex: widget.currentIndex, onTap: widget.onTap),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
      bottomNavigationBar: isWide
          ? null
          : GlassBottomNav(currentIndex: widget.currentIndex, onTap: widget.onTap),
    );
  }
}
