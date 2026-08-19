import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_review_model.freezed.dart';
part 'activity_review_model.g.dart';

@freezed
abstract class ActivityReviewModel with _$ActivityReviewModel {
  const factory ActivityReviewModel({
    required String id,
    @JsonKey(name: 'activity_id') required String activityId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_avatar') String? userAvatar,
    @JsonKey(fromJson: _toDouble) @Default(5.0) double rating,
    String? title,
    String? comment,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'time_ago') String? timeAgo,
  }) = _ActivityReviewModel;

  factory ActivityReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityReviewModelFromJson(json);
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
