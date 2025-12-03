import 'dart:math';

import 'package:flutter/material.dart';

class WaterProgress extends StatefulWidget {
  final double percent; // 0~100
  final Size size;

  const WaterProgress({super.key, required this.percent, required this.size});

  @override
  State<WaterProgress> createState() => _WaterProgressState();
}

class _WaterProgressState extends State<WaterProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: widget.size, // 容器大小
          painter: _WaterPainter(
            wavePhase: _controller.value * 2 * pi,
            percent: widget.percent / 100,
          ),
        );
      },
    );
  }
}

class _WaterPainter extends CustomPainter {
  final double wavePhase;
  final double percent;

  _WaterPainter({required this.wavePhase, required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint waterPaint = Paint()..color = Colors.orange.withOpacity(0.6);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2; // 留边

    canvas.drawCircle(center, radius, borderPaint);

    if (percent >= 1.0) {
      // 100% 直接填满圆形
      canvas.drawCircle(center, radius, waterPaint);
    } else {
      // 波纹路径
      final waterHeight = size.height * (1 - percent);
      final Path path = Path();
      const waveCount = 2;
      final double waveWidth = size.width / waveCount;

      path.moveTo(0, size.height);
      for (double x = 0; x <= size.width; x++) {
        final y = sin((2 * pi / waveWidth) * x + wavePhase) * 10 + waterHeight;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();

      canvas.save();
      canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      );
      canvas.drawPath(path, waterPaint);
      canvas.restore();
    }

    // 百分比文字
    final number = (percent * 100).round();

    // 先画数字
    final numberSpan = TextSpan(
      text: '$number',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF4A2600),
        shadows: [
          Shadow(
            color: const Color(0xFF4A2600).withAlpha(120),
            offset: const Offset(1.2, 1.2),
          ),
        ],
      ),
    );

    final numberPainter = TextPainter(
      text: numberSpan,
      textDirection: TextDirection.ltr,
    );
    numberPainter.layout();

    // 然后画 %，稍微往右
    final percentSpan = TextSpan(
      text: '%',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF4A2600),
      ),
    );

    final percentPainter = TextPainter(
      text: percentSpan,
      textDirection: TextDirection.ltr,
    );
    percentPainter.layout();

    // 数字偏移
    final numberOffset = Offset(
      center.dx - (numberPainter.width + percentPainter.width * 0.5) / 2,
      center.dy - numberPainter.height / 2,
    );
    numberPainter.paint(canvas, numberOffset);

    // % 偏移
    final percentOffset = Offset(
      numberOffset.dx + numberPainter.width + 2, // +2 像素微调
      center.dy - percentPainter.height / 2 + 4, // 微调垂直位置
    );
    percentPainter.paint(canvas, percentOffset);
  }

  @override
  bool shouldRepaint(covariant _WaterPainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase || oldDelegate.percent != percent;
  }
}
