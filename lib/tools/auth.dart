import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/models/create_device_session_req.dart';
import 'package:hearai/models/sign_in_req.dart';
import 'package:hearai/models/sign_up_req.dart';
import 'package:hearai/models/sign_up_wechat_req.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/tools/device_info.dart';
import 'package:hearai/tools/key_manager.dart';
import 'package:hearai/tools/secure_storage.dart';

Future<bool> authSignUp() async {
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
  return api.newUser;
}

Future<bool> authSignUpWechat(String code) async {
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
  return api.newUser;
}

/// 是否需要重定向
Future<bool> authSignIn() async {
  try {
    debugPrint('进入 authSignIn');
    // 如果没有私钥，需要强制返回登录页
    final existPrivateKey = await SecureStorageUtils.has('privateKeyBase64');
    if (!existPrivateKey) {
      debugPrint('没有私钥');
      return true;
    }

    // 如果已经登录，则无视
    if (AuthStore().isLoggedIn) {
      debugPrint('有token');
      return false;
    }

    debugPrint('没有token');

    // 用私钥刷新accessToken
    final privateKeyBase64 = await SecureStorageUtils.read('privateKeyBase64');
    if (privateKeyBase64 == null) {
      debugPrint('No private key found');
      return true;
    }
    final privateKey = base64Decode(privateKeyBase64);
    final privateHash = KeyManager.sha256(privateKey);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final sig = KeyManager.sign(privateKey, timestamp);
    final sigBase64 = base64Encode(sig);
    final deviceInfo = jsonEncode(await DeviceUtils.getDeviceInfo());

    final api = await AuthService().signIn(
      SignInReq(
        account: privateHash,
        signatureBase64: sigBase64,
        timestamp: timestamp,
        deviceInfo: deviceInfo,
      ),
    );

    AuthStore().setToken(api.accessToken);
    return false;
  } catch (e) {
    debugPrint('登录失败: $e');
    return true;
  }
}

Future<void> authCreateDeviceSession(String deviceSessionId) async {
  try {
    final existPrivateKey = await SecureStorageUtils.has('privateKeyBase64');
    if (!existPrivateKey) {
      return;
    }

    // 如果没有登录，则无视
    if (!AuthStore().isLoggedIn) {
      return;
    }

    final privateKeyBase64 = await SecureStorageUtils.read('privateKeyBase64');
    if (privateKeyBase64 == null) {
      return;
    }
    final privateKey = base64Decode(privateKeyBase64);
    final privateHash = KeyManager.sha256(privateKey);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final sig = KeyManager.sign(privateKey, timestamp);
    final sigBase64 = base64Encode(sig);

    await AuthService().createDeviceSession(
      CreateDeviceSessionReq(
        deviceSessionId: deviceSessionId,
        account: privateHash,
        signatureBase64: sigBase64,
        timestamp: timestamp,
      ),
    );
  } catch (e) {
    debugPrint('登录失败: $e');
    return;
  }
}
