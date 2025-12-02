import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hearai/app.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/words.dart';
import 'package:hearai/pages/home/widgets/pad.dart';
import 'package:hearai/pages/home/widgets/words_item.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/services/words_service.dart';
import 'package:hearai/store.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final WordsService wordsService = WordsService();
  final WordBooksService wordBooksService = WordBooksService();
  final AuthService authService = AuthService();
  List<WordsModel> words = [];
  // 0来自于数组第一元素下标
  int currIndex = 0;
  int level = 1;
  Timer? _timer;
  // n秒执行一次定时任务
  final int _timerInterval = 10;
  int? useMinute;
  bool _isSubscribed = false;
  bool _isFetchingWords = false;
  bool _pollingInProgress = false;
  final AudioManager audioManager = AudioManager();
  final PageController _controller = PageController();
  final storeController = Get.put(StoreController());
  final refreshWordsController = Get.put(RefreshWordsController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isSubscribed) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _isSubscribed = true;
    }
    // 如果单词等级改变，则重新获取单词
    if (refreshWordsController.refreshWords) {
      refreshWordsController.setFalse();
      // 废弃未看的内容，并获取新内容
      _loadNewWords();
    }
  }

  @override
  void dispose() {
    stopPolling();
    if (_isSubscribed) {
      routeObserver.unsubscribe(this);
      _isSubscribed = false;
    }
    super.dispose();
  }

  @override
  void didPushNext() {
    stopPolling();
  }

  @override
  void didPopNext() {
    _handleReturnFromNext();
  }

  Future<void> _handleReturnFromNext() async {
    await _setUserMinute();
    await pollingTask();
    startPolling();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _setUserMinute();
    await _loadWords();
    await pollingTask();
    playWeb(words[0].id);
    startPolling();
  }

  Future<void> _setUserMinute() async {
    if (!mounted) return;
    final profile = await authService.getProfile();
    setState(() {
      useMinute = profile.useMinute;
    });
  }

  Future<void> pollingTask() async {
    if (!mounted) return;
    if (_pollingInProgress) return;
    _pollingInProgress = true;
    try {
      final today = await wordBooksService.getWordBooksToday();

      int maxSeconds = (useMinute ?? 10) * 60;
      if (maxSeconds <= 0) maxSeconds = 600; // 默认10分钟
      storeController.setPercent(
        storeController.percent - _timerInterval / maxSeconds,
      );
      storeController.setShowBadge(today.result > 0);
    } catch (e, st) {
      debugPrint('pollingTask error: $e\n$st');
    } finally {
      _pollingInProgress = false;
    }
  }

  void startPolling() {
    _timer?.cancel(); // 避免重复启动
    _timer = Timer.periodic(Duration(seconds: _timerInterval), (timer) async {
      if (!mounted) return;
      await pollingTask();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _loadWords() async {
    if (!mounted) return;
    final fetchedWords = await wordsService.getWords();
    if (fetchedWords.isEmpty) return;
    setState(() {
      words.addAll(fetchedWords);
    });
  }

  // 废弃未看的内容，并获取新内容
  Future<void> _loadNewWords() async {
    if (!mounted) return;
    final fetchedWords = await wordsService.getWords();
    if (fetchedWords.isEmpty) return;
    setState(() {
      final subWords = words.take(currIndex + 1).toList();
      subWords.addAll(fetchedWords);
      words = subWords;
    });
  }

  // 播放逻辑， false=播放慢速， true=播放常速, null=不播放
  bool? _tryPlay(int wordsId, WidgetType type) {
    if (type == WidgetType.say) {
      if (level == 2) {
        return false;
      } else if (level >= 3) {
        return true;
      }
    } else if (type == WidgetType.listen) {
      if (level == 1) {
        return false;
      } else {
        return true;
      }
    }
    return null;
  }

  void playWeb(int wordsId) {
    bool? playRegular = _tryPlay(words[currIndex].id, words[currIndex].type);
    if (playRegular != null) {
      audioManager.play(
        wordsService.getWordsVoiceUrl(wordsId, slow: !playRegular),
        mimeType: 'audio/ogg',
      );
    }
  }

  void _handlePageChanged(int index) {
    audioManager.stop();

    // 上报记住的句子
    wordsService.rememberWords(words[currIndex].id, level - 1);

    // 初始化当前PageView页
    setState(() {
      level = 1;
      currIndex = index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      playWeb(words[currIndex].id);

      // 自动预加载
      debugPrint(
        'index=${index.toString()}, currIndex=${currIndex.toString()}, wordsId=${words[index].id} words.length=${words.length}, getNewWords=${index >= words.length - 10}',
      );
      if (index >= words.length - 10 && !_isFetchingWords) {
        _isFetchingWords = true;
        _loadWords().then((_) {
          _isFetchingWords = false;
        });
      }
    });
  }

  void _handleBadWords(WordsModel wordsModel) {
    final l = AppLocalizations.of(context);

    HapticsManager.light();

    wordsService
        .badWords(wordsModel.id)
        .then((value) {
          if (!mounted) return;
          showNotify(context: context, title: l.reportSuccess);
          wordsModel.reported = true;
        })
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: _handlePageChanged,
            scrollDirection: Axis.vertical,
            itemCount: words.length,
            itemBuilder: (context, index) {
              return WordsItem(
                key: ValueKey(words[index].id),
                wordsModel: words[index],
                level: level,
                type: words[index].type,
                reported: words[index].reported,
                onTapReport: () {
                  _handleBadWords(words[index]);
                },
              );
            },
          ),
          Positioned(
            bottom: 54,
            left: 40,
            right: 40,
            child: GetBuilder<StoreController>(
              builder: (_) => Pad(
                percent: storeController.percent,
                showBadge: storeController.showBadge,
                onPressCenter: (key) {
                  if (!mounted) return;
                  HapticsManager.light();
                  setState(() {
                    level++;
                  });
                  playWeb(words[currIndex].id);
                },
                onDirection: (dir) {
                  if (dir == "left") {
                    Navigator.pushNamed(context, '/word_book');
                  } else if (dir == "right") {
                    Navigator.pushNamed(context, '/settings');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
