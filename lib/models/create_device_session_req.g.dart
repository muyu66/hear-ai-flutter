// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_device_session_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDeviceSessionReq _$CreateDeviceSessionReqFromJson(
  Map<String, dynamic> json,
) => CreateDeviceSessionReq(
  deviceSessionId: json['deviceSessionId'] as String,
  account: json['account'] as String,
  signatureBase64: json['signatureBase64'] as String,
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$CreateDeviceSessionReqToJson(
  CreateDeviceSessionReq instance,
) => <String, dynamic>{
  'deviceSessionId': instance.deviceSessionId,
  'account': instance.account,
  'signatureBase64': instance.signatureBase64,
  'timestamp': instance.timestamp,
};
