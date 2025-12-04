import 'package:json_annotation/json_annotation.dart';

part 'dict_model.g.dart';

@JsonSerializable()
class DictModel {
  final String word;
  final int badScore;
  final String phonetic;
  final String translation;

  DictModel({
    required this.word,
    required this.badScore,
    required this.phonetic,
    required this.translation,
  });

  factory DictModel.fromJson(Map<String, dynamic> json) =>
      _$DictModelFromJson(json);
  Map<String, dynamic> toJson() => _$DictModelToJson(this);
}
