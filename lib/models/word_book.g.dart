// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBook _$WordBookFromJson(Map<String, dynamic> json) => WordBook(
  word: json['word'] as String,
  voice: json['voice'] as String,
  phonetic: json['phonetic'] as String?,
);

Map<String, dynamic> _$WordBookToJson(WordBook instance) => <String, dynamic>{
  'word': instance.word,
  'voice': instance.voice,
  'phonetic': instance.phonetic,
};
