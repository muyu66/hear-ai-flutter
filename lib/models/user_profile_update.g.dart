// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileUpdate _$UserProfileUpdateFromJson(Map<String, dynamic> json) =>
    UserProfileUpdate(
      json['nickname'] as String?,
      json['rememberMethod'] as String?,
      (json['wordsLevel'] as num?)?.toInt(),
      (json['useMinute'] as num?)?.toInt(),
      json['multiSpeaker'] as bool?,
    );

Map<String, dynamic> _$UserProfileUpdateToJson(UserProfileUpdate instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'rememberMethod': instance.rememberMethod,
      'wordsLevel': instance.wordsLevel,
      'useMinute': instance.useMinute,
      'multiSpeaker': instance.multiSpeaker,
    };
