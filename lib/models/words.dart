import 'package:hearai/pages/home/widgets/words_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'words.g.dart';

@JsonSerializable()
class WordsModel {
  final int id;
  final String words;
  final String translation;
  final WidgetType type;

  WordsModel(this.id, this.words, this.translation, this.type);

  factory WordsModel.fromJson(Map<String, dynamic> json) =>
      _$WordsModelFromJson(json);
  Map<String, dynamic> toJson() => _$WordsModelToJson(this);
}
