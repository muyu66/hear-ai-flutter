import 'package:flutter/material.dart';
import 'package:hearai/models/word_book_summary.dart';
import 'package:hearai/pages/word_book/widgets/water_progress.dart';

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
      height: 200,
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
                        child: StatItem(
                          label: "记忆评级",
                          value: summary.currStability != null ? 'S+' : '-',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatItem(
                          label: "总单词数",
                          value: summary.totalCount.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StatItem(
                          label: "待复习",
                          value: summary.nowCount.toString(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatItem(
                          label: "明天复习",
                          value: summary.tomorrowCount.toString(),
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

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    // 判断 value 是否为数字且大于 999
    String displayValue = value;
    final numValue = int.tryParse(value);
    if (numValue != null && numValue > 999) {
      displayValue = '999+';
    }

    return Container(
      width: 80,
      height: 74,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: c.shadow, blurRadius: 2, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: c.onPrimaryContainer,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
