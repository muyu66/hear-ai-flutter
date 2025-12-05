// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordsModel _$WordsModelFromJson(Map<String, dynamic> json) => WordsModel(
  id: (json['id'] as num).toInt(),
  words: json['words'] as String,
  translation: json['translation'] as String,
  type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
  reported: json['reported'] as bool? ?? false,
  level: (json['level'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$WordsModelToJson(WordsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'words': instance.words,
      'translation': instance.translation,
      'type': _$WidgetTypeEnumMap[instance.type]!,
      'reported': instance.reported,
      'level': instance.level,
    };

const _$WidgetTypeEnumMap = {
  WidgetType.listen: 'listen',
  WidgetType.say: 'say',
};
