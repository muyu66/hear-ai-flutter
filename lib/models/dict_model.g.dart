// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dict_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictModel _$DictModelFromJson(Map<String, dynamic> json) => DictModel(
  word: json['word'] as String,
  badScore: (json['badScore'] as num).toInt(),
  phonetic: json['phonetic'] as String,
  translation: json['translation'] as String,
);

Map<String, dynamic> _$DictModelToJson(DictModel instance) => <String, dynamic>{
  'word': instance.word,
  'badScore': instance.badScore,
  'phonetic': instance.phonetic,
  'translation': instance.translation,
};
