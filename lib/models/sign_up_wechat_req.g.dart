// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_wechat_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpWechatReq _$SignUpWechatReqFromJson(Map<String, dynamic> json) =>
    SignUpWechatReq(
      code: json['code'] as String,
      account: json['account'] as String,
      publicKeyBase64: json['publicKeyBase64'] as String,
      signatureBase64: json['signatureBase64'] as String,
      timestamp: json['timestamp'] as String,
      deviceInfo: json['deviceInfo'] as String?,
    );

Map<String, dynamic> _$SignUpWechatReqToJson(SignUpWechatReq instance) =>
    <String, dynamic>{
      'code': instance.code,
      'account': instance.account,
      'publicKeyBase64': instance.publicKeyBase64,
      'signatureBase64': instance.signatureBase64,
      'timestamp': instance.timestamp,
      'deviceInfo': instance.deviceInfo,
    };
