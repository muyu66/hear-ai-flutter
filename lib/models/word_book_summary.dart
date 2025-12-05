import 'package:json_annotation/json_annotation.dart';

part 'word_book_summary.g.dart';

@JsonSerializable()
class WordBookSummary {
  final int totalCount;
  final int tomorrowCount;
  final int nowCount;
  final int todayDoneCount;
  final int? stability;
  final List<double>? retention;

  WordBookSummary({
    required this.totalCount,
    required this.tomorrowCount,
    required this.nowCount,
    required this.todayDoneCount,
    this.stability,
    this.retention,
  });

  factory WordBookSummary.fromJson(Map<String, dynamic> json) =>
      _$WordBookSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$WordBookSummaryToJson(this);
}
