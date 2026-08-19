import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_schedule_model.freezed.dart';
part 'activity_schedule_model.g.dart';

@freezed
abstract class ActivityScheduleModel with _$ActivityScheduleModel {
  const factory ActivityScheduleModel({
    required String id,
    @JsonKey(name: 'batch_id') required String batchId,
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'day_name') String? dayName,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'formatted_time') String? formattedTime,
    String? room,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ActivityScheduleModel;

  factory ActivityScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityScheduleModelFromJson(json);
}
