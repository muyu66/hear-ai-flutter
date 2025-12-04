import 'package:hearai/models/dict_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dict.g.dart';

@JsonSerializable()
class Dict {
  final String dict;
  final String dictName;
  final DictModel model;

  Dict({required this.dict, required this.dictName, required this.model});

  factory Dict.fromJson(Map<String, dynamic> json) => _$DictFromJson(json);
  Map<String, dynamic> toJson() => _$DictToJson(this);
}
