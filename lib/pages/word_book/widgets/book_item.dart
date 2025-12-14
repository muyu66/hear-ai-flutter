import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/pages/word_book/widgets/snap_slider.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';
import 'package:hearai/widgets/phonetic_tag.dart';

class BookItem extends StatefulWidget {
  final WordBook wordBook;
  final void Function(String) onDeleteWordBook;
  final void Function() onTapHintButton;
  final void Function(String word) onTapBad;
  final void Function({required String word, required int rememberLevel})
  onRememberWordBook;

  const BookItem({
    super.key,
    required this.wordBook,
    required this.onDeleteWordBook,
    required this.onRememberWordBook,
    required this.onTapHintButton,
    required this.onTapBad,
  });
  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  // 是否显示释义等
  bool showMore = false;
  bool reported = false;

  Widget _buildQuestionButton(VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8), // 扩大触摸范围
      child: ClipOval(
        child: Material(
          elevation: 3,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.solidCircleQuestion, size: 64),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneticTagRow(WordBook wordBook) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: wordBook.lang == "en"
          ? [
              PhoneticTag(
                prefix: "phonetic_en_1".tr,
                text: wordBook.phonetic[0],
              ),
              const SizedBox(width: 6),
              PhoneticTag(
                prefix: "phonetic_en_2".tr,
                text: wordBook.phonetic[1],
              ),
            ]
          : [
              PhoneticTag(
                prefix: "phonetic_ja_1".tr,
                text: wordBook.phonetic[0],
              ),
              const SizedBox(width: 6),
              PhoneticTag(
                prefix: "phonetic_ja_2".tr,
                text: wordBook.phonetic[1],
              ),
              const SizedBox(width: 6),
              PhoneticTag(
                prefix: "phonetic_ja_3".tr,
                text: wordBook.phonetic[2],
              ),
            ],
    );
  }

  Widget _buildTitle(String word) {
    final t = Theme.of(this.context).textTheme;

    return GestureDetector(
      onTap: () {
        HapticsManager.light();
        Clipboard.setData(ClipboardData(text: word));
        showNotify(context: this.context, title: "copied".tr);
      },
      child: Text(word, style: t.printTextXl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    void onTapSubmit(int rememberLevel) {
      widget.onRememberWordBook(
        word: widget.wordBook.word,
        rememberLevel: rememberLevel,
      );
    }

    return Stack(
      children: [
        // 顶部按钮区
        Positioned(
          top: 10,
          right: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showMore)
                IconButton(
                  onPressed: reported
                      ? null
                      : () {
                          setState(() {
                            reported = true;
                          });
                          widget.onTapBad(widget.wordBook.word);
                        },
                  icon: Icon(
                    Icons.thumb_down,
                    color: reported ? c.secondary : c.error,
                    size: 22,
                  ),
                ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  widget.onDeleteWordBook(widget.wordBook.word);
                },
                icon: Icon(FontAwesomeIcons.xmark, color: c.error),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: widget.wordBook.type == WordWidgetType.source
                    ? [
                        _buildTitle(widget.wordBook.word),
                        const SizedBox(height: 12),
                        if (showMore) ...[
                          _buildPhoneticTagRow(widget.wordBook),
                          const SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              widget.wordBook.translation.isNotEmpty
                                  ? widget.wordBook.translation
                                  : '完蛋，找不到这个单词的释义...',
                              style: t.printTextSm.copyWith(color: c.secondary),
                            ),
                          ),
                        ],
                      ]
                    : [
                        if (showMore) ...[
                          _buildTitle(widget.wordBook.word),
                          const SizedBox(height: 12),
                          _buildPhoneticTagRow(widget.wordBook),
                          const SizedBox(height: 30),
                        ],
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
                          child: Text(
                            widget.wordBook.translation.isNotEmpty
                                ? widget.wordBook.translation
                                : '完蛋，找不到这个单词的释义...',
                            style: t.printTextSm.copyWith(color: c.secondary),
                          ),
                        ),
                      ],
              ),
              showMore
                  ? SnapSlider(
                      children: [
                        Text(
                          "😣",
                          style: TextStyle(fontSize: 38),
                        ), // hintCount=4
                        Text(
                          "😐",
                          style: TextStyle(fontSize: 38),
                        ), // hintCount=3
                        Text(
                          "😊",
                          style: TextStyle(fontSize: 38),
                        ), // hintCount=1
                        Text(
                          "😆",
                          style: TextStyle(fontSize: 38),
                        ), // hintCount=0
                      ],
                      onChanged: (i) {
                        switch (i) {
                          case 0:
                            HapticsManager.heavy();
                            break;
                          case 1:
                            HapticsManager.medium();
                            break;
                          case 2:
                            HapticsManager.light();
                            break;
                          case 3:
                            HapticsManager.heavy();
                            break;
                        }
                      },
                      onFinished: (i) {
                        // i 对应上方的数组下标
                        onTapSubmit(
                          i == 0
                              ? 4
                              : i == 1
                              ? 3
                              : i == 2
                              ? 1
                              : 0,
                        );
                      },
                    )
                  : _buildQuestionButton(() {
                      HapticsManager.light();
                      setState(() {
                        showMore = true;
                      });
                      widget.onTapHintButton();
                    }),
            ],
          ),
        ),
      ],
    );
  }
}
