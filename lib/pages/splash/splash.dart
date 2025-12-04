import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/services/splash_service.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/auth.dart';

class SplashPage extends StatefulWidget {
  final bool enableAnimation; // 新增参数
  const SplashPage({super.key, this.enableAnimation = true});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final SplashService splashService = SplashService();

  List<String> verticalTexts = []; // 两列字符串
  late final List<List<String>> _chars; // 每列字符数组，初始化后不变
  AnimationController? _controller;
  late List<List<Animation<double>>> _charAnimations; // 每个字符对应的动画

  // 配置：每个字符起始间隔（毫秒）与单字淡入时长（毫秒）
  static const int perCharDelayMs = 80;
  static const int fadeMs = 360;

  @override
  void initState() {
    super.initState();
    // 沉浸式处理：隐藏顶部状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _chars = [];
    _charAnimations = [];
    _loadSplashTexts();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadSplashTexts() async {
    // 1. 获取数据（网络）
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

    // 2. 拆分成字符数组（只做一次）
    final chars = wordsList.map((s) => s.split('')).toList();

    // 3. 初始化动画控制器与各字符动画
    _initAnimations(chars);

    // 4. 更新 state（仅一次）
    setState(() {
      verticalTexts = wordsList;
      _chars
        ..clear()
        ..addAll(chars);
    });

    // 5. 启动动画
    _controller?.forward();

    // 6. 自动跳转（动画后或固定时长）
    final totalDuration =
        _controller?.duration ??
        Duration(milliseconds: widget.enableAnimation ? 2000 : 1500);
    Future.delayed(
      totalDuration + Duration(milliseconds: widget.enableAnimation ? 800 : 0),
      () {
        authSignIn().then((needRedirect) {
          if (!mounted) return;
          // 有登录状态还是没有登录状态
          Navigator.pushReplacementNamed(
            context,
            needRedirect ? '/sign_in' : '/home',
          );
        });
      },
    );
  }

  void _initAnimations(List<List<String>> chars) {
    if (!widget.enableAnimation) {
      // 不需要动画
      _charAnimations = chars
          .map((col) => col.map((e) => AlwaysStoppedAnimation(1.0)).toList())
          .toList();
      return;
    }

    // 计算总字符数与总动画时长：最后一个字符的 start + fadeMs 为总时长
    final totalChars = chars.fold<int>(0, (sum, col) => sum + col.length);
    final lastStartMs = (totalChars - 1) * perCharDelayMs;
    final totalMs = lastStartMs + fadeMs;

    // 创建 controller
    _controller?.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    // 为每个字符构造一个基于 Interval 的动画
    _charAnimations = [];
    int globalIndex = 0; // 确保从右到左或其他遍历顺序可映射全局 index

    // IMPORTANT: 我们要保证动画按“从右列顶部到左列底部”的顺序触发
    // 你要求右列先出现，所以我们将遍历顺序设为：右列从上到下，然后左列从上到下。
    // chars 传入顺序是 [col0, col1] (你原始顺序)。我们将 globalIndex 以右列为先：
    final colCount = chars.length;
    for (int ci = 0; ci < colCount; ci++) {
      // 占位，后面我们会根据 reversed children 渲染顺序保持右在右边
      _charAnimations.add([]);
    }

    // We want order: col0 (right column) then col1 (left column).
    // Assuming chars[0] = right column text, chars[1] = left column text (as in your usage).
    for (int colIndex = 0; colIndex < chars.length; colIndex++) {
      final col = chars[colIndex];
      for (int rowIndex = 0; rowIndex < col.length; rowIndex++) {
        final startMs = globalIndex * perCharDelayMs;
        final endMs = startMs + fadeMs;
        final start = startMs / totalMs;
        final end = endMs / totalMs;
        final anim = _controller!.drive(
          CurveTween(
            curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeIn),
          ),
        );
        _charAnimations[colIndex].add(anim);
        globalIndex++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: c.surface,
      body: Center(
        child: verticalTexts.isEmpty
            ? const SizedBox()
            : AnimatedBuilder(
                animation: _controller ?? AlwaysStoppedAnimation(1.0),
                builder: (context, _) => _buildVerticalTexts(),
              ),
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
    final colAnims = _charAnimations[colIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(colChars.length, (rowIndex) {
        // Animation value in [0,1] provided by Interval curve
        final anim = colAnims[rowIndex];
        // Use FadeTransition -> uses animation to build an Opacity widget efficiently
        return FadeTransition(
          opacity: anim,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            child: Text(
              colChars[rowIndex],
              style: t.splashText,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }
}
