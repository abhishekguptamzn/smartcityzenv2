// "My memberships" derivation — read this before touching anything below.
//
// There is NO API endpoint that lists a customer's own memberships. The
// member-show endpoint (`GET /{libraries|gyms}/{facility_id}/members/{id}`)
// requires the facility id in the URL, but a payment record only carries
// `payable_type` (LibraryMember/GymMember) and `payable_id` (the member id)
// — never the owning facility id. So a payment alone can never be resolved
// into a full member record; a genuine "my memberships" list is not
// buildable from this API as designed.
//
// What IS buildable: the customer's own payment history is self-scoped
// server-side (`GET /payments`), so we can recover which membership records
// they've paid for and show payment-derived facts (amount, currency, last
// paid date) without ever calling the members endpoint. `myMembershipSummaries`
// below does exactly that and no more — it must not be extended into a fake
// membership-resolution pipeline the API can't actually support. The
// Membership Details screen is responsible for attempting the full member
// lookup ONLY when a facility id is separately known (e.g. passed via
// navigation from a screen that already fetched the facility), and must
// degrade gracefully to a "contact staff" notice otherwise.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/facilities_api.dart';
import '../models/facility_model.dart';
import '../models/my_membership_summary.dart';
import '../models/pagination_meta.dart';
import '../models/payment_model.dart';
import 'payments_repository.dart';

part 'facilities_repository.g.dart';

class FacilitiesRepository {
  FacilitiesRepository(this._api, this._paymentsRepository);

  final FacilitiesApi _api;
  final PaymentsRepository _paymentsRepository;

  Future<Paginated<FacilityModel>> list({
    required FacilityKind kind,
    String? search,
    String? cityId,
    String? location,
    String? status,
    String? sortBy,
    String? sortDir,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _api.list(
      kind: kind,
      search: search,
      cityId: cityId,
      location: location,
      status: status,
      sortBy: sortBy,
      sortDir: sortDir,
      perPage: perPage,
      page: page,
    );
    final paginated = Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      FacilityModel.fromJson,
    );
    return Paginated<FacilityModel>(
      items: paginated.items.map((f) => f.copyWith(kind: kind)).toList(),
      meta: paginated.meta,
    );
  }

  Future<Paginated<FacilityModel>> nearbyLibraries({
    double? latitude,
    double? longitude,
    String? cityId,
    String? search,
    double? maxDistanceKm,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _api.nearbyLibraries(
      latitude: latitude,
      longitude: longitude,
      cityId: cityId,
      search: search,
      maxDistanceKm: maxDistanceKm,
      perPage: perPage,
      page: page,
    );
    final paginated = Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      FacilityModel.fromJson,
    );
    return Paginated<FacilityModel>(
      items: paginated.items
          .map((f) => f.copyWith(kind: FacilityKind.library))
          .toList(),
      meta: paginated.meta,
    );
  }

  Future<FacilityModel> getById(FacilityKind kind, String id) async {
    final response = await _api.getById(kind, id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return FacilityModel.fromJson(data).copyWith(kind: kind);
  }

  Future<List<Map<String, dynamic>>> feePlans(
    FacilityKind kind,
    String facilityId,
  ) async {
    final response = await _api.feePlans(kind, facilityId);
    final data = response.data;
    // Plain array response, not the paginated envelope.
    if (data is List) return data.whereType<Map<String, dynamic>>().toList();
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List).whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }

  Future<List<MyMembershipSummary>> myMembershipSummaries() async {
    // 1. First attempt direct memberships retrieval from dedicated API
    try {
      final response = await _api.myMemberships();
      final data = response.data;
      final rawList = data is Map<String, dynamic> && data['data'] is List
          ? data['data'] as List
          : (data is List ? data : null);

      if (rawList != null && rawList.isNotEmpty) {
        final List<MyMembershipSummary> summaries = [];
        for (final raw in rawList) {
          if (raw is! Map<String, dynamic>) continue;
          final facilityMap = raw['facility'] is Map<String, dynamic>
              ? raw['facility'] as Map<String, dynamic>
              : null;
          final facName = raw['facility_name']?.toString() ??
              facilityMap?['name']?.toString();
          final facId = raw['facility_id']?.toString() ??
              facilityMap?['id']?.toString();
          final catMap = facilityMap?['category'] is Map<String, dynamic>
              ? facilityMap!['category'] as Map<String, dynamic>
              : null;
          final catSlug = (raw['category_slug'] ??
                  catMap?['slug'] ??
                  raw['category_name'] ??
                  catMap?['name'] ??
                  raw['kind'] ??
                  '')
              .toString()
              .toLowerCase();

          final FacilityKind kind = switch (catSlug) {
            'gym' || 'gyms' || 'gymmember' || 'sports' || 'fitness' => FacilityKind.gym,
            'activity' || 'activities' || 'activityenrollment' || 'hobby' || 'craft' => FacilityKind.activity,
            _ => catSlug.contains('gym') || catSlug.contains('sport')
                ? FacilityKind.gym
                : (catSlug.contains('activ') || catSlug.contains('hobby') || catSlug.contains('craft')
                    ? FacilityKind.activity
                    : FacilityKind.library),
          };

          final payableId =
              raw['payable_id']?.toString() ?? raw['id']?.toString();
          if (payableId == null || payableId.isEmpty) continue;

          final dateRaw = raw['end_date'] ??
              raw['latest_paid_at'] ??
              raw['start_date'] ??
              raw['created_at'];
          final parsedDate =
              dateRaw != null ? DateTime.tryParse(dateRaw.toString()) : null;
          final startRaw = raw['start_date'];
          final startDate =
              startRaw != null ? DateTime.tryParse(startRaw.toString()) : null;
          final endRaw = raw['end_date'];
          final endDate =
              endRaw != null ? DateTime.tryParse(endRaw.toString()) : null;

          final amountRaw = raw['amount'];
          final double amount = amountRaw is num
              ? amountRaw.toDouble()
              : double.tryParse(amountRaw?.toString() ?? '0') ?? 0;

          final status = raw['status']?.toString();
          final bool? isValid = raw['is_valid'] is bool
              ? raw['is_valid'] as bool
              : (status != null
                  ? (status == 'active' &&
                      (endDate == null || !endDate.isBefore(DateTime.now())))
                  : null);

          final batchMap = raw['batch'] is Map<String, dynamic>
              ? raw['batch'] as Map<String, dynamic>
              : null;

          summaries.add(MyMembershipSummary(
            kind: kind,
            payableId: payableId,
            latestPaidAt: parsedDate,
            amount: amount,
            currency: raw['currency']?.toString() ?? 'INR',
            facilityId: facId,
            facilityName: facName,
            categoryName: catMap?['name']?.toString() ??
                raw['category_name']?.toString(),
            status: status,
            isValid: isValid,
            startDate: startDate,
            endDate: endDate,
            membershipType: raw['membership_type']?.toString(),
            batchName: batchMap?['name']?.toString(),
          ));
        }

        if (summaries.isNotEmpty) {
          summaries.sort((a, b) {
            final aDate = a.latestPaidAt ?? DateTime(0);
            final bDate = b.latestPaidAt ?? DateTime(0);
            return bDate.compareTo(aDate);
          });
          return summaries;
        }
      }
    } catch (_) {
      // Fall through to payments-derived discovery
    }

    // 2. Fallback: derive memberships from self-scoped payments history
    final List<PaymentModel> all = await _paymentsRepository.listAllPages();
    final Map<(FacilityKind, String), PaymentModel> latestByRef = {};

    for (final payment in all) {
      final payableType = payment.payableType;
      final payableId = payment.payableId;
      if (payableType == null || payableId == null) continue;

      final FacilityKind? kind = switch (payableType) {
        'FacilityMember' || 'Facility' || 'App\\Models\\FacilityMember' || 'App\\Models\\Facility' => FacilityKind.gym,
        'LibraryMember' || 'Library' || 'App\\Models\\LibraryMember' || 'App\\Models\\Library' => FacilityKind.library,
        'GymMember' || 'Gym' || 'App\\Models\\GymMember' || 'App\\Models\\Gym' => FacilityKind.gym,
        'ActivityEnrollment' || 'Activity' || 'App\\Models\\ActivityEnrollment' || 'App\\Models\\Activity' => FacilityKind.activity,
        _ => payableType.contains('Gym')
            ? FacilityKind.gym
            : (payableType.contains('Library')
                ? FacilityKind.library
                : (payableType.contains('Activity') || payableType.contains('Enrollment')
                    ? FacilityKind.activity
                    : (payableType.contains('Facility') ? FacilityKind.gym : null))),
      };
      if (kind == null) continue;

      final key = (kind, payableId);
      final existing = latestByRef[key];
      if (existing == null ||
          (payment.paidAt ?? payment.createdAt ?? DateTime(0)).isAfter(
            existing.paidAt ?? existing.createdAt ?? DateTime(0),
          )) {
        latestByRef[key] = payment;
      }
    }

    return latestByRef.entries.map((entry) {
      final (kind, payableId) = entry.key;
      final payment = entry.value;
      return MyMembershipSummary(
        kind: kind,
        payableId: payableId,
        latestPaidAt: payment.paidAt ?? payment.createdAt,
        amount: payment.amount,
        currency: payment.currency,
        facilityId: payment.facilityId,
        facilityName: payment.facilityName,
      );
    }).toList()..sort((a, b) {
      final aDate = a.latestPaidAt ?? DateTime(0);
      final bDate = b.latestPaidAt ?? DateTime(0);
      return bDate.compareTo(aDate);
    });
  }
}

@Riverpod(keepAlive: true)
FacilitiesRepository facilitiesRepository(Ref ref) {
  return FacilitiesRepository(
    ref.watch(facilitiesApiProvider),
    ref.watch(paymentsRepositoryProvider),
  );
}
