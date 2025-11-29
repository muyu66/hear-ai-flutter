import 'package:json_annotation/json_annotation.dart';

part 'words.g.dart';

@JsonSerializable()
class WordsModel {
  final int id;
  final String words;
  final String translation;

  WordsModel(this.id, this.words, this.translation);

  factory WordsModel.fromJson(Map<String, dynamic> json) =>
      _$WordsModelFromJson(json);
  Map<String, dynamic> toJson() => _$WordsModelToJson(this);
}
