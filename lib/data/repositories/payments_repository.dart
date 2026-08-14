import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/payments_api.dart';
import '../models/pagination_meta.dart';
import '../models/payment_model.dart';

part 'payments_repository.g.dart';

class PaymentsRepository {
  PaymentsRepository(this._api);

  final PaymentsApi _api;

  Future<Paginated<PaymentModel>> list({
    String? status,
    String? dateFrom,
    String? dateTo,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _api.list(
      status: status,
      dateFrom: dateFrom,
      dateTo: dateTo,
      perPage: perPage,
      page: page,
    );
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      PaymentModel.fromJson,
    );
  }

  Future<PaymentModel> getById(String id) async {
    final response = await _api.getById(id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return PaymentModel.fromJson(data);
  }

  /// Walks every page of `/payments` for the current user. Used by
  /// [FacilitiesRepository.myMembershipSummaries] — see the constraint
  /// comment there for why this full-history walk is necessary.
  Future<List<PaymentModel>> listAllPages({int perPage = 50}) async {
    final List<PaymentModel> all = [];
    int page = 1;
    while (true) {
      final result = await list(perPage: perPage, page: page);
      all.addAll(result.items);
      if (!result.meta.hasMorePages || result.items.isEmpty) break;
      page++;
    }
    return all;
  }
}

@Riverpod(keepAlive: true)
PaymentsRepository paymentsRepository(Ref ref) =>
    PaymentsRepository(ref.watch(paymentsApiProvider));
