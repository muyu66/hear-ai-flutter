import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final String text;
  final Color? textColor;
  final double indicatorSize;
  final Color? indicatorColor;
  final Duration delay; // 延迟时间内不显示Loading动画

  const Loading({
    super.key,
    this.text = '加载中',
    this.textColor,
    this.indicatorSize = 24,
    this.indicatorColor,
    this.delay = const Duration(milliseconds: 300),
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _show = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _show = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    if (!_show) return const SizedBox.shrink(); // 延迟期间返回空组件

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.indicatorSize,
          height: widget.indicatorSize,
          child: CircularProgressIndicator(
            color: widget.indicatorColor ?? c.primary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 26,
            color: widget.textColor ?? c.secondary,
          ),
        ),
      ],
    );
  }
}
