import 'package:json_annotation/json_annotation.dart';

part 'result_bool.g.dart';

@JsonSerializable()
class ResultBool {
  final bool result;

  ResultBool(this.result);

  factory ResultBool.fromJson(Map<String, dynamic> json) =>
      _$ResultBoolFromJson(json);
  Map<String, dynamic> toJson() => _$ResultBoolToJson(this);
}
