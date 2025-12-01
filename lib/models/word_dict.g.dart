// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_dict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordDict _$WordDictFromJson(Map<String, dynamic> json) => WordDict(
  word: json['word'] as String,
  phonetic: json['phonetic'] as String,
  translation: json['translation'] as String,
);

Map<String, dynamic> _$WordDictToJson(WordDict instance) => <String, dynamic>{
  'word': instance.word,
  'phonetic': instance.phonetic,
  'translation': instance.translation,
};
