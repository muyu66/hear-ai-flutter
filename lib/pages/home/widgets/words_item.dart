import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/words.dart';
import 'package:hearai/pages/home/widgets/slice_words.dart';
import 'package:hearai/services/words_service.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';

class WordsItem extends StatefulWidget {
  final WordsModel words;
  final int level;
  const WordsItem({super.key, required this.words, required this.level});

  @override
  State<WordsItem> createState() => _WordsItemState();
}

class _WordsItemState extends State<WordsItem> {
  // 当前学习难度
  final AudioManager audioManager = AudioManager();
  final wordsService = WordsService();
  bool done = false; // 是否已提交反馈

  @override
  void initState() {
    super.initState();
  }

  void _handleBadWords() async {
    final l = AppLocalizations.of(context);

    HapticFeedback.lightImpact();

    wordsService
        .badWords(widget.words.id)
        .then((value) {
          if (!mounted) return;
          showNotify(context: context, title: l.reportSuccess);
          setState(() {
            done = true;
          });
        })
        .catchError((error) {
          if (!mounted) return;
        });
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return SafeArea(
      // 👈 关键：包裹整个内容
      bottom: false, // 如果底部 Pad 已处理 safe area，这里可设为 false
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(child: _buildContent()),
            if (widget.level > 4)
              Positioned(
                top: 8,
                right: 8,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.thumb_down,
                      color: done ? c.secondary : c.error,
                      size: 22,
                    ),
                    onPressed: done ? null : _handleBadWords,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.level) {
      case 1:
        // 显示音乐图标
        return Transform.translate(
          offset: const Offset(0, -100),
          child: Icon(Icons.music_note, size: 120),
        );
      case 2:
        // 显示 0% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: widget.words.words, hiddenPercent: 100),
        );
      case 3:
        // 显示 30% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: widget.words.words, hiddenPercent: 70),
        );
      case 4:
        // 显示 60% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: widget.words.words, hiddenPercent: 40),
        );
      case 5:
        // 显示 100% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: widget.words.words, hiddenPercent: 0),
        );
      case 6:
      default:
        // 显示 100% 文字，和翻译
        return Transform.translate(
          offset: const Offset(0, -80),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 避免 Column 占满高度
            children: [
              SliceWords(words: widget.words.words, hiddenPercent: 0),
              const SizedBox(height: 52),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Text(
                  widget.words.translation,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );
    }
  }
}
