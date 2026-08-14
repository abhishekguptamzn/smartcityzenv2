import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/tickets_api.dart';
import '../models/pagination_meta.dart';
import '../models/ticket_model.dart';

part 'tickets_repository.g.dart';

class TicketsRepository {
  TicketsRepository(this._api);

  final TicketsApi _api;

  Future<Paginated<TicketModel>> list({
    String? status,
    String? category,
    String? search,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await _api.list(
      status: status,
      category: category,
      search: search,
      perPage: perPage,
      page: page,
    );
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      TicketModel.fromJson,
    );
  }

  Future<TicketModel> getById(int id) async {
    final response = await _api.getById(id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return TicketModel.fromJson(data);
  }

  Future<TicketModel> create({
    required String subject,
    required String message,
    String category = 'general',
    String priority = 'medium',
  }) async {
    final response = await _api.create(
      subject: subject,
      message: message,
      category: category,
      priority: priority,
    );
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return TicketModel.fromJson(data);
  }

  Future<TicketModel> reply(int id, {required String message}) async {
    final response = await _api.reply(id, message: message);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return TicketModel.fromJson(data);
  }
}

@Riverpod(keepAlive: true)
TicketsRepository ticketsRepository(Ref ref) =>
    TicketsRepository(ref.watch(ticketsApiProvider));
