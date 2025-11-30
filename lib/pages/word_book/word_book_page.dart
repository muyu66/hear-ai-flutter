import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/models/word_book_summary.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/themes/light/color_schemes.dart';
import 'package:hearai/tools/dialog.dart';
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
  WordBookSummary summary = WordBookSummary(0, 0, 0);
  final WordBooksService wordBooksService = WordBooksService();
  // 点击寻求提示的次数
  int hitCount = 0;
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
              child: Row(
                children: [
                  _buildStatCard(title: '当前需复习', value: summary.todayCount),
                  const SizedBox(width: 12),
                  _buildStatCard(title: '明天需复习', value: summary.tomorrowCount),
                  const SizedBox(width: 12),
                  _buildStatCard(title: '单词本总数', value: summary.totalCount),
                ],
              ),
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
                            hitCount: hitCount,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                hitCount++;
                                currentWord = word.word; // 激活这个单词
                              });
                              showDictModal(context, word.word);
                            },
                            onCorrect: () {
                              HapticFeedback.lightImpact();
                              wordBooksService
                                  .rememberWordBooks(word.word, hitCount)
                                  .then((_) {
                                    _loadData();
                                  });
                            },
                            onIncorrect: () {
                              HapticFeedback.lightImpact();
                              showConfirm(
                                context: context,
                                title: l.confirmDeleteWordBooks(word.word),
                                dialogType: DialogType.question,
                                onConfirm: () {
                                  HapticFeedback.lightImpact();
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

  /// 构建一个统计卡片
  Widget _buildStatCard({required String title, required int value}) {
    final c = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: c.onSecondaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32, // 限制数字区域高度
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 20,
                  color: c.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade, // 或 ellipsis
              ),
            ),
            Text(title, style: TextStyle(fontSize: 14, color: c.onPrimary)),
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
  final int hitCount;
  final bool showMore;
  final VoidCallback onTap;

  const _WordListItem({
    required this.word,
    this.phonetic,
    required this.onCorrect,
    required this.onIncorrect,
    required this.hitCount,
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
        title: Text(word, style: const TextStyle(fontSize: 18)),
        onTap: onTap,
        subtitle: (showMore && phonetic != null)
            ? Text(
                "/$phonetic/",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
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
