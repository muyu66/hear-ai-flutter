// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileUpdate _$UserProfileUpdateFromJson(Map<String, dynamic> json) =>
    UserProfileUpdate(
      nickname: json['nickname'] as String?,
      rememberMethod: json['rememberMethod'] as String?,
      wordsLevel: (json['wordsLevel'] as num?)?.toInt(),
      useMinute: (json['useMinute'] as num?)?.toInt(),
      multiSpeaker: json['multiSpeaker'] as bool?,
      sayRatio: (json['sayRatio'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserProfileUpdateToJson(UserProfileUpdate instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'rememberMethod': instance.rememberMethod,
      'wordsLevel': instance.wordsLevel,
      'useMinute': instance.useMinute,
      'multiSpeaker': instance.multiSpeaker,
      'sayRatio': instance.sayRatio,
    };
