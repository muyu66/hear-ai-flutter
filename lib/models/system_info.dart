import 'package:json_annotation/json_annotation.dart';

part 'system_info.g.dart';

@JsonSerializable()
class SystemInfo {
  final String androidAppVersion;

  SystemInfo({required this.androidAppVersion});

  factory SystemInfo.fromJson(Map<String, dynamic> json) =>
      _$SystemInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SystemInfoToJson(this);
}
