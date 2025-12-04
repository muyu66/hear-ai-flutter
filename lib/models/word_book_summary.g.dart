// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBookSummary _$WordBookSummaryFromJson(Map<String, dynamic> json) =>
    WordBookSummary(
      totalCount: (json['totalCount'] as num).toInt(),
      currStability: (json['currStability'] as num?)?.toInt(),
      tomorrowCount: (json['tomorrowCount'] as num).toInt(),
      nowCount: (json['nowCount'] as num).toInt(),
      todayDoneCount: (json['todayDoneCount'] as num).toInt(),
      memoryCurve: (json['memoryCurve'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$WordBookSummaryToJson(WordBookSummary instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'currStability': instance.currStability,
      'tomorrowCount': instance.tomorrowCount,
      'nowCount': instance.nowCount,
      'todayDoneCount': instance.todayDoneCount,
      'memoryCurve': instance.memoryCurve,
    };
