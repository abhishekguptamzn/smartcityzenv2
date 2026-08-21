import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'app_config_api.g.dart';

class MobileSecurityPolicy {
  const MobileSecurityPolicy({
    this.lockEnabled = true,
    this.lockMandatory = false,
    this.biometricAllowed = true,
  });

  final bool lockEnabled;
  final bool lockMandatory;
  final bool biometricAllowed;

  factory MobileSecurityPolicy.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MobileSecurityPolicy();
    return MobileSecurityPolicy(
      lockEnabled: json['lock_enabled'] == true || json['lock_enabled'] == 'true' || json['lock_enabled'] == 1,
      lockMandatory: json['lock_mandatory'] == true || json['lock_mandatory'] == 'true' || json['lock_mandatory'] == 1,
      biometricAllowed: json['biometric_allowed'] == true || json['biometric_allowed'] == 'true' || json['biometric_allowed'] == 1,
    );
  }
}

class AppConfigModel {
  const AppConfigModel({
    this.mobileSecurity = const MobileSecurityPolicy(),
    this.organizationName = 'Smart CityZen',
    this.supportEmail = 'support@smartcityzen.gov.in',
    this.currencySymbol = '₹',
  });

  final MobileSecurityPolicy mobileSecurity;
  final String organizationName;
  final String supportEmail;
  final String currencySymbol;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final sec = data['mobile_security'] as Map<String, dynamic>?;
    final branding = data['branding'] as Map<String, dynamic>?;
    final currency = data['currency'] as Map<String, dynamic>?;

    return AppConfigModel(
      mobileSecurity: MobileSecurityPolicy.fromJson(sec),
      organizationName: branding?['organization_name']?.toString() ?? 'Smart CityZen',
      supportEmail: branding?['support_email']?.toString() ?? 'support@smartcityzen.gov.in',
      currencySymbol: currency?['symbol']?.toString() ?? '₹',
    );
  }
}

class AppConfigApi {
  AppConfigApi(this._dio);

  final Dio _dio;

  Future<AppConfigModel> fetchAppConfig() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/app-config');
      return AppConfigModel.fromJson(res.data ?? {});
    } catch (_) {
      return const AppConfigModel();
    }
  }
}

@Riverpod(keepAlive: true)
AppConfigApi appConfigApi(Ref ref) => AppConfigApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
Future<AppConfigModel> appConfig(Ref ref) => ref.watch(appConfigApiProvider).fetchAppConfig();
