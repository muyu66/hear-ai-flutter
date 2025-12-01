import 'package:json_annotation/json_annotation.dart';

part 'user_profile_update.g.dart';

@JsonSerializable()
class UserProfileUpdate {
  final String? nickname;
  final String? rememberMethod;
  final int? wordsLevel;
  final int? useMinute;
  final bool? multiSpeaker;

  UserProfileUpdate({
    this.nickname,
    this.rememberMethod,
    this.wordsLevel,
    this.useMinute,
    this.multiSpeaker,
  });

  factory UserProfileUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserProfileUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileUpdateToJson(this);
}
