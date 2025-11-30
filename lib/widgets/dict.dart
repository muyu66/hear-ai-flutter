import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/word_dict.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/services/word_service.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

void showDictModal(BuildContext context, String word) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    barrierLabel: 'Dictionary',
    pageBuilder: (context, animation, secondaryAnimation) {
      return _DictModal(word: word);
    },
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(animation);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class _DictModal extends StatefulWidget {
  final String word;
  const _DictModal({required this.word});

  @override
  State<_DictModal> createState() => _DictModalState();
}

class _DictModalState extends State<_DictModal>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  WebViewController? _webViewController;
  WordService wordService = WordService();
  WordBooksService wordBooksService = WordBooksService();
  final AudioManager audioManager = AudioManager();
  WordDict? wordDict;
  bool? existInWordBooks;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // 延迟初始化 WebView
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      wordService.getWordDict(widget.word).then((value) {
        if (mounted) {
          setState(() {
            wordDict = value;
          });
        }
      });

      _handleExistInWordBooks();

      audioManager.play(
        wordService.getWordVoiceUrl(widget.word),
        mimeType: 'audio/ogg',
      );

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.parse(
            'https://www.bing.com/dict/search?q=${Uri.encodeFull(widget.word)}',
          ),
        );

      if (mounted) {
        setState(() {
          _webViewController = controller;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    audioManager.stop();
    super.dispose();
  }

  void _handleExistInWordBooks() async {
    wordBooksService.exist(widget.word).then((value) {
      if (mounted) {
        setState(() {
          existInWordBooks = value.result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final modalHeight = screenHeight * 0.8;

    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: SizedBox(
        height: screenHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: modalHeight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: const [
                          Tab(text: '本地词典'),
                          Tab(text: '必应词典'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // 本地词典
                            _LocalDictView(
                              key: const ValueKey('local'),
                              word: widget.word,
                              phonetic: wordDict?.phonetic ?? '',
                              explanation: (wordDict?.translation ?? '')
                                  .replaceAll(r'\n', '\n'),
                            ),
                            // 必应词典
                            _webViewController != null
                                ? WebViewWidget(
                                    key: const ValueKey('web'),
                                    controller: _webViewController!,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      ),

                      _buildBottomActions(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                audioManager.play(
                  wordService.getWordVoiceUrl(widget.word),
                  mimeType: 'audio/ogg',
                );
              },
              icon: const Icon(
                Icons.play_circle,
                size: 24,
                color: Colors.black87,
              ),
              label: const Text('再听一遍', style: TextStyle(fontSize: 16)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                alignment: Alignment.center,
                overlayColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              label: Text(
                existInWordBooks == null
                    ? ''
                    : existInWordBooks!
                    ? '已加入单词本'
                    : '添加到单词本',
                style: TextStyle(fontSize: 14),
              ),
              icon: existInWordBooks == null
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      existInWordBooks!
                          ? Icons.bookmark_added
                          : Icons.bookmark_add,
                      size: 22,
                    ),
              onPressed: existInWordBooks == null
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      if (existInWordBooks!) {
                        wordBooksService.deleteWordBooks(widget.word).then((_) {
                          _handleExistInWordBooks();
                        });
                      } else {
                        wordBooksService.addWordBooks(widget.word).then((_) {
                          _handleExistInWordBooks();
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: existInWordBooks == null
                    ? null
                    : existInWordBooks!
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.onPrimary,
                backgroundColor: existInWordBooks == null
                    ? null
                    : existInWordBooks!
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// 本地词典视图（保持不变）
// ---------------------------

class _LocalDictView extends StatefulWidget {
  final String word;
  final String phonetic;
  final String explanation;
  const _LocalDictView({
    super.key,
    required this.word,
    required this.phonetic,
    required this.explanation,
  });

  @override
  State<_LocalDictView> createState() => _LocalDictViewState();
}

class _LocalDictViewState extends State<_LocalDictView> {
  bool done = false;
  WordService wordService = WordService();

  void _handleBadWordDict() {
    final l = AppLocalizations.of(context);

    HapticFeedback.lightImpact();
    wordService
        .badWordDict(widget.word)
        .then((value) {
          if (!mounted) return;
          showNotify(context: context, title: l.reportSuccess);
          setState(() {
            done = true;
          });
        })
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.word,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.thumb_down,
                  color: done ? c.secondary : c.error,
                  size: 22,
                ),
                onPressed: done ? null : _handleBadWordDict,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (widget.phonetic.isNotEmpty)
            Text(
              "/${widget.phonetic}/",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          const SizedBox(height: 16),
          Text(widget.explanation, style: TextStyle(fontSize: 16, height: 1.4)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
