import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double indicatorSize;
  final Color? indicatorColor;

  const Loading({
    super.key,
    this.text = '加载中',
    this.textColor,
    this.indicatorSize = 24,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(color: indicatorColor ?? c.primary),
        ),
        const SizedBox(height: 32),
        Text(
          text,
          style: TextStyle(fontSize: 26, color: textColor ?? c.secondary),
        ),
      ],
    );
  }
}
