import 'package:json_annotation/json_annotation.dart';

part 'result_int.g.dart';

@JsonSerializable()
class ResultInt {
  final int result;

  ResultInt(this.result);

  factory ResultInt.fromJson(Map<String, dynamic> json) =>
      _$ResultIntFromJson(json);
  Map<String, dynamic> toJson() => _$ResultIntToJson(this);
}
