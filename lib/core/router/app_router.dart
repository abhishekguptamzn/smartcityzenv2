import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/facility_model.dart';
import '../../data/models/onboard_model.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/checkin/screens/qr_checkin_screen.dart';
import '../../features/auth/screens/login_register_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
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
import '../../features/facilities/screens/facility_detail_screen.dart';
import '../../features/facilities/screens/services_explorer_screen.dart';
import '../../features/facility_management/screens/edit_facility_details_screen.dart';
import '../../features/facility_management/screens/facility_attendance_screen.dart';
import '../../features/facility_management/screens/facility_dashboard_screen.dart';
import '../../features/facility_management/screens/facility_members_screen.dart';
import '../../features/facility_management/screens/manage_fee_plans_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/id_card_screen.dart';
import '../../features/membership/screens/membership_details_screen.dart';
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
import '../../features/security/screens/security_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/support/screens/support_tickets_screen.dart';
import '../../features/support/screens/ticket_detail_screen.dart';
import '../providers/auth_controller.dart';
import 'app_shell.dart';

part 'app_router.g.dart';

const _publicPaths = {
  '/splash',
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
      final path = state.matchedLocation;

      if (isLoading) {
        return path == '/splash' ? null : '/splash';
      }
      final isPublic = _publicPaths.contains(path) || path.startsWith('/onboard');
      if (!isLoggedIn && !isPublic) {
        return '/login';
      }
      if (isLoggedIn && (path == '/login' || path == '/splash')) {
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
          return ResetPasswordScreen(
            initialEmail: extra?['email'] as String?,
            initialToken: extra?['token'] as String?,
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
            path: '/checkin',
            builder: (context, state) => const QrCheckInScreen(),
          ),
          GoRoute(
            path: '/id-card',
            builder: (context, state) => const IdCardScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const SupportTicketsScreen(),
          ),
          GoRoute(
            path: '/security',
            builder: (context, state) => const SecurityScreen(),
          ),
          GoRoute(
            path: '/payments',
            builder: (context, state) => const PaymentsScreen(),
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
            builder: (context, state) => const CityHistoryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/services/:kind/:id',
        builder: (context, state) => FacilityDetailScreen(
          kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/membership/:kind/:memberId',
        builder: (context, state) => MembershipDetailsScreen(
          kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
          memberId: state.pathParameters['memberId']!,
          facilityId: state.uri.queryParameters['facilityId'],
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/support/tickets/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return TicketDetailScreen(ticketId: id);
        },
      ),
      GoRoute(
        path: '/payments/:id',
        builder: (context, state) =>
            PaymentReceiptScreen(paymentId: state.pathParameters['id']!),
      ),
      // Onboarding Module Routes (Gated to authenticated onboarding users only)
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
      // Facility Management Routes (for Client Users / Facility Owners)
      GoRoute(
        path: '/client/facilities',
        builder: (context, state) => const FacilityDashboardScreen(),
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
        path: '/client/manage/attendance/:kind/:id',
        builder: (context, state) => FacilityAttendanceScreen(
          kind: FacilityKind.fromPathSegment(state.pathParameters['kind']!),
          facilityId: state.pathParameters['id']!,
          facility: state.extra as FacilityModel?,
        ),
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

int _navIndexFor(String path) {
  final index = _navPaths.indexWhere((p) => path.startsWith(p));
  return index == -1 ? 0 : index;
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
