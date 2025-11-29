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

  UserProfile(
    this.nickname,
    this.avatar,
    this.rememberMethod,
    this.wordsLevel,
    this.useMinute,
    this.multiSpeaker,
  );

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
