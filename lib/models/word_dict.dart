import 'package:json_annotation/json_annotation.dart';

part 'word_dict.g.dart';

@JsonSerializable()
class WordDict {
  final String word;
  final String phonetic;
  final String translation;

  WordDict({
    required this.word,
    required this.phonetic,
    required this.translation,
  });

  factory WordDict.fromJson(Map<String, dynamic> json) =>
      _$WordDictFromJson(json);
  Map<String, dynamic> toJson() => _$WordDictToJson(this);
}
