// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentenceVersion _$SentenceVersionFromJson(Map<String, dynamic> json) =>
    SentenceVersion(
      lang: json['lang'] as String,
      updatedAt: json['updatedAt'] as String,
      totalCount: json['totalCount'] as String,
    );

Map<String, dynamic> _$SentenceVersionToJson(SentenceVersion instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'updatedAt': instance.updatedAt,
      'totalCount': instance.totalCount,
    };
