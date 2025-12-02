import 'package:json_annotation/json_annotation.dart';

part 'word_book_summary.g.dart';

@JsonSerializable()
class WordBookSummary {
  final int totalCount;
  final int todayCount;
  final int tomorrowCount;
  final int nowCount;

  WordBookSummary({
    required this.totalCount,
    required this.todayCount,
    required this.tomorrowCount,
    required this.nowCount,
  });

  factory WordBookSummary.fromJson(Map<String, dynamic> json) =>
      _$WordBookSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$WordBookSummaryToJson(this);
}
