// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBook _$WordBookFromJson(Map<String, dynamic> json) => WordBook(
  json['word'] as String,
  json['voice'] as String,
  json['phonetic'] as String?,
);

Map<String, dynamic> _$WordBookToJson(WordBook instance) => <String, dynamic>{
  'word': instance.word,
  'voice': instance.voice,
  'phonetic': instance.phonetic,
};
