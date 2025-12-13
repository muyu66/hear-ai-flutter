import 'package:json_annotation/json_annotation.dart';

part 'sentence_version.g.dart';

@JsonSerializable()
class SentenceVersion {
  final String lang;
  final String updatedAt;
  final String totalCount;

  const SentenceVersion({
    required this.lang,
    required this.updatedAt,
    required this.totalCount,
  });

  factory SentenceVersion.fromJson(Map<String, dynamic> json) =>
      _$SentenceVersionFromJson(json);
  Map<String, dynamic> toJson() => _$SentenceVersionToJson(this);
}
