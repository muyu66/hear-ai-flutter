import 'package:flutter/material.dart';
import 'package:hearai/models/word_book_summary.dart';
import 'package:hearai/pages/word_book/widgets/book_page_view.dart';
import 'package:hearai/pages/word_book/widgets/stats.dart';
import 'package:hearai/services/my_word_service.dart';

class WordBookPage extends StatefulWidget {
  const WordBookPage({super.key});

  @override
  State<WordBookPage> createState() => _WordBookPageState();
}

class _WordBookPageState extends State<WordBookPage> {
  bool _loadingSummary = false;
  WordBookSummary _summary = WordBookSummary(
    currStability: 0,
    tomorrowCount: 0,
    totalCount: 0,
    nowCount: 0,
    todayDoneCount: 0,
  );
  final MyWordService myWordService = MyWordService();

  Future<void> _loadSummary() async {
    if (_loadingSummary) {
      return;
    }
    setState(() {
      _loadingSummary = true;
    });

    // 获取单词本统计
    final wordBookSummary = await myWordService.getSummary();

    setState(() {
      _summary = wordBookSummary;
      _loadingSummary = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ===== 顶部统计卡片 =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stats(summary: _summary),
            ),

            const SizedBox(height: 10),

            // ===== 单词列表 =====
            Expanded(
              child: BookPageView(
                onPageChanged: () async {
                  await _loadSummary();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
