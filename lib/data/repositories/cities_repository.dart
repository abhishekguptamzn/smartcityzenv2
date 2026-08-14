import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/cities_api.dart';
import '../models/city_information_model.dart';
import '../models/city_model.dart';
import '../models/pagination_meta.dart';

part 'cities_repository.g.dart';

class CitiesRepository {
  CitiesRepository(this._api);

  final CitiesApi _api;

  Future<Paginated<CityModel>> list({
    String? search,
    String? state,
    bool? isCapital,
    int perPage = 50,
  }) async {
    final response = await _api.list(
      search: search,
      state: state,
      isCapital: isCapital,
      perPage: perPage,
    );
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      CityModel.fromJson,
    );
  }

  Future<CityModel> get(String id) => _api.get(id).then((response) {
        final data =
            (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        return CityModel.fromJson(data);
      });

  Future<CityInformationModel> getInformation(String cityId) async {
    final response = await _api.getInformation(cityId);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return CityInformationModel.fromJson(data);
  }
}

@Riverpod(keepAlive: true)
CitiesRepository citiesRepository(Ref ref) =>
    CitiesRepository(ref.watch(citiesApiProvider));
