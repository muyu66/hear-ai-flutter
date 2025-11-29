import 'package:json_annotation/json_annotation.dart';

part 'sign_in_req.g.dart'; // 自动生成的文件

@JsonSerializable()
class SignInReq {
  final String account;
  final String signatureBase64;
  final String timestamp; // 通常传字符串形式的时间戳

  SignInReq({
    required this.account,
    required this.signatureBase64,
    required this.timestamp,
  });

  factory SignInReq.fromJson(Map<String, dynamic> json) =>
      _$SignInReqFromJson(json);

  Map<String, dynamic> toJson() => _$SignInReqToJson(this);
}
