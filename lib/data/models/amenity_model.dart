import 'package:freezed_annotation/freezed_annotation.dart';

part 'amenity_model.freezed.dart';
part 'amenity_model.g.dart';

@freezed
abstract class AmenityModel with _$AmenityModel {
  const AmenityModel._();

  const factory AmenityModel({
    required String id,
    required String name,
    String? icon,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'facility_is_active') @Default(true) bool facilityIsActive,
  }) = _AmenityModel;

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);

  bool get isEffectiveActive => isActive && facilityIsActive;
}
