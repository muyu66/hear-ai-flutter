import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:hearai/widgets/dict.dart';

class SliceWords extends StatelessWidget {
  final String words;
  final int hiddenPercent; // 0-100

  const SliceWords({super.key, required this.words, this.hiddenPercent = 0});

  List<int> _calcHiddenIndices(List<String> wordList, int hiddenPercent) {
    final total = wordList.length;
    final indices = List.generate(total, (i) => i);

    if (hiddenPercent <= 0) return []; // 0% 隐藏
    if (hiddenPercent >= 100) return indices; // 100% 全部隐藏

    // 打乱索引
    final seed = Random(wordList.length);
    indices.shuffle(seed);

    // 计算要隐藏的数量
    final hiddenCount = (total * hiddenPercent / 100).ceil();

    // 取前 hiddenCount 个索引作为隐藏索引
    return indices.sublist(0, hiddenCount);
  }

  @override
  Widget build(BuildContext context) {
    final words = this.words
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final hiddenIndices = _calcHiddenIndices(words, hiddenPercent);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(words.length, (idx) {
        final isHidden = hiddenIndices.contains(idx);
        final word = words[idx];

        return GestureDetector(
          onTap: () {
            if (!isHidden) {
              HapticFeedback.lightImpact();

              final safeWord = word
                  .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                  .toLowerCase();
              showDictModal(context, safeWord);
            }
          },
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  word,
                  style: TextStyle(
                    fontSize: 22,
                    color: isHidden ? Colors.black.withAlpha(1) : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Container(height: 2, color: Colors.black.withAlpha(96)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
