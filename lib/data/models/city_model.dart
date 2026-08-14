import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

@freezed
abstract class CityModel with _$CityModel {
  const factory CityModel({
    required String id,
    required String name,
    required String state,
    String? tagline,
    String? description,
    @JsonKey(fromJson: _toDouble) double? latitude,
    @JsonKey(fromJson: _toDouble) double? longitude,
    @JsonKey(name: 'is_capital') @Default(false) bool isCapital,
    String? timezone,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
