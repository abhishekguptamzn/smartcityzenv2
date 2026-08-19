// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityReviewModel _$ActivityReviewModelFromJson(Map<String, dynamic> json) =>
    _ActivityReviewModel(
      id: json['id'] as String,
      activityId: json['activity_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
      rating: json['rating'] == null ? 5.0 : _toDouble(json['rating']),
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String?,
      timeAgo: json['time_ago'] as String?,
    );

Map<String, dynamic> _$ActivityReviewModelToJson(
  _ActivityReviewModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'activity_id': instance.activityId,
  'user_id': instance.userId,
  'user_name': instance.userName,
  'user_avatar': instance.userAvatar,
  'rating': instance.rating,
  'title': instance.title,
  'comment': instance.comment,
  'created_at': instance.createdAt,
  'time_ago': instance.timeAgo,
};
