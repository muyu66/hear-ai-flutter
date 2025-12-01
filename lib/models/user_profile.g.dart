// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  nickname: json['nickname'] as String,
  avatar: json['avatar'] as String?,
  rememberMethod: json['rememberMethod'] as String,
  wordsLevel: (json['wordsLevel'] as num).toInt(),
  useMinute: (json['useMinute'] as num).toInt(),
  multiSpeaker: json['multiSpeaker'] as bool,
  isWechat: json['isWechat'] as bool,
  sayRatio: (json['sayRatio'] as num).toInt(),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'rememberMethod': instance.rememberMethod,
      'wordsLevel': instance.wordsLevel,
      'useMinute': instance.useMinute,
      'multiSpeaker': instance.multiSpeaker,
      'isWechat': instance.isWechat,
      'sayRatio': instance.sayRatio,
    };
