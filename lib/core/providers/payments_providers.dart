import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/payment_model.dart';
import '../../data/repositories/payments_repository.dart';

part 'payments_providers.g.dart';

class PaymentListParams {
  const PaymentListParams({this.status, this.dateFrom, this.dateTo});

  final String? status;
  final String? dateFrom;
  final String? dateTo;

  @override
  bool operator ==(Object other) =>
      other is PaymentListParams &&
      other.status == status &&
      other.dateFrom == dateFrom &&
      other.dateTo == dateTo;

  @override
  int get hashCode => Object.hash(status, dateFrom, dateTo);
}

@riverpod
class PaymentList extends _$PaymentList {
  static const _perPage = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<PaymentModel>> build(PaymentListParams params) async {
    _page = 1;
    _hasMore = true;
    final repo = ref.watch(paymentsRepositoryProvider);
    final result = await repo.list(
      status: params.status,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
      perPage: _perPage,
      page: _page,
    );
    _hasMore = result.meta.hasMorePages;
    return result.items;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.value;
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final repo = ref.read(paymentsRepositoryProvider);
      final nextPage = _page + 1;
      final result = await repo.list(
        status: params.status,
        dateFrom: params.dateFrom,
        dateTo: params.dateTo,
        perPage: _perPage,
        page: nextPage,
      );
      _page = nextPage;
      _hasMore = result.meta.hasMorePages;
      state = AsyncData([...current, ...result.items]);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}

@riverpod
Future<PaymentModel> paymentDetail(Ref ref, String id) {
  return ref.watch(paymentsRepositoryProvider).getById(id);
}
