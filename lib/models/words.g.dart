// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordsModel _$WordsModelFromJson(Map<String, dynamic> json) => WordsModel(
  (json['id'] as num).toInt(),
  json['words'] as String,
  json['translation'] as String,
  $enumDecode(_$WidgetTypeEnumMap, json['type']),
);

Map<String, dynamic> _$WordsModelToJson(WordsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'words': instance.words,
      'translation': instance.translation,
      'type': _$WidgetTypeEnumMap[instance.type]!,
    };

const _$WidgetTypeEnumMap = {
  WidgetType.listen: 'listen',
  WidgetType.say: 'say',
};
