import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_instructor_model.freezed.dart';
part 'activity_instructor_model.g.dart';

@freezed
abstract class ActivityInstructorModel with _$ActivityInstructorModel {
  const factory ActivityInstructorModel({
    required String id,
    @JsonKey(name: 'activity_id') required String activityId,
    required String name,
    String? title,
    String? bio,
    String? specialization,
    @JsonKey(name: 'photo_url') String? photoUrl,
    String? phone,
    String? email,
    @Default('active') String status,
  }) = _ActivityInstructorModel;

  factory ActivityInstructorModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityInstructorModelFromJson(json);
}
