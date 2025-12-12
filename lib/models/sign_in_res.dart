import 'package:json_annotation/json_annotation.dart';

part 'sign_in_res.g.dart'; // 自动生成的文件

@JsonSerializable()
class SignInRes {
  final String accessToken;

  SignInRes({required this.accessToken});

  factory SignInRes.fromJson(Map<String, dynamic> json) =>
      _$SignInResFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResToJson(this);
}
