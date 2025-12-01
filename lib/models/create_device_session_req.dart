import 'package:json_annotation/json_annotation.dart';

part 'create_device_session_req.g.dart'; // 自动生成的文件

@JsonSerializable()
class CreateDeviceSessionReq {
  final String deviceSessionId;
  final String account;
  final String signatureBase64;
  final String timestamp; // 通常传字符串形式的时间戳

  CreateDeviceSessionReq({
    required this.deviceSessionId,
    required this.account,
    required this.signatureBase64,
    required this.timestamp,
  });

  factory CreateDeviceSessionReq.fromJson(Map<String, dynamic> json) =>
      _$CreateDeviceSessionReqFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDeviceSessionReqToJson(this);
}
