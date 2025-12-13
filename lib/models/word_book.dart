import 'package:json_annotation/json_annotation.dart';

part 'word_book.g.dart';

enum WordWidgetType { source, target }

@JsonSerializable()
class WordBook {
  final String word;
  final String lang;
  final List<String> phonetic;
  final String translation;
  final WordWidgetType type;

  const WordBook({
    required this.word,
    required this.lang,
    required this.phonetic,
    required this.translation,
    required this.type,
  });

  factory WordBook.fromJson(Map<String, dynamic> json) =>
      _$WordBookFromJson(json);
  Map<String, dynamic> toJson() => _$WordBookToJson(this);
}
