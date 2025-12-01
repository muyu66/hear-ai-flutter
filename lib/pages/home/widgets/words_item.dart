import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/words.dart';
import 'package:hearai/pages/home/widgets/slice_words.dart';
import 'package:hearai/services/words_service.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';

enum WidgetType { listen, say }

class WordsItem extends StatefulWidget {
  final WordsModel words;
  final int level;
  const WordsItem({super.key, required this.words, required this.level});

  @override
  State<WordsItem> createState() => _WordsItemState();
}

class _WordsItemState extends State<WordsItem> {
  final AudioManager audioManager = AudioManager();
  final wordsService = WordsService();
  bool done = false; // 是否已提交反馈
  int? _lastPlayedLevel;
  int? _lastPlayedWordsId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    audioManager.stop();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WordsItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    audioManager.stop();
    print(
      "widget.words.id=${widget.words.id} _lastPlayedWordsId=${_lastPlayedWordsId}",
    );
    print("widget.level=${widget.level} _lastPlayedLevel=${_lastPlayedLevel}");
    // 只有当 wordsId 或 level 发生有意义的变化时才播放
    if (_lastPlayedWordsId == null || widget.level != _lastPlayedLevel) {
      _lastPlayedWordsId = widget.words.id;
      _lastPlayedLevel = widget.level;
      _tryPlay();
    }
  }

  void _tryPlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.words.type == WidgetType.say) {
        if (widget.level == 2) {
          play(widget.words.id, slow: false);
        } else if (widget.level >= 3) {
          play(widget.words.id, slow: true);
        }
      } else if (widget.words.type == WidgetType.listen) {
        if (widget.level == 1) {
          play(widget.words.id, slow: false);
        } else {
          play(widget.words.id, slow: true);
        }
      }
    });
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

  Future<void> play(int wordsId, {bool slow = false}) async {
    await audioManager.play(
      wordsService.getWordsVoiceUrl(wordsId, slow: slow),
      mimeType: 'audio/ogg',
    );
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
            Center(
              child: widget.words.type == WidgetType.listen
                  ? _buildListen()
                  : _buildSay(),
            ),
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

  Widget _buildSay() {
    switch (widget.level) {
      case 1:
        // 显示说话图标
        return Transform.translate(
          offset: const Offset(0, -80),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 避免 Column 占满高度
            children: [
              Icon(FontAwesomeIcons.microphone, size: 94),
              const SizedBox(height: 52),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Text(
                  widget.words.translation,
                  style: Theme.of(context).textTheme.printText,
                ),
              ),
            ],
          ),
        );
      case 2:
        // 显示 0% 文字
        return Transform.translate(
          offset: const Offset(0, -80),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 避免 Column 占满高度
            children: [
              Icon(FontAwesomeIcons.microphone, size: 94),
              const SizedBox(height: 52),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Text(
                  widget.words.translation,
                  style: Theme.of(context).textTheme.printText,
                ),
              ),
            ],
          ),
        );
      case 3:
      default:
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
                  style: Theme.of(context).textTheme.printText,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildListen() {
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
                  style: Theme.of(context).textTheme.printText,
                ),
              ),
            ],
          ),
        );
    }
  }
}
