import 'package:flutter/material.dart';
import 'package:hearai/models/word_book_summary.dart';
import 'package:hearai/pages/word_book/widgets/water_progress.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';

class Stats extends StatelessWidget {
  final WordBookSummary summary;

  const Stats({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    double progress = summary.nowCount + summary.todayDoneCount <= 0
        ? 1
        : summary.todayDoneCount / (summary.nowCount + summary.todayDoneCount);

    return Container(
      height: 184,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c.primaryContainer, c.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: c.outline, offset: Offset(0, 6), blurRadius: 6),
          ],
          border: Border.all(color: c.inversePrimary, width: 1),
        ),
        child: Row(
          children: [
            // 左侧水波纹圆形
            WaterProgress(percent: progress * 100, size: const Size(120, 120)),
            const SizedBox(width: 20),

            // 右侧统计卡片列表
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StatCurveItem(
                          label: "记忆曲线",
                          value: summary.memoryCurve ?? [],
                          onTap: summary.currStability != null
                              ? null
                              : () {
                                  HapticsManager.light();
                                  showNotify(
                                    context: context,
                                    title: "需要开启 ARSS 记忆模型",
                                  );
                                },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatItem<int>(
                          label: "总单词数",
                          value: summary.totalCount,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StatItem<int>(
                          label: "待复习",
                          value: summary.nowCount,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatItem<int>(
                          label: "明天复习",
                          value: summary.tomorrowCount,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem<T> extends StatelessWidget {
  final String label;
  final T value;
  final VoidCallback? onTap;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  String formatValue(T value) {
    if (value is String) {
      return value;
    } else if (value is int) {
      if (value >= 99950) {
        return '99K+';
      } else if (value >= 10000) {
        double val = value / 1000;
        return '${val.toStringAsFixed(1)}K';
      } else if (value >= 1000) {
        double val = value / 1000;
        return '${val.toStringAsFixed(1)}K';
      } else {
        return value.toString();
      }
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: c.shadow,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatValue(value),
              style: t.titleSmall!.copyWith(color: c.onPrimaryContainer),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: t.labelSmall!.copyWith(color: c.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class StatCurveItem extends StatelessWidget {
  final String label;
  final List<double> value;
  final VoidCallback? onTap;

  const StatCurveItem({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: c.shadow,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            value.isNotEmpty
                ? ForgettingCurveWidget(values: value)
                : Text(
                    "-",
                    style: t.titleSmall!.copyWith(color: c.onPrimaryContainer),
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: t.labelSmall!.copyWith(color: c.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final List<double> values; // 遗忘曲线的 y 值 (0~1)

  CurvePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFF7A00)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (values.isEmpty) return;

    // 起点
    path.moveTo(0, size.height * (1 - values[0]));

    for (int i = 1; i < values.length; i++) {
      final dx = i * (size.width / (values.length - 1));
      final dy = size.height * (1 - values[i]);
      path.lineTo(dx, dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ForgettingCurveWidget extends StatelessWidget {
  final List<double> values;
  const ForgettingCurveWidget({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomPaint(painter: CurvePainter(values), child: Container()),
    );
  }
}
