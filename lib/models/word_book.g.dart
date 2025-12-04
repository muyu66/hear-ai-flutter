// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBook _$WordBookFromJson(Map<String, dynamic> json) => WordBook(
  word: json['word'] as String,
  phonetic: json['phonetic'] as String,
  translation: json['translation'] as String,
  type: $enumDecode(_$WordWidgetTypeEnumMap, json['type']),
);

Map<String, dynamic> _$WordBookToJson(WordBook instance) => <String, dynamic>{
  'word': instance.word,
  'phonetic': instance.phonetic,
  'translation': instance.translation,
  'type': _$WordWidgetTypeEnumMap[instance.type]!,
};

const _$WordWidgetTypeEnumMap = {
  WordWidgetType.source: 'source',
  WordWidgetType.target: 'target',
};
