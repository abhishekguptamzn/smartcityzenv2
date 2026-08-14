import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/city_information_model.dart';
import '../../data/models/city_model.dart';
import '../../data/repositories/cities_repository.dart';
import 'auth_controller.dart';

part 'cities_providers.g.dart';

@Riverpod(keepAlive: true)
Future<List<CityModel>> citiesList(Ref ref) async {
  final repo = ref.watch(citiesRepositoryProvider);
  final result = await repo.list(perPage: 100);
  return result.items;
}

@Riverpod(keepAlive: true)
Future<CityInformationModel> cityInformation(Ref ref, {String? cityId}) async {
  final repo = ref.watch(citiesRepositoryProvider);
  final user = ref.watch(authControllerProvider).value;
  final effectiveId = cityId ?? user?.city?.id ?? 'current';
  return repo.getInformation(effectiveId);
}
