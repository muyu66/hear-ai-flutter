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
  int sayRatio;
  int targetRetention;

  UserProfile({
    required this.nickname,
    this.avatar,
    required this.rememberMethod,
    required this.wordsLevel,
    required this.useMinute,
    required this.multiSpeaker,
    required this.isWechat,
    required this.sayRatio,
    required this.targetRetention,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
