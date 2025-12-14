import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/services/my_word_service.dart';
import 'package:hearai/services/splash_service.dart';
import 'package:hearai/services/system_service.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/auth.dart';
import 'package:hearai/tools/memory_cache.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashService splashService = SplashService();

  List<String> verticalTexts = []; // 两列字符串
  late final List<List<String>> _chars; // 每列字符数组，初始化后不变

  // 预载数据用的 Service
  final MyWordService myWordService = MyWordService();
  final AuthService authService = AuthService();
  final SystemService systemService = SystemService();

  @override
  void initState() {
    super.initState();
    // 沉浸式处理：隐藏顶部状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _chars = [];
    _loadSplashTexts();
  }

  /// 预载后端数据
  Future<void> _preloadData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    MemoryCache().savePackageInfoVersion(packageInfo.version);

    final systemInfo = await systemService.getSystemInfo();
    MemoryCache().saveSystemInfo(systemInfo);

    final summary = await myWordService.getSummary();
    MemoryCache().saveWordBookSummary(summary);

    final userProfile = await authService.getProfile();
    MemoryCache().saveUserProfile(userProfile);

    final wordBookList = await myWordService.getWords(offset: 0);
    MemoryCache().saveWordBookList(wordBookList);
  }

  Future<void> _loadSplashTexts() async {
    // 记录当前时间
    int startTime = DateTime.now().millisecondsSinceEpoch;

    // 获取数据（网络）
    List<String> wordsList;
    try {
      wordsList = await splashService.getRandomWords();
    } catch (_) {
      // 兜底
      wordsList = ['初心如磐', '笃行不怠'];
    }

    // 保证两列：如果服务只返回一列或多余逻辑可在这里处理
    if (wordsList.length < 2) {
      // 若只返回1列，把默认作第二列空字符串
      wordsList = [wordsList.isNotEmpty ? wordsList[0] : '', ''];
    }

    // 拆分成字符数组（只做一次）
    final chars = wordsList.map((s) => s.split('')).toList();

    // 更新 state（仅一次）
    setState(() {
      verticalTexts = wordsList;
      _chars
        ..clear()
        ..addAll(chars);
    });

    // 预加载数据
    await _preloadData();

    // 预加载数据耗时超过n秒，则不等待，如果不足则强制等待n秒
    int now = DateTime.now().millisecondsSinceEpoch;
    int waitTime = 1200;
    Future.delayed(
      Duration(
        milliseconds: now - startTime > waitTime
            ? 0
            : startTime + waitTime - now,
      ),
      // 自动跳转
      () {
        authSignIn().then((needRedirect) {
          if (!mounted) return;
          // 有登录状态还是没有登录状态
          Navigator.pushReplacementNamed(
            context,
            needRedirect ? '/sign-in' : '/home',
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: c.surface,
      body: Center(
        child: verticalTexts.isEmpty ? const SizedBox() : _buildVerticalTexts(),
      ),
    );
  }

  /// 竖排文字布局：从右往左排列（注意 rendering order）
  Widget _buildVerticalTexts() {
    // 我们 render children left-to-right, but we want right column visually on the right.
    // So we reverse the list when building children to keep data order stable.
    final columns = List<Widget>.generate(_chars.length, (colIndex) {
      // 你希望右列高一点（上移），左列低一点
      final offsetY = colIndex == 0 ? -30.0 : -10.0;
      // Use RepaintBoundary to limit repaint area
      return RepaintBoundary(
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: _buildVerticalText(colIndex),
        ),
      );
    });

    // reverse to display rightmost column last => appear on right
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.reversed.toList(),
    );
  }

  /// 构建单列竖排（使用 _chars 和 _charAnimations）
  Widget _buildVerticalText(int colIndex) {
    final t = Theme.of(context).textTheme;
    final colChars = _chars[colIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(colChars.length, (rowIndex) {
        // Animation value in [0,1] provided by Interval curve
        // Use FadeTransition -> uses animation to build an Opacity widget efficiently
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
          child: Text(
            colChars[rowIndex],
            style: t.splashText,
            textAlign: TextAlign.center,
          ),
        );
      }),
    );
  }
}
