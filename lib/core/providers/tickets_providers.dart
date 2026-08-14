import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/ticket_model.dart';
import '../../data/repositories/tickets_repository.dart';

part 'tickets_providers.g.dart';

class TicketListParams {
  const TicketListParams({this.status, this.category, this.search});

  final String? status;
  final String? category;
  final String? search;

  @override
  bool operator ==(Object other) =>
      other is TicketListParams &&
      other.status == status &&
      other.category == category &&
      other.search == search;

  @override
  int get hashCode => Object.hash(status, category, search);
}

@riverpod
class TicketList extends _$TicketList {
  static const _perPage = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<TicketModel>> build(TicketListParams params) async {
    _page = 1;
    _hasMore = true;
    final repo = ref.watch(ticketsRepositoryProvider);
    final result = await repo.list(
      status: params.status,
      category: params.category,
      search: params.search,
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
      final repo = ref.read(ticketsRepositoryProvider);
      final nextPage = _page + 1;
      final result = await repo.list(
        status: params.status,
        category: params.category,
        search: params.search,
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
Future<TicketModel> ticketDetail(Ref ref, int id) {
  return ref.watch(ticketsRepositoryProvider).getById(id);
}
