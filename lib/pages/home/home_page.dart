import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/app.dart';
import 'package:hearai/models/sign_in_req.dart';
import 'package:hearai/models/words.dart';
import 'package:hearai/pages/home/widgets/pad.dart';
import 'package:hearai/pages/home/widgets/words_item.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/services/word_books_service.dart';
import 'package:hearai/services/words_service.dart';
import 'package:hearai/store.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/key_manager.dart';
import 'package:hearai/tools/secure_storage.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    stopPolling();
  }

  @override
  void didPopNext() {
    _setUserMinute();
    pollingTask();
    startPolling();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initAsync();
    startPolling();
    super.initState();
  }

  Future<void> _initAsync() async {
    await _onSignIn();
    await _getWords();
    await _setUserMinute();
    await pollingTask();
    play(index: currIndex, slow: false);
  }

  Future<void> _setUserMinute() async {
    final profile = await authService.getProfile();
    if (!mounted) return;
    setState(() {
      useMinute = profile.useMinute;
    });
  }

  Future<void> pollingTask() async {
    final store = Provider.of<Store>(context, listen: false);
    final today = await wordBooksService.getWordBooksToday();

    if (mounted) {
      setState(() {
        // 获取今天需要复习的单词量
        showBadge = today.result > 0;

        // 计算Pad颜色百分比
        int maxSeconds = (useMinute ?? 10) * 60;
        store.updatePercent(store.percent - _timerInterval / maxSeconds);
      });
    }
  }

  void startPolling() {
    _timer?.cancel(); // 避免重复启动
    _timer = Timer.periodic(Duration(seconds: _timerInterval), (timer) async {
      pollingTask();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _onSignIn() async {
    try {
      final existPrivateKey = await SecureStorageUtils.has('privateKeyBase64');
      if (!mounted) return;
      if (!existPrivateKey) {
        debugPrint("未发现 privateKey, 强制返回登录页");
        Navigator.pushReplacementNamed(context, '/sign_in');
        return;
      }

      final privateKeyBase64 = await SecureStorageUtils.read(
        'privateKeyBase64',
      );
      if (privateKeyBase64 == null) {
        throw Exception('No private key found');
      }
      final privateKey = base64Decode(privateKeyBase64);

      final privateHash = KeyManager.sha256(privateKey);
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final sig = KeyManager.sign(privateKey, timestamp);
      final sigBase64 = base64Encode(sig);

      final api = await AuthService().signIn(
        SignInReq(
          account: privateHash,
          signatureBase64: sigBase64,
          timestamp: timestamp,
        ),
      );

      AuthStore().setToken(api.accessToken);
    } catch (e) {
      debugPrint('SignIn failed: $e');
    }
  }

  Future<void> _getWords() async {
    final fetchedWords = await wordsService.getWords(0);
    // 防止异步回调时 widget 已经被销毁
    if (!mounted) return;
    setState(() {
      words = fetchedWords;
    });
  }

  void play({int index = 0, bool slow = false}) {
    Future.delayed(Duration(milliseconds: 400), () {
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
            onPageChanged: (index) => {
              // 第一次播放常速
              play(index: index, slow: false),
              setState(() {
                level = 1;
                currIndex = index;
              }),
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
