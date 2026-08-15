import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'client_facility_api.g.dart';

class ClientFacilityApi {
  ClientFacilityApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> getMyFacilities() =>
      _dio.get('/client/facilities');

  // Gyms
  Future<Response<dynamic>> getGym(String gymId) =>
      _dio.get('/client/gyms/$gymId');

  Future<Response<dynamic>> updateGym(String gymId, Map<String, dynamic> data) =>
      _dio.put('/client/gyms/$gymId', data: data);

  Future<Response<dynamic>> getGymPlans(String gymId) =>
      _dio.get('/client/gyms/$gymId/plans');

  Future<Response<dynamic>> createGymPlan(String gymId, Map<String, dynamic> data) =>
      _dio.post('/client/gyms/$gymId/plans', data: data);

  Future<Response<dynamic>> updateGymPlan(String gymId, String planId, Map<String, dynamic> data) =>
      _dio.put('/client/gyms/$gymId/plans/$planId', data: data);

  Future<Response<dynamic>> deleteGymPlan(String gymId, String planId) =>
      _dio.delete('/client/gyms/$gymId/plans/$planId');

  Future<Response<dynamic>> getGymMembers(String gymId, {String? search, String? status, int page = 1}) =>
      _dio.get('/client/gyms/$gymId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addGymMember(String gymId, Map<String, dynamic> data) =>
      _dio.post('/client/gyms/$gymId/members', data: data);

  Future<Response<dynamic>> getGymAttendance(String gymId, {String? date, int page = 1}) =>
      _dio.get('/client/gyms/$gymId/attendance', queryParameters: {
        if (date != null) 'date': date,
        'page': page,
      });

  // Libraries
  Future<Response<dynamic>> getLibrary(String libraryId) =>
      _dio.get('/client/libraries/$libraryId');

  Future<Response<dynamic>> updateLibrary(String libraryId, Map<String, dynamic> data) =>
      _dio.put('/client/libraries/$libraryId', data: data);

  Future<Response<dynamic>> getLibraryPlans(String libraryId) =>
      _dio.get('/client/libraries/$libraryId/plans');

  Future<Response<dynamic>> createLibraryPlan(String libraryId, Map<String, dynamic> data) =>
      _dio.post('/client/libraries/$libraryId/plans', data: data);

  Future<Response<dynamic>> updateLibraryPlan(String libraryId, String planId, Map<String, dynamic> data) =>
      _dio.put('/client/libraries/$libraryId/plans/$planId', data: data);

  Future<Response<dynamic>> deleteLibraryPlan(String libraryId, String planId) =>
      _dio.delete('/client/libraries/$libraryId/plans/$planId');

  Future<Response<dynamic>> getLibraryMembers(String libraryId, {String? search, String? status, int page = 1}) =>
      _dio.get('/client/libraries/$libraryId/members', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
        'page': page,
      });

  Future<Response<dynamic>> addLibraryMember(String libraryId, Map<String, dynamic> data) =>
      _dio.post('/client/libraries/$libraryId/members', data: data);
}

@Riverpod(keepAlive: true)
ClientFacilityApi clientFacilityApi(Ref ref) {
  return ClientFacilityApi(ref.watch(dioProvider));
}
