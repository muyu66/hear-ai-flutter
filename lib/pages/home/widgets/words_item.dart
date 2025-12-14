import 'package:flutter/material.dart';
import 'package:hearai/models/sentence.dart';
import 'package:hearai/pages/home/widgets/words_widget.dart';

enum WidgetType { listen, say }

class WordsItem extends StatelessWidget {
  final SentenceModel wordsModel;
  final WidgetType type;
  final int clickCount;
  final bool reported;
  final void Function() onTapReport;

  const WordsItem({
    super.key,
    required this.wordsModel,
    required this.clickCount,
    required this.type,
    required this.reported,
    required this.onTapReport,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (clickCount > 4)
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: reported ? c.secondary : c.error,
                        size: 22,
                      ),
                      onPressed: reported ? null : onTapReport,
                    ),
                ],
              ),
            ),
            Center(
              child: type == WidgetType.listen
                  ? WordsListenWidget(
                      words: wordsModel.words,
                      lang: wordsModel.wordsLang,
                      clickCount: clickCount,
                      translation: wordsModel.translation,
                    )
                  : WordsSayWidget(
                      words: wordsModel.words,
                      lang: wordsModel.wordsLang,
                      clickCount: clickCount,
                      translation: wordsModel.translation,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
