import 'dart:convert';

import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/models/sign_up_req.dart';
import 'package:hearai/models/sign_up_wechat_req.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/tools/device_info.dart';
import 'package:hearai/tools/key_manager.dart';
import 'package:hearai/tools/secure_storage.dart';

Future<void> authSignUp() async {
  final pair = KeyManager.generateKeyPair();
  final privateHash = KeyManager.sha256(pair.privateKey.bytes);
  final publicKeyBase64 = base64Encode(pair.publicKey.bytes);
  final privateKeyBase64 = base64Encode(pair.privateKey.bytes);
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final sig = KeyManager.sign(pair.privateKey.bytes, timestamp);
  final sigBase64 = base64Encode(sig);
  final deviceInfo = jsonEncode(await DeviceUtils.getDeviceInfo());

  final api = await AuthService().signUp(
    SignUpReq(
      account: privateHash,
      publicKeyBase64: publicKeyBase64,
      signatureBase64: sigBase64,
      timestamp: timestamp,
      deviceInfo: deviceInfo,
    ),
  );

  // 安全存储私钥
  await SecureStorageUtils.write('privateKeyBase64', privateKeyBase64);
  AuthStore().setToken(api.accessToken);
}

Future<void> authSignUpWechat(String code) async {
  final pair = KeyManager.generateKeyPair();
  final privateHash = KeyManager.sha256(pair.privateKey.bytes);
  final publicKeyBase64 = base64Encode(pair.publicKey.bytes);
  final privateKeyBase64 = base64Encode(pair.privateKey.bytes);
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final sig = KeyManager.sign(pair.privateKey.bytes, timestamp);
  final sigBase64 = base64Encode(sig);
  final deviceInfo = jsonEncode(await DeviceUtils.getDeviceInfo());

  final api = await AuthService().signUpWechat(
    SignUpWechatReq(
      account: privateHash,
      publicKeyBase64: publicKeyBase64,
      signatureBase64: sigBase64,
      timestamp: timestamp,
      code: code,
      deviceInfo: deviceInfo,
    ),
  );

  // 安全存储私钥
  await SecureStorageUtils.write('privateKeyBase64', privateKeyBase64);
  AuthStore().setToken(api.accessToken);
}
