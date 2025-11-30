import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/app.dart';
import 'package:hearai/models/words.dart';
import 'package:hearai/pages/home/widgets/pad.dart';
import 'package:hearai/pages/home/widgets/words_item.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/services/words_service.dart';
import 'package:hearai/store.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final WordsService wordsService = WordsService();
  final WordBooksService wordBooksService = WordBooksService();
  final AuthService authService = AuthService();
  final AudioManager audioManager = AudioManager();
  List<WordsModel> words = [];
  // 0来自于数组第一元素下标
  int currIndex = 0;
  int level = 1;
  bool showBadge = false;
  Timer? _timer;
  // n秒执行一次定时任务
  final int _timerInterval = 10;
  int? useMinute;
  bool _isSubscribed = false;
  bool _isFetchingWords = false;
  bool _pollingInProgress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isSubscribed) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _isSubscribed = true;
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
    await _getNewWords();
    await pollingTask();
    startPolling();
    play(index: currIndex, slow: false);
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
      final store = Provider.of<Store>(context, listen: false);
      final today = await wordBooksService.getWordBooksToday();

      int maxSeconds = (useMinute ?? 10) * 60;
      if (maxSeconds <= 0) maxSeconds = 600; // 默认10分钟
      store.updatePercent(store.percent - _timerInterval / maxSeconds);

      setState(() {
        showBadge = today.result > 0;
      });
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

  Future<void> _getNewWords() async {
    if (!mounted) return;
    final fetchedWords = await wordsService.getWords();
    if (fetchedWords.isEmpty) return;
    setState(() {
      words.addAll(fetchedWords);
    });
  }

  void play({int index = 0, bool slow = false}) {
    // 因为卡顿，所以延迟400ms保持流畅
    Future.delayed(Duration(milliseconds: 400), () {
      // 因为延迟做的边界检查
      if (index < 0 || index >= words.length) return;
      audioManager.play(
        wordsService.getWordsVoiceUrl(words[index].id, slow: slow),
        mimeType: 'audio/ogg',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);

    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              // 第一次播放常速
              play(index: index, slow: false);
              setState(() {
                level = 1;
                currIndex = index;
              });
              // 自动预加载
              debugPrint(
                'index=${index.toString()}, words.length=${words.length}, getNewWords=${index >= words.length - 10}',
              );
              if (index >= words.length - 10 && !_isFetchingWords) {
                _isFetchingWords = true;
                _getNewWords().then((_) {
                  _isFetchingWords = false;
                });
              }
            },
            scrollDirection: Axis.vertical,
            itemCount: words.length,
            itemBuilder: (context, index) {
              return WordsItem(words: words[index], level: level);
            },
          ),
          Positioned(
            bottom: 54,
            left: 40,
            right: 40,
            child: Pad(
              percent: store.percent,
              showBadge: showBadge,
              onPressCenter: (key) {
                if (!mounted) return;
                HapticFeedback.lightImpact();
                // 后续播放慢速
                play(index: currIndex, slow: true);
                setState(() {
                  level++;
                });
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
        ],
      ),
    );
  }
}
