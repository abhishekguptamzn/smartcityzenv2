import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/login_history_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'login_history_providers.g.dart';

@riverpod
class LoginHistoryList extends _$LoginHistoryList {
  static const _perPage = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<LoginHistoryModel>> build() async {
    _page = 1;
    _hasMore = true;
    final repo = ref.watch(authRepositoryProvider);
    final result = await repo.loginHistory(perPage: _perPage, page: _page);
    _hasMore = result.meta.hasMorePages;
    return result.items;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.value;
    if (current == null) return;
    _isLoadingMore = true;
    try {
      final repo = ref.read(authRepositoryProvider);
      final nextPage = _page + 1;
      final result = await repo.loginHistory(perPage: _perPage, page: nextPage);
      _page = nextPage;
      _hasMore = result.meta.hasMorePages;
      state = AsyncData([...current, ...result.items]);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}
