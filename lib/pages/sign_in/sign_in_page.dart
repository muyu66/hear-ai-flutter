import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/tools/auth.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/widgets/wechat_login.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    showNotify(context: context, title: l.todo);
                  },
                  child: Opacity(
                    opacity: 0.6,
                    child: Text(
                      "进入即代表你同意《用户协议》和《隐私政策》",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
      print(66666666666666);
      await authSignUp();
    } catch (e) {
      debugPrint('SignUp failed: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _loading
            ? null
            : () {
                HapticFeedback.lightImpact();
                showConfirm(
                  context: context,
                  title: l.confirmSignUpGuest,
                  dialogType: DialogType.warning,
                  onConfirm: () {
                    HapticFeedback.lightImpact();
                    _onSignUp();
                  },
                );
              },
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
  void _wechatSignInCallback(String code) {
    authSignUpWechat(code)
        .then((_) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        })
        .catchError((e) {
          debugPrint('SignUp failed: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    return WeChatButton(
      onCode: (code) {
        _wechatSignInCallback(code);
      },
      onError: () {
        showClassicNotify(
          context: context,
          title: "登录失败",
          dialogType: DialogType.error,
        );
      },
      builder: (context, loading, support, triggerLogin) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (!support || loading) ? null : triggerLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF07C160),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wechat, color: Colors.white, size: 20),
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
      },
    );
  }
}
