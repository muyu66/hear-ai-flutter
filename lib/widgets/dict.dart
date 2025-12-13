import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hearai/models/dict_model.dart';
import 'package:hearai/services/dict_service.dart';
import 'package:hearai/services/my_word_service.dart';
import 'package:hearai/themes/light/typography.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';

void showDictModal(BuildContext context, String word, String lang) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    barrierLabel: 'Dictionary',
    pageBuilder: (context, animation, secondaryAnimation) {
      return _DictModal(word: word, lang: lang);
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
  final String lang;
  const _DictModal({required this.word, required this.lang});

  @override
  State<_DictModal> createState() => _DictModalState();
}

class _DictModalState extends State<_DictModal> {
  DictService dictService = DictService();
  MyWordService myWordService = MyWordService();
  final AudioManager audioManager = AudioManager();
  bool? existInWordBooks;
  DictModel? dict;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dictService.getDict(widget.word, widget.lang).then((value) {
        if (mounted) {
          setState(() {
            dict = value;
          });
        }
      });

      _handleExistInWordBooks();

      dictService
          .getPronunciation(widget.word, slow: false, lang: widget.lang)
          .then((bytes) {
            audioManager.play(bytes, mimeType: 'audio/ogg');
          });
    });
  }

  @override
  void dispose() {
    audioManager.stop();
    super.dispose();
  }

  void _handleExistInWordBooks() async {
    myWordService.exist(widget.word).then((value) {
      if (mounted) {
        setState(() {
          existInWordBooks = value.result;
        });
      }
    });
  }

  void _onPageChanged(int index) {
    dictService
        .getPronunciation(widget.word, slow: false, lang: widget.lang)
        .then((bytes) {
          audioManager.play(bytes, mimeType: 'audio/ogg');
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final modalHeight = screenHeight * 0.8;
    final t = Theme.of(context);

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
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      ),
                      dict == null
                          ? Center(
                              child: Text(
                                "404".tr,
                                style: t.textTheme.printTextXl,
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: PageView.builder(
                                    onPageChanged: _onPageChanged,
                                    itemCount: 1,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return _LocalDictView(
                                        key: ValueKey('local_ai'),
                                        dict: 'ai',
                                        dictName: 'AI词典',
                                        dictModel: dict!,
                                      );
                                    },
                                  ),
                                ),
                                _buildBottomActions(),
                              ],
                            ),
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
                HapticsManager.light();
                dictService
                    .getPronunciation(
                      widget.word,
                      slow: true,
                      lang: widget.lang,
                    )
                    .then((bytes) {
                      audioManager.play(bytes, mimeType: 'audio/ogg');
                    });
              },
              icon: const Icon(
                Icons.play_circle,
                size: 24,
                color: Colors.black87,
              ),
              label: Text('playSlow'.tr, style: TextStyle(fontSize: 16)),
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
                      HapticsManager.light();
                      if (existInWordBooks!) {
                        myWordService.delete(widget.word).then((_) {
                          _handleExistInWordBooks();
                        });
                      } else {
                        myWordService.add(widget.word).then((_) {
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
  final String dict;
  final String dictName;
  final DictModel dictModel;

  const _LocalDictView({
    super.key,
    required this.dict,
    required this.dictName,
    required this.dictModel,
  });

  @override
  State<_LocalDictView> createState() => _LocalDictViewState();
}

class _LocalDictViewState extends State<_LocalDictView> {
  DictService dictService = DictService();

  void _badDict(String dictType) {
    HapticsManager.light();
    dictService
        .bad(id: widget.dictModel.id)
        .then((value) {
          if (!mounted) return;
          showNotify(context: context, title: "reportSuccess".tr);
          setState(() {
            widget.dictModel.reported = true;
          });
        })
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.dictName,
                  style: t.labelMedium!.copyWith(color: c.onPrimary),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.thumb_down,
                  color: widget.dictModel.reported ? c.secondary : c.error,
                  size: 22,
                ),
                onPressed: widget.dictModel.reported
                    ? null
                    : () {
                        _badDict(widget.dictName);
                      },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.dictModel.word, style: t.printTextXl),
                const SizedBox(height: 2),
                Text(
                  widget.dictModel.phonetic.isNotEmpty
                      ? widget.dictModel.phonetic
                      : '-',
                  style: t.printText.copyWith(color: c.secondary),
                ),
                const SizedBox(height: 32),
                Text(
                  widget.dictModel.translation.isNotEmpty
                      ? widget.dictModel.translation
                      : '完蛋，找不到这个单词的释义...',
                  style: t.printTextSm.copyWith(color: c.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
