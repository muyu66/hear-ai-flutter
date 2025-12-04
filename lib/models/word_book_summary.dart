import 'package:json_annotation/json_annotation.dart';

part 'word_book_summary.g.dart';

@JsonSerializable()
class WordBookSummary {
  final int totalCount;
  final int? currStability;
  final int tomorrowCount;
  final int nowCount;
  final int todayDoneCount;
  final List<double>? memoryCurve;

  WordBookSummary({
    required this.totalCount,
    this.currStability,
    required this.tomorrowCount,
    required this.nowCount,
    required this.todayDoneCount,
    this.memoryCurve,
  });

  factory WordBookSummary.fromJson(Map<String, dynamic> json) =>
      _$WordBookSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$WordBookSummaryToJson(this);
}
