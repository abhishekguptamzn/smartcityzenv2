import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/facility_model.dart';
import '../../data/models/facility_operations_models.dart';
import '../../data/models/onboard_model.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_register_screen.dart';
import '../../features/auth/screens/onboarding_slides_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/checkin/screens/qr_checkin_screen.dart';
import '../../features/city/screens/city_about_screen.dart';
import '../../features/city/screens/city_culture_screen.dart';
import '../../features/city/screens/city_famous_screen.dart';
import '../../features/city/screens/city_geography_screen.dart';
import '../../features/city/screens/city_heritage_screen.dart';
import '../../features/city/screens/city_history_screen.dart';
import '../../features/city/screens/city_information_screen.dart';
import '../../features/city/screens/city_news_screen.dart';
import '../../features/city/screens/city_origin_screen.dart';
import '../../features/city/screens/city_personalities_screen.dart';
import '../../features/facilities/models/facility_hierarchy_models.dart';
import '../../features/facilities/screens/activities_explorer_screen.dart';
import '../../features/facilities/screens/activity_detail_screen.dart';
import '../../features/facilities/screens/facility_category_centers_screen.dart';
import '../../features/facilities/screens/facility_detail_screen.dart';
import '../../features/facilities/screens/services_explorer_screen.dart';
import '../../features/facility_management/screens/edit_facility_details_screen.dart';
import '../../features/facility_management/screens/facility_attendance_screen.dart';
import '../../features/facility_management/screens/facility_collection_report_screen.dart';
import '../../features/facility_management/screens/facility_communication_screen.dart';
import '../../features/facility_management/screens/facility_current_status_screen.dart';
import '../../features/facility_management/screens/facility_daily_checkin_report_screen.dart';
import '../../features/facility_management/screens/facility_dashboard_screen.dart';
import '../../features/facility_management/screens/facility_enquiries_screen.dart';
import '../../features/facility_management/screens/facility_enquiry_conversation_screen.dart';
import '../../features/facility_management/screens/facility_expiring_members_screen.dart';
import '../../features/facility_management/screens/facility_manual_checkin_screen.dart';
import '../../features/facility_management/screens/facility_member_detail_screen.dart';
import '../../features/facility_management/screens/facility_members_screen.dart';
import '../../features/facility_management/screens/facility_monthly_attendance_report_screen.dart';
import '../../features/facility_management/screens/facility_plan_distribution_screen.dart';
import '../../features/facility_management/screens/facility_reports_screen.dart';
import '../../features/facility_management/screens/facility_settings_screen.dart';
import '../../features/facility_management/screens/facility_unpaid_members_screen.dart';
import '../../features/facility_management/screens/manage_fee_plans_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/id_card_screen.dart';
import '../../features/membership/screens/membership_details_screen.dart';
import '../../features/notifications/screens/notification_center_screen.dart';
import '../../features/onboard/screens/onboard_complete_screen.dart';
import '../../features/onboard/screens/onboard_email_sent_screen.dart';
import '../../features/onboard/screens/onboard_facility_form_screen.dart';
import '../../features/onboard/screens/onboard_home_screen.dart';
import '../../features/onboard/screens/onboard_review_screen.dart';
import '../../features/onboard/screens/onboard_select_owner_screen.dart';
import '../../features/onboard/screens/onboard_select_type_screen.dart';
import '../../features/onboard/screens/onboard_success_screen.dart';
import '../../features/onboard/screens/onboard_user_form_screen.dart';
import '../../features/payments/screens/payment_receipt_screen.dart';
import '../../features/payments/screens/payments_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/security/screens/app_lock_screen.dart';
import '../../features/security/screens/security_screen.dart';
import '../../features/security/screens/set_app_pin_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/support/screens/support_tickets_screen.dart';
import '../../features/support/screens/ticket_detail_screen.dart';
import '../providers/auth_controller.dart';
import 'app_shell.dart';

part 'app_router.g.dart';

const _publicPaths = {
  '/splash',
  '/onboarding',
  '/login',
  '/forgot-password',
  '/reset-password',
};

// Bottom-nav / sidebar tab destinations, in display order. Index into this
// list drives which tab is highlighted and what a tab tap navigates to.
const _navPaths = ['/home', '/services', '/checkin', '/id-card', '/settings'];

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authNotifier = _AuthListenable(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.value != null;
      final isLoading = authState.isLoading && !authState.hasValue;
      final hasError = authState.hasError && !authState.hasValue;
      final path = state.matchedLocation;

      if (isLoading || hasError) {
        return path == '/splash' ? null : '/splash';
      }
      final isPublic = _publicPaths.contains(path) || path.startsWith('/onboard');
      if (!isLoggedIn && !isPublic) {
        return '/login';
      }
      if (isLoggedIn && (path == '/login' || path == '/splash' || path == '/onboarding')) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingSlidesScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginRegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final emailQuery = state.uri.queryParameters['email'];
          final tokenQuery = state.uri.queryParameters['token'];
          return ResetPasswordScreen(
            initialEmail: extra?['email'] as String? ?? emailQuery,
            initialToken: extra?['token'] as String? ?? tokenQuery,
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = _navIndexFor(state.matchedLocation);
          return AppShell(
            currentIndex: index,
            onTap: (i) {
              if (index == i) return;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.go(_navPaths[i]);
                }
              });
            },
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/services',
            builder: (context, state) => ServicesExplorerScreen(
              initialSearch: state.uri.queryParameters['search'],
              initialKind: state.uri.queryParameters['kind'],
            ),
          ),
          GoRoute(
            path: '/services/:kind/:id',
            builder: (context, state) => FacilityDetailScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/services/category/:categoryId',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final category = extra?['category'] as FacilityCategoryItem?;
              if (category == null) {
                return const ServicesExplorerScreen();
              }
              final initialType = extra?['initialType'] as FacilityTypeItem?;
              final initialSearch = (extra?['initialSearch'] as String?) ?? state.uri.queryParameters['search'];
              return FacilityCategoryCentersScreen(
                category: category,
                initialType: initialType,
                initialSearch: initialSearch,
              );
            },
          ),
          GoRoute(
            path: '/activities',
            builder: (context, state) => ActivitiesExplorerScreen(
              initialCategorySlug: state.uri.queryParameters['category'],
              initialSearch: state.uri.queryParameters['search'],
            ),
          ),
          GoRoute(
            path: '/activities/:id',
            builder: (context, state) => ActivityDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/checkin',
            builder: (context, state) => const QrCheckinScreen(),
          ),
          GoRoute(
            path: '/id-card',
            builder: (context, state) => const IdCardScreen(),
          ),
          GoRoute(
            path: '/membership/details',
            redirect: (context, state) => '/id-card',
          ),
          GoRoute(
            path: '/membership',
            redirect: (context, state) => '/id-card',
          ),
          GoRoute(
            path: '/membership/:kind/:memberId',
            builder: (context, state) => MembershipDetailsScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              memberId: state.pathParameters['memberId']!,
              facilityId: state.uri.queryParameters['facilityId'],
              facilityName: state.uri.queryParameters['facilityName'],
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/profile/edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationCenterScreen(),
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const SupportTicketsScreen(),
          ),
          GoRoute(
            path: '/support/tickets/:id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null) {
                return const SupportTicketsScreen();
              }
              return TicketDetailScreen(ticketId: id);
            },
          ),
          GoRoute(
            path: '/security',
            builder: (context, state) => const SecurityScreen(),
          ),
          GoRoute(
            path: '/security/pin',
            builder: (context, state) {
              final isChanging = state.extra as bool? ?? false;
              return SetAppPinScreen(isChanging: isChanging);
            },
          ),
          GoRoute(
            path: '/security/lock',
            builder: (context, state) => const AppLockScreen(),
          ),
          GoRoute(
            path: '/payments',
            builder: (context, state) => const PaymentsScreen(),
          ),
          GoRoute(
            path: '/payments/:id',
            builder: (context, state) =>
                PaymentReceiptScreen(paymentId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/city/information',
            builder: (context, state) => const CityInformationScreen(),
          ),
          GoRoute(
            path: '/city/about',
            builder: (context, state) => const CityAboutScreen(),
          ),
          GoRoute(
            path: '/city/timeline',
            builder: (context, state) => const CityHistoryScreen(),
          ),
          GoRoute(
            path: '/city/origin',
            builder: (context, state) => const CityOriginScreen(),
          ),
          GoRoute(
            path: '/city/geography',
            builder: (context, state) => const CityGeographyScreen(),
          ),
          GoRoute(
            path: '/city/culture',
            builder: (context, state) => const CityCultureScreen(),
          ),
          GoRoute(
            path: '/city/heritage',
            builder: (context, state) => const CityHeritageScreen(),
          ),
          GoRoute(
            path: '/city/famous',
            builder: (context, state) => const CityFamousScreen(),
          ),
          GoRoute(
            path: '/city/personalities',
            builder: (context, state) => const CityPersonalitiesScreen(),
          ),
          GoRoute(
            path: '/city/news',
            builder: (context, state) => const CityNewsScreen(),
          ),
          GoRoute(
            path: '/city/history',
            redirect: (context, state) => '/city/timeline',
          ),

          // Facility Management Dashboard & Sub-Routes (All retain the global bottom navigation bar)
          GoRoute(
            path: '/client/facilities',
            builder: (context, state) => const FacilityDashboardScreen(),
          ),
          GoRoute(
            path: '/client/facility/:kind/:id',
            builder: (context, state) => FacilityDashboardScreen(
              initialKind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              initialFacilityId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/client/manage/settings/:kind/:id',
            builder: (context, state) => FacilitySettingsScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/edit/:kind/:id',
            builder: (context, state) => EditFacilityDetailsScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/plans/:kind/:id',
            builder: (context, state) => ManageFeePlansScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/members/:kind/:id',
            builder: (context, state) => FacilityMembersScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/members/:kind/:id/detail/:memberId',
            builder: (context, state) => FacilityMemberDetailScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              memberId: state.pathParameters['memberId']!,
              facility: (state.extra is Map ? (state.extra as Map)['facility'] : null) as FacilityModel?,
              initialMember: state.extra is Map<String, dynamic>
                  ? state.extra as Map<String, dynamic>
                  : (state.extra is Map ? (state.extra as Map)['initialMember'] as Map<String, dynamic>? : null),
            ),
          ),
          GoRoute(
            path: '/client/manage/attendance/:kind/:id',
            builder: (context, state) => FacilityAttendanceScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/checkin/:kind/:id',
            builder: (context, state) => FacilityManualCheckinScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/status/:kind/:id',
            builder: (context, state) => FacilityCurrentStatusScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/:kind/:id',
            builder: (context, state) => FacilityReportsScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/daily/:kind/:id',
            builder: (context, state) => FacilityDailyCheckinReportScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/monthly/:kind/:id',
            builder: (context, state) => FacilityMonthlyAttendanceReportScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/expiring/:kind/:id',
            builder: (context, state) => FacilityExpiringMembersScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/plans/:kind/:id',
            builder: (context, state) => FacilityPlanDistributionScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/unpaid/:kind/:id',
            builder: (context, state) => FacilityUnpaidMembersScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/reports/collections/:kind/:id',
            builder: (context, state) => FacilityCollectionReportScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/enquiries/:kind/:id',
            builder: (context, state) => FacilityEnquiriesScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
          GoRoute(
            path: '/client/manage/enquiries/:kind/:id/:enquiryId',
            builder: (context, state) {
              final extraMap = state.extra as Map<String, dynamic>?;
              return FacilityEnquiryConversationScreen(
                kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
                facilityId: state.pathParameters['id']!,
                enquiryId: state.pathParameters['enquiryId']!,
                initialEnquiry: extraMap?['enquiry'] as FacilityEnquiryItem?,
                facility: extraMap?['facility'] as FacilityModel?,
              );
            },
          ),
          GoRoute(
            path: '/client/manage/communication/:kind/:id',
            builder: (context, state) => FacilityCommunicationScreen(
              kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
              facilityId: state.pathParameters['id']!,
              facility: state.extra as FacilityModel?,
            ),
          ),
        ],
      ),

      // Onboarding Module Routes (Gated to authenticated onboarding users only).
      // NOTE: This secondary redirect is a presentation-layer gate ensuring standard
      // users are routed to /home, complementing server-side authorization.
      GoRoute(
        path: '/onboard',
        redirect: (context, state) {
          final user = ref.read(authControllerProvider).value;
          if (user == null) return '/login';
          if (!user.isOnboardingUser) return '/home';
          return null;
        },
        builder: (context, state) => const OnboardHomeScreen(),
      ),
      GoRoute(
        path: '/onboard/select/:type',
        builder: (context, state) {
          final typeName = state.pathParameters['type'] ?? 'user';
          final type = OnboardType.values.firstWhere(
            (t) => t.name == typeName,
            orElse: () => OnboardType.user,
          );
          return OnboardSelectTypeScreen(type: type);
        },
      ),
      GoRoute(
        path: '/onboard/user/details',
        builder: (context, state) => const OnboardUserFormScreen(),
      ),
      GoRoute(
        path: '/onboard/facility/details/:type',
        builder: (context, state) {
          final typeName = state.pathParameters['type'] ?? 'library';
          final type = OnboardType.values.firstWhere(
            (t) => t.name == typeName,
            orElse: () => OnboardType.library,
          );
          return OnboardFacilityFormScreen(type: type);
        },
      ),
      GoRoute(
        path: '/onboard/facility/owner/:type',
        builder: (context, state) {
          final typeName = state.pathParameters['type'] ?? 'library';
          final type = OnboardType.values.firstWhere(
            (t) => t.name == typeName,
            orElse: () => OnboardType.library,
          );
          return OnboardSelectOwnerScreen(type: type);
        },
      ),
      GoRoute(
        path: '/onboard/review',
        builder: (context, state) => const OnboardReviewScreen(),
      ),
      GoRoute(
        path: '/onboard/sent',
        builder: (context, state) => const OnboardEmailSentScreen(),
      ),
      GoRoute(
        path: '/onboard/complete',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return OnboardCompleteScreen(token: token);
        },
      ),
      GoRoute(
        path: '/onboard/success',
        builder: (context, state) => const OnboardSuccessScreen(),
      ),
    ],
  );
}

const _navPrefixMap = {
  '/home': 0,
  '/client': 0,
  '/services': 1,
  '/activities': 1,
  '/checkin': 2,
  '/id-card': 3,
  '/membership': 3,
  '/settings': 4,
  '/profile': 4,
  '/security': 4,
  '/payments': 4,
  '/support': 4,
  '/city': 4,
};

int _navIndexFor(String path) {
  for (final entry in _navPrefixMap.entries) {
    if (path.startsWith(entry.key)) {
      return entry.value;
    }
  }
  return 0;
}

/// Bridges Riverpod's [authControllerProvider] to go_router's
/// [Listenable]-based `refreshListenable`, so navigation redirects re-run the
/// moment the session state changes (login/logout) rather than only on the
/// next user-initiated navigation.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this._ref) {
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}
