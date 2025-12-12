import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/pages/home/widgets/slice_words.dart';
import 'package:hearai/themes/light/typography.dart';

class WordsListenWidget extends StatelessWidget {
  final String words;
  final String lang;
  final int level;
  final String translation;
  const WordsListenWidget({
    super.key,
    required this.words,
    required this.lang,
    required this.level,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    switch (level) {
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
          child: SliceWords(words: words, lang: lang, hiddenPercent: 100),
        );
      case 3:
        // 显示 30% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: words, lang: lang, hiddenPercent: 70),
        );
      case 4:
        // 显示 60% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: words, lang: lang, hiddenPercent: 40),
        );
      case 5:
        // 显示 100% 文字
        return Transform.translate(
          offset: const Offset(0, -130),
          child: SliceWords(words: words, lang: lang, hiddenPercent: 0),
        );
      case 6:
      default:
        // 显示 100% 文字，和翻译
        return Transform.translate(
          offset: const Offset(0, -80),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 避免 Column 占满高度
            children: [
              SliceWords(words: words, lang: lang, hiddenPercent: 0),
              const SizedBox(height: 52),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Text(
                  translation,
                  style: Theme.of(context).textTheme.printText,
                ),
              ),
            ],
          ),
        );
    }
  }
}

class WordsSayWidget extends StatelessWidget {
  final String words;
  final String lang;
  final int level;
  final String translation;
  const WordsSayWidget({
    super.key,
    required this.words,
    required this.lang,
    required this.level,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    switch (level) {
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
                  translation,
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
                  translation,
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
              SliceWords(words: words, lang: lang, hiddenPercent: 0),
              const SizedBox(height: 52),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Text(
                  translation,
                  style: Theme.of(context).textTheme.printText,
                ),
              ),
            ],
          ),
        );
    }
  }
}
