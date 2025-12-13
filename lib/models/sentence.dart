import 'package:hearai/pages/home/widgets/words_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sentence.g.dart';

@JsonSerializable()
class SentenceModel {
  final String id;
  final List<String> words;
  final String wordsLang;
  final String translation;
  final WidgetType type;

  // 扩展字段
  bool reported;
  int level;

  SentenceModel({
    required this.id,
    required this.words,
    required this.wordsLang,
    required this.translation,
    required this.type,
    this.reported = false,
    this.level = 1,
  });

  factory SentenceModel.fromJson(Map<String, dynamic> json) =>
      _$SentenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);
}
