// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInReq _$SignInReqFromJson(Map<String, dynamic> json) => SignInReq(
  account: json['account'] as String,
  signatureBase64: json['signatureBase64'] as String,
  timestamp: json['timestamp'] as String,
  deviceInfo: json['deviceInfo'] as String?,
);

Map<String, dynamic> _$SignInReqToJson(SignInReq instance) => <String, dynamic>{
  'account': instance.account,
  'signatureBase64': instance.signatureBase64,
  'timestamp': instance.timestamp,
  'deviceInfo': instance.deviceInfo,
};
