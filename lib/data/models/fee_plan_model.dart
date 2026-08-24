import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee_plan_model.freezed.dart';
part 'fee_plan_model.g.dart';

@freezed
abstract class FeePlanModel with _$FeePlanModel {
  const factory FeePlanModel({
    required String id,
    @JsonKey(name: 'facility_type') String? facilityType,
    @JsonKey(name: 'facility_id') String? facilityId,
    required String name,
    @Default('month') String interval,
    @JsonKey(name: 'interval_count') @Default(1) int intervalCount,
    @JsonKey(fromJson: _toDouble) @Default(0) double amount,
    @Default('INR') String currency,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'show_to_citizen') @Default(true) bool showToCitizen,
    String? description,
  }) = _FeePlanModel;

  factory FeePlanModel.fromJson(Map<String, dynamic> json) =>
      _$FeePlanModelFromJson(json);
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
