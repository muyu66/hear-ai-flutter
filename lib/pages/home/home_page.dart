import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hearai/app.dart';
import 'package:hearai/models/words.dart';
import 'package:hearai/pages/home/widgets/pad.dart';
import 'package:hearai/pages/home/widgets/words_item.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/services/my_word_service.dart';
import 'package:hearai/services/sentence_service.dart';
import 'package:hearai/store.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';
import 'package:hearai/tools/record_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final SentenceService sentenceService = SentenceService();
  final MyWordService myWordService = MyWordService();
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
  // =null 说明不需要记录
  DateTime? _lastThinkingTime;
  // 防止快速点击
  int _lastClickTime = 0; // 上次点击时间（毫秒）

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
    play(words[0].id);
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
      final now = await myWordService.getNow();

      int maxSeconds = (useMinute ?? 10) * 60;
      if (maxSeconds <= 0) maxSeconds = 600; // 默认10分钟
      storeController.setPercent(
        storeController.percent - _timerInterval / maxSeconds,
      );
      storeController.setShowBadge(now.result > 0);
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
    final fetchedWords = await sentenceService.getSentences();
    if (fetchedWords.isEmpty) return;
    setState(() {
      words.addAll(fetchedWords);
    });
  }

  // 废弃未看的内容，并获取新内容
  Future<void> _loadNewWords() async {
    if (!mounted) return;
    final fetchedWords = await sentenceService.getSentences();
    if (fetchedWords.isEmpty) return;
    setState(() {
      final subWords = words.take(currIndex + 1).toList();
      subWords.addAll(fetchedWords);
      words = subWords;
    });
  }

  // 点击Pad中间按钮的逻辑
  ({bool play, bool playSlow, bool record, bool playRecord, bool thinking})
  _onTapPadCenter(int wordsId, WidgetType type) {
    if (type == WidgetType.say) {
      switch (level) {
        case 1:
          // 引导用户自己发音
          storeController.setPadIcon(FontAwesomeIcons.solidCirclePlay);
          return (
            play: false,
            playSlow: false,
            record: false,
            playRecord: false,
            thinking: false,
          );
        case 2:
          // 引导用户录音
          storeController.setPadIcon(FontAwesomeIcons.solidCircleStop);
          return (
            play: false,
            playSlow: false,
            record: true,
            playRecord: false,
            thinking: true,
          );
        case 3:
          // 引导用户核对
          storeController.setPadIcon(FontAwesomeIcons.solidCircleCheck);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: true,
            thinking: false,
          );
        case 4:
          // 引导用户核对
          storeController.setPadIcon(FontAwesomeIcons.solidCircleCheck);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: true,
            thinking: false,
          );
        default:
          storeController.setPadIcon(FontAwesomeIcons.solidCirclePlay);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: false,
            thinking: false,
          );
      }
    } else if (type == WidgetType.listen) {
      switch (level) {
        case 1:
          // 引导用户说出来
          storeController.setPadIcon(FontAwesomeIcons.solidCircleQuestion);
          return (
            play: true,
            playSlow: false,
            record: false,
            playRecord: false,
            thinking: false,
          );
        case <= 4:
          // 引导用户想英文
          storeController.setPadIcon(FontAwesomeIcons.solidCirclePlay);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: false,
            thinking: true,
          );
        case 5:
          // 引导用户想中文
          storeController.setPadIcon(FontAwesomeIcons.solidCirclePlay);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: false,
            thinking: false,
          );
        case >= 6:
          // 引导用户核对
          storeController.setPadIcon(FontAwesomeIcons.solidCircleCheck);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: false,
            thinking: false,
          );
        default:
          storeController.setPadIcon(FontAwesomeIcons.solidCirclePlay);
          return (
            play: true,
            playSlow: true,
            record: false,
            playRecord: false,
            thinking: false,
          );
      }
    } else {
      return (
        play: false,
        playSlow: false,
        record: false,
        playRecord: false,
        thinking: false,
      );
    }
  }

  Future<void> play(int wordsId) async {
    final op = _onTapPadCenter(words[currIndex].id, words[currIndex].type);

    if (op.thinking) {
      setState(() {
        _lastThinkingTime = DateTime.now();
      });
    }

    if (op.play) {
      await audioManager.play(
        sentenceService.getPronunciationUrl(wordsId, slow: op.playSlow),
        mimeType: 'audio/ogg',
      );
    }

    if (op.record) {
      await audioManager.stop();
      await RecordManager().start();
    }

    if (!op.record && op.playRecord) {
      final recordFilePath = await RecordManager().stop();
      if (recordFilePath != null) {
        await audioManager.playFile(recordFilePath);
      }
    }
  }

  void _handlePageChanged(int index) {
    audioManager.stop();

    final now = DateTime.now();

    // 上报记住的句子
    sentenceService.remember(
      sentenceId: words[currIndex].id,
      hintCount: level - 1,
      // 配合 _onTapPadCenter 表示只要点击PAD后才开始计时，忽略一些不喜欢就翻页的场景
      thinkingTime: _lastThinkingTime == null
          ? 0
          : now.millisecondsSinceEpoch -
                _lastThinkingTime!.millisecondsSinceEpoch,
    );

    // 初始化当前PageView页
    setState(() {
      level = 1;
      currIndex = index;
      _lastThinkingTime = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      play(words[currIndex].id);

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
    HapticsManager.light();

    sentenceService
        .bad(wordsModel.id)
        .then((value) {
          if (!mounted) return;
          showNotify(context: context, title: "reportSuccess".tr);
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
                icon: storeController.padIcon,
                percent: storeController.percent,
                showBadge: storeController.showBadge,
                onPressCenter: (key) async {
                  if (!mounted) return;

                  // 防止快速点击
                  final int now = DateTime.now().millisecondsSinceEpoch;
                  if (now - _lastClickTime < 100) {
                    // 小于 100ms，忽略点击
                    return;
                  }
                  _lastClickTime = now;

                  HapticsManager.light();
                  setState(() {
                    level++;
                  });
                  await play(words[currIndex].id);
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
