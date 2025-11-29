// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBookSummary _$WordBookSummaryFromJson(Map<String, dynamic> json) =>
    WordBookSummary(
      (json['totalCount'] as num).toInt(),
      (json['todayCount'] as num).toInt(),
      (json['tomorrowCount'] as num).toInt(),
    );

Map<String, dynamic> _$WordBookSummaryToJson(WordBookSummary instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'todayCount': instance.todayCount,
      'tomorrowCount': instance.tomorrowCount,
    };
