import 'package:json_annotation/json_annotation.dart';

part 'sign_up_res.g.dart'; // 自动生成的文件

@JsonSerializable()
class SignUpRes {
  final String accessToken;
  final bool newUser;

  SignUpRes({required this.accessToken, required this.newUser});

  factory SignUpRes.fromJson(Map<String, dynamic> json) =>
      _$SignUpResFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResToJson(this);
}
