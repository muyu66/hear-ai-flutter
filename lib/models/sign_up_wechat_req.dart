import 'package:json_annotation/json_annotation.dart';

part 'sign_up_wechat_req.g.dart'; // 自动生成的文件

@JsonSerializable()
class SignUpWechatReq {
  final String code;
  final String account;
  final String publicKeyBase64;
  final String signatureBase64;
  final String timestamp; // 通常传字符串形式的时间戳
  final String? deviceInfo;

  SignUpWechatReq({
    required this.code,
    required this.account,
    required this.publicKeyBase64,
    required this.signatureBase64,
    required this.timestamp,
    this.deviceInfo,
  });

  factory SignUpWechatReq.fromJson(Map<String, dynamic> json) =>
      _$SignUpWechatReqFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpWechatReqToJson(this);
}
