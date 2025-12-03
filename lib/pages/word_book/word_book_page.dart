import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/models/word_book_summary.dart';
import 'package:hearai/pages/word_book/widgets/stats.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/themes/light/color_schemes.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';
import 'package:hearai/widgets/dict.dart';
import 'package:hearai/widgets/loading.dart';

class WordBookPage extends StatefulWidget {
  const WordBookPage({super.key});

  @override
  State<WordBookPage> createState() => _WordBookPageState();
}

class _WordBookPageState extends State<WordBookPage> {
  final List<WordBook> words = [];
  bool _loading = true;
  WordBookSummary summary = WordBookSummary(
    currStability: 0,
    tomorrowCount: 0,
    totalCount: 0,
    nowCount: 0,
    todayDoneCount: 0,
  );
  final WordBooksService wordBooksService = WordBooksService();
  // 点击寻求提示的次数
  int hintCount = 0;
  // 用于显示音标
  String? currentWord;

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });

    // 获取单词列表
    final wordBooks = await wordBooksService.getWordBooks();

    // 获取单词本统计
    final wordBookSummary = await wordBooksService.getWordBooksSummary();

    setState(() {
      words.clear();
      words.addAll(wordBooks);
      summary = wordBookSummary;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ===== 顶部统计卡片 =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stats(summary: summary),
            ),

            // ===== 单词列表 =====
            Expanded(
              child: _loading
                  ? Center(
                      child: Transform.translate(
                        offset: Offset(0, -70),
                        child: const Loading(),
                      ),
                    )
                  : words.isEmpty
                  ? Center(
                      child: Transform.translate(
                        offset: Offset(0, -70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.book_outlined,
                              size: 72,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 22),
                            Text(
                              '空空如也',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          final word = words[index];
                          return _WordListItem(
                            word: word.word,
                            phonetic: word.phonetic,
                            showMore: word.word == currentWord,
                            hintCount: hintCount,
                            onTap: () {
                              HapticsManager.light();
                              setState(() {
                                hintCount++;
                                currentWord = word.word; // 激活这个单词
                              });
                              showDictModal(context, word.word);
                            },
                            onCorrect: () {
                              HapticsManager.light();
                              wordBooksService
                                  .rememberWordBooks(
                                    word: word.word,
                                    hintCount: hintCount,
                                    thinkingTime: 0,
                                  )
                                  .then((_) {
                                    _loadData();
                                  });
                            },
                            onIncorrect: () {
                              HapticsManager.light();
                              showConfirm(
                                context: context,
                                title: l.confirmDeleteWordBooks(word.word),
                                dialogType: DialogType.question,
                                onConfirm: () {
                                  HapticsManager.light();
                                  wordBooksService
                                      .deleteWordBooks(word.word)
                                      .then((_) {
                                        _loadData();
                                      });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 单词列表项
class _WordListItem extends StatelessWidget {
  final String word;
  final String? phonetic;
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  final int hintCount;
  final bool showMore;
  final VoidCallback onTap;

  const _WordListItem({
    required this.word,
    this.phonetic,
    required this.onCorrect,
    required this.onIncorrect,
    required this.hintCount,
    required this.showMore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; // 获取 ColorScheme

    return Container(
      color: showMore ? c.listHighlight : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(word, style: Theme.of(context).textTheme.printText),
        onTap: onTap,
        subtitle: (showMore && phonetic != null)
            ? Text(
                "/$phonetic/",
                style: Theme.of(context).textTheme.printTextSm,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.xmark, size: 28),
              onPressed: onIncorrect,
              splashRadius: 20,
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.check, size: 28),
              onPressed: onCorrect,
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
