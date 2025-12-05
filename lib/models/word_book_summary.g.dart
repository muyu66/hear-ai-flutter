// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBookSummary _$WordBookSummaryFromJson(Map<String, dynamic> json) =>
    WordBookSummary(
      totalCount: (json['totalCount'] as num).toInt(),
      tomorrowCount: (json['tomorrowCount'] as num).toInt(),
      nowCount: (json['nowCount'] as num).toInt(),
      todayDoneCount: (json['todayDoneCount'] as num).toInt(),
      stability: (json['stability'] as num?)?.toInt(),
      retention: (json['retention'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$WordBookSummaryToJson(WordBookSummary instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'tomorrowCount': instance.tomorrowCount,
      'nowCount': instance.nowCount,
      'todayDoneCount': instance.todayDoneCount,
      'stability': instance.stability,
      'retention': instance.retention,
    };
