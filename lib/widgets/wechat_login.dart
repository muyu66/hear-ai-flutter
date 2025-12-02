import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hearai/tools/haptics_manager.dart';
import 'package:wechat_kit/wechat_kit.dart';

typedef WeChatButtonBuilder =
    Widget Function(
      BuildContext context,
      bool loading,
      bool support,
      Future<void> Function() triggerLogin,
    );

class WeChatButton extends StatefulWidget {
  final Function(String code) onCode;
  final Function() onError;
  // 外部 UI 构建器
  final WeChatButtonBuilder builder;

  const WeChatButton({
    super.key,
    required this.builder,
    required this.onCode,
    required this.onError,
  });

  @override
  State<WeChatButton> createState() => _WeChatButtonState();
}

class _WeChatButtonState extends State<WeChatButton> {
  bool _loading = false;
  bool _support = true;
  late final StreamSubscription<WechatResp> _respSubs;
  final String wechatAppId = dotenv.env['WECHAT_APPID'] ?? '';

  @override
  void initState() {
    super.initState();
    _checkSupport();
    _respSubs = WechatKitPlatform.instance.respStream().listen(_listenResp);
  }

  @override
  void dispose() {
    super.dispose();
    _respSubs.cancel();
  }

  void _listenResp(WechatResp resp) {
    if (resp is WechatAuthResp) {
      if (resp.errorCode != 0) {
        debugPrint("微信登录失败：${resp.errorCode} ${resp.errorMsg}");
        widget.onError();
        return;
      }
      final String code = resp.code ?? "";
      if (code.isEmpty) {
        debugPrint("微信登录失败：${resp.errorCode} ${resp.errorMsg}");
        widget.onError();
        return;
      }
      widget.onCode(code);
    }
  }

  Future<void> _checkSupport() async {
    await WechatKitPlatform.instance.registerApp(
      appId: wechatAppId,
      universalLink: "",
    );

    bool support =
        await WechatKitPlatform.instance.isInstalled() &&
        await WechatKitPlatform.instance.isSupportApi();

    if (mounted) {
      setState(() {
        _support = support;
      });
    }
  }

  Future<void> _triggerLogin() async {
    if (_loading) return;

    setState(() => _loading = true);
    HapticsManager.light();

    try {
      await WechatKitPlatform.instance.auth(
        scope: <String>[WechatScope.kSNSApiUserInfo],
        state: 'zhuzhu123456',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _loading, _support, _triggerLogin);
  }
}
