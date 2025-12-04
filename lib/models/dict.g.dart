// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dict _$DictFromJson(Map<String, dynamic> json) => Dict(
  dict: json['dict'] as String,
  dictName: json['dictName'] as String,
  model: DictModel.fromJson(json['model'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DictToJson(Dict instance) => <String, dynamic>{
  'dict': instance.dict,
  'dictName': instance.dictName,
  'model': instance.model,
};
