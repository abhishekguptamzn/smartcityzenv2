import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_meta.freezed.dart';
part 'pagination_meta.g.dart';

@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @Default(0) int total,
    @Default(0) int count,
    @JsonKey(name: 'per_page') @Default(15) int perPage,
    @JsonKey(name: 'current_page') @Default(1) int currentPage,
    @JsonKey(name: 'total_pages') @Default(1) int totalPages,
    @JsonKey(name: 'has_more_pages') @Default(false) bool hasMorePages,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  static const empty = PaginationMeta();
}

/// Generic paginated result. Hand-written (not @freezed) because freezed's
/// code generation does not support generic factory constructors cleanly
/// for arbitrary item types coming from a caller-supplied `fromJsonT`.
class Paginated<T> {
  const Paginated({required this.items, required this.meta});

  final List<T> items;
  final PaginationMeta meta;

  static Paginated<T> fromEnvelope<T>(
    Map<String, dynamic> envelope,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = envelope['data'];
    final items = (data is List ? data : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(fromJsonT)
        .toList();
    final meta = envelope['meta'] as Map<String, dynamic>?;
    final pagination = meta?['pagination'] as Map<String, dynamic>?;
    return Paginated<T>(
      items: items,
      meta: pagination != null
          ? PaginationMeta.fromJson(pagination)
          : PaginationMeta.empty,
    );
  }

  static const _emptyList = <Never>[];

  static Paginated<T> empty<T>() =>
      Paginated<T>(items: List<T>.from(_emptyList), meta: PaginationMeta.empty);
}
