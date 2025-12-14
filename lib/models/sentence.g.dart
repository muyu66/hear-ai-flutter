// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentenceModel _$SentenceModelFromJson(Map<String, dynamic> json) =>
    SentenceModel(
      id: json['id'] as String,
      words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
      wordsLang: json['wordsLang'] as String,
      translation: json['translation'] as String,
      type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
      reported: json['reported'] as bool? ?? false,
      clickCount: (json['level'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$SentenceModelToJson(SentenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'words': instance.words,
      'wordsLang': instance.wordsLang,
      'translation': instance.translation,
      'type': _$WidgetTypeEnumMap[instance.type]!,
      'reported': instance.reported,
      'level': instance.clickCount,
    };

const _$WidgetTypeEnumMap = {
  WidgetType.listen: 'listen',
  WidgetType.say: 'say',
};
