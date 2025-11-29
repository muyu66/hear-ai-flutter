// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  json['nickname'] as String,
  json['avatar'] as String?,
  json['rememberMethod'] as String,
  (json['wordsLevel'] as num).toInt(),
  (json['useMinute'] as num).toInt(),
  json['multiSpeaker'] as bool,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'rememberMethod': instance.rememberMethod,
      'wordsLevel': instance.wordsLevel,
      'useMinute': instance.useMinute,
      'multiSpeaker': instance.multiSpeaker,
    };
