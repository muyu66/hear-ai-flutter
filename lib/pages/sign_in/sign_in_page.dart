import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/models/sign_up_req.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/tools/device_info.dart';
import 'package:hearai/tools/key_manager.dart';
import 'package:hearai/tools/secure_storage.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.headphones,
                  size: size.width * 0.28,
                  color: Colors.black87,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "每天5分钟 ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "自由自在学",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),

                // 使用私有widget
                _GuestButton(),
                const SizedBox(height: 18),
                _WeChatButton(),

                const SizedBox(height: 200),
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    "进入即代表你同意《用户协议》和《隐私政策》",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 私有游客访问按钮
class _GuestButton extends StatefulWidget {
  @override
  State<_GuestButton> createState() => _GuestButtonState();
}

class _GuestButtonState extends State<_GuestButton> {
  bool _loading = false;

  Future<void> _onSignUp() async {
    if (_loading) return;
    setState(() => _loading = true);
    HapticFeedback.lightImpact();

    try {
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
    } catch (e) {
      debugPrint('SignUp failed: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        Navigator.pushReplacementNamed(context, '/');
      }
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _loading ? null : _onSignUp,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade400, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black87,
                    ),
                  )
                : Icon(Icons.remove_red_eye, color: Colors.black87, size: 20),
            SizedBox(width: 12),
            Text(
              "浅尝一下 ~",
              style: TextStyle(fontSize: 17, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// 私有微信登录按钮
class _WeChatButton extends StatefulWidget {
  @override
  State<_WeChatButton> createState() => _WeChatButtonState();
}

class _WeChatButtonState extends State<_WeChatButton> {
  bool _loading = false;

  Future<void> _onWeChatLogin() async {
    if (_loading) return;
    setState(() => _loading = true);
    HapticFeedback.lightImpact();

    try {
      // TODO: 填写微信登录逻辑
      await Future.delayed(const Duration(seconds: 1));
      print("微信登录完成");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _loading ? null : _onWeChatLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF07C160),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.wechat, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(
              "微信登录",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
