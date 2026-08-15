import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/client_facility_api.dart';
import '../models/facility_model.dart';
import '../models/fee_plan_model.dart';

part 'client_facility_repository.g.dart';

class ClientFacilityRepository {
  ClientFacilityRepository(this._api);

  final ClientFacilityApi _api;

  Future<Map<String, dynamic>> getMyFacilities() async {
    final res = await _api.getMyFacilities();
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    final gymsRaw = data['gyms'] as List? ?? [];
    final libsRaw = data['libraries'] as List? ?? [];

    return {
      'gyms': gymsRaw.map((j) => FacilityModel.fromJson(j as Map<String, dynamic>)).toList(),
      'libraries': libsRaw.map((j) => FacilityModel.fromJson(j as Map<String, dynamic>)).toList(),
      'total_facilities': data['total_facilities'] ?? 0,
      'is_client_user': data['is_client_user'] ?? false,
    };
  }

  // Gyms
  Future<Map<String, dynamic>> getGymDetails(String gymId) async {
    final res = await _api.getGym(gymId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return {
      'facility': FacilityModel.fromJson(data['gym'] as Map<String, dynamic>),
      'stats': data['stats'] as Map<String, dynamic>? ?? {},
    };
  }

  Future<FacilityModel> updateGymDetails(String gymId, Map<String, dynamic> payload) async {
    final res = await _api.updateGym(gymId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FacilityModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<FeePlanModel>> getGymPlans(String gymId) async {
    final res = await _api.getGymPlans(gymId);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.map((j) => FeePlanModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FeePlanModel> createGymPlan(String gymId, Map<String, dynamic> payload) async {
    final res = await _api.createGymPlan(gymId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<FeePlanModel> updateGymPlan(String gymId, String planId, Map<String, dynamic> payload) async {
    final res = await _api.updateGymPlan(gymId, planId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteGymPlan(String gymId, String planId) async {
    await _api.deleteGymPlan(gymId, planId);
  }

  Future<List<Map<String, dynamic>>> getGymMembers(String gymId, {String? search, String? status, int page = 1}) async {
    final res = await _api.getGymMembers(gymId, search: search, status: status, page: page);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addGymMember(String gymId, Map<String, dynamic> payload) async {
    final res = await _api.addGymMember(gymId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }

  Future<List<Map<String, dynamic>>> getGymAttendance(String gymId, {String? date, int page = 1}) async {
    final res = await _api.getGymAttendance(gymId, date: date, page: page);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  // Libraries
  Future<Map<String, dynamic>> getLibraryDetails(String libraryId) async {
    final res = await _api.getLibrary(libraryId);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return {
      'facility': FacilityModel.fromJson(data['library'] as Map<String, dynamic>),
      'stats': data['stats'] as Map<String, dynamic>? ?? {},
    };
  }

  Future<FacilityModel> updateLibraryDetails(String libraryId, Map<String, dynamic> payload) async {
    final res = await _api.updateLibrary(libraryId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FacilityModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<FeePlanModel>> getLibraryPlans(String libraryId) async {
    final res = await _api.getLibraryPlans(libraryId);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.map((j) => FeePlanModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FeePlanModel> createLibraryPlan(String libraryId, Map<String, dynamic> payload) async {
    final res = await _api.createLibraryPlan(libraryId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<FeePlanModel> updateLibraryPlan(String libraryId, String planId, Map<String, dynamic> payload) async {
    final res = await _api.updateLibraryPlan(libraryId, planId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return FeePlanModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteLibraryPlan(String libraryId, String planId) async {
    await _api.deleteLibraryPlan(libraryId, planId);
  }

  Future<List<Map<String, dynamic>>> getLibraryMembers(String libraryId, {String? search, String? status, int page = 1}) async {
    final res = await _api.getLibraryMembers(libraryId, search: search, status: status, page: page);
    final rawList = res.data is Map ? (res.data['data'] as List? ?? []) : (res.data as List? ?? []);
    return rawList.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addLibraryMember(String libraryId, Map<String, dynamic> payload) async {
    final res = await _api.addLibraryMember(libraryId, payload);
    final data = res.data is Map ? (res.data['data'] ?? res.data) : {};
    return data is Map ? data.cast<String, dynamic>() : {};
  }
}

@Riverpod(keepAlive: true)
ClientFacilityRepository clientFacilityRepository(Ref ref) {
  return ClientFacilityRepository(ref.watch(clientFacilityApiProvider));
}
