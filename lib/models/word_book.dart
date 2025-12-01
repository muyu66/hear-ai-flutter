import 'package:json_annotation/json_annotation.dart';

part 'word_book.g.dart';

@JsonSerializable()
class WordBook {
  final String word;
  final String voice;
  final String? phonetic;

  WordBook({required this.word, required this.voice, required this.phonetic});

  factory WordBook.fromJson(Map<String, dynamic> json) =>
      _$WordBookFromJson(json);
  Map<String, dynamic> toJson() => _$WordBookToJson(this);
}
