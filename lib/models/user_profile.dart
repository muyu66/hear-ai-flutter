import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  String nickname;
  String? avatar;
  String rememberMethod;
  int wordsLevel;
  int useMinute;
  bool multiSpeaker;
  bool isWechat;

  UserProfile({
    required this.nickname,
    this.avatar,
    required this.rememberMethod,
    required this.wordsLevel,
    required this.useMinute,
    required this.multiSpeaker,
    required this.isWechat,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
