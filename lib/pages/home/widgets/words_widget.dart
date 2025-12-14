import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hearai/pages/home/widgets/slice_words.dart';
import 'package:hearai/themes/light/typography.dart';

class WordsListenWidget extends StatelessWidget {
  final List<String> words;
  final String lang;
  final int clickCount;
  final String translation;
  const WordsListenWidget({
    super.key,
    required this.words,
    required this.lang,
    required this.clickCount,
    required this.translation,
  });

  Widget _showOnlyIcon() {
    // 显示音乐图标
    return Transform.translate(
      offset: const Offset(0, -100),
      child: Icon(Icons.music_note, size: 120),
    );
  }

  Widget _showOnlyWords(int hiddenPercent) {
    // 显示 n% 文字
    return Transform.translate(
      offset: const Offset(0, -130),
      child: SliceWords(words: words, lang: lang, hiddenPercent: hiddenPercent),
    );
  }

  Widget _showWordsAndTrans(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    if (words.length <= 2) {
      switch (clickCount) {
        case 1:
          return _showOnlyIcon();
        case 2:
          return _showOnlyWords(100);
        case 3:
          return _showOnlyWords(0);
        default:
          return _showWordsAndTrans(context);
      }
    } else if (words.length <= 4) {
      switch (clickCount) {
        case 1:
          return _showOnlyIcon();
        case 2:
          return _showOnlyWords(100);
        case 3:
          return _showOnlyWords(50);
        case 4:
          return _showOnlyWords(0);
        default:
          return _showWordsAndTrans(context);
      }
    } else {
      switch (clickCount) {
        case 1:
          return _showOnlyIcon();
        case 2:
          return _showOnlyWords(100);
        case 3:
          return _showOnlyWords(70);
        case 4:
          return _showOnlyWords(40);
        case 5:
          return _showOnlyWords(0);
        case 6:
        default:
          return _showWordsAndTrans(context);
      }
    }
  }
}

class WordsSayWidget extends StatelessWidget {
  final List<String> words;
  final String lang;
  final int clickCount;
  final String translation;
  const WordsSayWidget({
    super.key,
    required this.words,
    required this.lang,
    required this.clickCount,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    switch (clickCount) {
      case 1:
        // 显示说话图标
        return Transform.translate(
          offset: const Offset(0, -80),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 避免 Column 占满高度
            children: [
              Icon(FontAwesomeIcons.microphone, size: 94),
              const SizedBox(height: 16),
              Text(lang.tr, style: Theme.of(context).textTheme.printTextLg),
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
              const SizedBox(height: 16),
              Text("......", style: Theme.of(context).textTheme.printTextLg),
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
