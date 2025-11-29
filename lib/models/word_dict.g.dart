// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_dict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordDict _$WordDictFromJson(Map<String, dynamic> json) => WordDict(
  json['word'] as String,
  json['phonetic'] as String,
  json['translation'] as String,
);

Map<String, dynamic> _$WordDictToJson(WordDict instance) => <String, dynamic>{
  'word': instance.word,
  'phonetic': instance.phonetic,
  'translation': instance.translation,
};
