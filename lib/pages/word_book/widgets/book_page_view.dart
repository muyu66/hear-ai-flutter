import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/pages/word_book/widgets/book_item.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/services/word_service.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';

class BookPageView extends StatefulWidget {
  final Future<void> Function() onPageChanged;
  const BookPageView({super.key, required this.onPageChanged});

  @override
  State<BookPageView> createState() => _BookPageViewState();
}

class _BookPageViewState extends State<BookPageView> {
  final PageController _pageController = PageController();
  final WordBooksService wordBooksService = WordBooksService();
  final WordService wordService = WordService();
  DateTime lastThinkingTime = DateTime.now();
  bool _loadingSummary = false;
  final List<WordBook> _wordBooks = [];
  final AudioManager audioManager = AudioManager();
  int _offset = 0;

  void _handlePageChanged(int index) {}

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (_loadingSummary) {
      return;
    }
    setState(() {
      _loadingSummary = true;
    });

    // 获取单词列表
    final wordBooks = await wordBooksService.getWordBooks(offset: _offset);
    if (wordBooks.isNotEmpty) {
      setState(() {
        _offset += wordBooks.length;
        _wordBooks.addAll(wordBooks);
        _loadingSummary = false;
      });
    }
  }

  void _goToNextPage() {
    setState(() {
      lastThinkingTime = DateTime.now();
    });

    if (!_pageController.hasClients) return;

    final currentPage = _pageController.page!.toInt();
    final nextPage = currentPage + 1;

    // 如果 nextPage 超出数据范围（极端情况）
    if (nextPage > _wordBooks.length) return;

    // 触发翻页前先检查预加载
    _maybePreload(nextPage);

    // 触发用户回调（不阻塞 UI）
    widget.onPageChanged();

    // 统一进行翻页动画
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _maybePreload(int nextPage) {
    // 距离数据末尾不足 10 个，开始预加载
    if (nextPage >= _wordBooks.length - 10) {
      _loadData(); // 不 await，避免卡动画
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // 禁止手势滑动
      onPageChanged: _handlePageChanged,
      scrollDirection: Axis.vertical,
      itemCount: _wordBooks.length + 1,
      itemBuilder: (context, index) {
        if (index >= _wordBooks.length) {
          return Center(
            child: Transform.translate(
              offset: Offset(0, -70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book_outlined, size: 72, color: Colors.grey),
                  const SizedBox(height: 22),
                  Text(
                    '空空如也',
                    style: TextStyle(fontSize: 28, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }
        final wordBook = _wordBooks[index];
        return BookItem(
          wordBook: wordBook,
          onTapHintButton: () {
            audioManager.play(
              wordService.getWordVoiceUrl(wordBook.word, slow: true),
            );
            // audioManager.play(wordBook.voice);
          },
          onRememberWordBook:
              ({required String word, required int rememberLevel}) {
                wordBooksService
                    .rememberWordBooks(
                      word: word,
                      hintCount: rememberLevel,
                      thinkingTime:
                          DateTime.now().millisecondsSinceEpoch -
                          lastThinkingTime.millisecondsSinceEpoch,
                    )
                    .then((_) {
                      _goToNextPage();
                    });
              },
          onDeleteWordBook: (String word) {
            showConfirm(
              context: context,
              title: "确认将 $word 从单词本中删除吗？",
              dialogType: DialogType.warning,
              onConfirm: () {
                wordBooksService.deleteWordBooks(word).then((_) {
                  _goToNextPage();
                });
              },
            );
          },
        );
      },
    );
  }
}
