import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/haptics_manager.dart';

class BookItem extends StatefulWidget {
  final WordBook wordBook;
  final void Function(String) onDeleteWordBook;
  final void Function() onTapHintButton;
  final void Function({required String word, required int rememberLevel})
  onRememberWordBook;

  const BookItem({
    super.key,
    required this.wordBook,
    required this.onDeleteWordBook,
    required this.onRememberWordBook,
    required this.onTapHintButton,
  });
  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  // 是否显示释义等
  bool showMore = false;
  // 记忆程度，0=好 1=中等 2=差
  int? _rememberLevel;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    void onTapEmoji(int rememberLevel) {
      HapticsManager.light();
      setState(() {
        _rememberLevel = rememberLevel;
      });
      widget.onRememberWordBook(
        word: widget.wordBook.word,
        rememberLevel: rememberLevel,
      );
    }

    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 8),
              child: IconButton(
                onPressed: () {
                  widget.onDeleteWordBook(widget.wordBook.word);
                },
                icon: Icon(FontAwesomeIcons.xmark, color: c.error),
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: widget.wordBook.type == WordWidgetType.source
                    ? [
                        Text(widget.wordBook.word, style: t.printTextXl),
                        const SizedBox(height: 12),
                        if (showMore) ...[
                          Text(
                            widget.wordBook.phonetic != null &&
                                    widget.wordBook.phonetic!.isNotEmpty
                                ? '/${widget.wordBook.phonetic}/'
                                : '-',
                            style: t.printText.copyWith(color: c.secondary),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              widget.wordBook.translation != null &&
                                      widget.wordBook.translation!.isNotEmpty
                                  ? widget.wordBook.translation!
                                        .replaceAll(r'\n', '\n')
                                        .replaceAll(r'\r', '\n')
                                  : '完蛋，找不到这个单词的释义...',
                              style: t.printTextSm.copyWith(color: c.secondary),
                            ),
                          ),
                        ],
                      ]
                    : [
                        if (showMore) ...[
                          Text(widget.wordBook.word, style: t.printTextXl),
                          const SizedBox(height: 12),
                          Text(
                            widget.wordBook.phonetic != null &&
                                    widget.wordBook.phonetic!.isNotEmpty
                                ? '/${widget.wordBook.phonetic}/'
                                : '-',
                            style: t.printText.copyWith(color: c.secondary),
                          ),
                          const SizedBox(height: 30),
                        ],
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
                          child: Text(
                            widget.wordBook.translation != null &&
                                    widget.wordBook.translation!.isNotEmpty
                                ? widget.wordBook.translation!.replaceAll(
                                    r'\n',
                                    '\n',
                                  )
                                : '完蛋，找不到这个单词的释义...',
                            style: t.printTextSm.copyWith(color: c.secondary),
                          ),
                        ),
                      ],
              ),
              const SizedBox(height: 16),
              showMore
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEmojiButton(
                          "😣",
                          onTap: () {
                            onTapEmoji(2);
                          },
                          enabled: _rememberLevel == null,
                          selected: _rememberLevel == 2,
                        ),
                        const SizedBox(width: 20),
                        _buildEmojiButton(
                          "😐",
                          onTap: () {
                            onTapEmoji(1);
                          },
                          enabled: _rememberLevel == null,
                          selected: _rememberLevel == 1,
                        ),
                        const SizedBox(width: 20),
                        _buildEmojiButton(
                          "😊",
                          onTap: () {
                            onTapEmoji(0);
                          },
                          enabled: _rememberLevel == null,
                          selected: _rememberLevel == 0,
                        ),
                      ],
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

Widget _buildEmojiButton(
  String emoji, {
  required VoidCallback onTap,
  bool enabled = true, // 是否可点击
  bool selected = false, // 是否选中
}) {
  return ClipOval(
    child: Material(
      child: InkWell(
        onTap: enabled ? onTap : null, // 不可点击时禁用
        child: Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          child: Text(emoji, style: TextStyle(fontSize: 38)),
        ),
      ),
    ),
  );
}

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
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.solidCircleQuestion, size: 48),
          ),
        ),
      ),
    ),
  );
}
