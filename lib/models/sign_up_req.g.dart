// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpReq _$SignUpReqFromJson(Map<String, dynamic> json) => SignUpReq(
  account: json['account'] as String,
  publicKeyBase64: json['publicKeyBase64'] as String,
  signatureBase64: json['signatureBase64'] as String,
  timestamp: json['timestamp'] as String,
  deviceInfo: json['deviceInfo'] as String?,
);

Map<String, dynamic> _$SignUpReqToJson(SignUpReq instance) => <String, dynamic>{
  'account': instance.account,
  'publicKeyBase64': instance.publicKeyBase64,
  'signatureBase64': instance.signatureBase64,
  'timestamp': instance.timestamp,
  'deviceInfo': instance.deviceInfo,
};
