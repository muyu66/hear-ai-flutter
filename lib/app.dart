import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/pages/home/home_page.dart';
import 'package:hearai/pages/settings/settings_page.dart';
import 'package:hearai/pages/sign_in/sign_in_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hearai/pages/word_book/word_book_page.dart';
import 'package:hearai/themes/light/theme.dart';
import 'package:hearai/tools/audio_manager.dart';

// 路由监听
class _AppRouteObserver extends NavigatorObserver {
  final VoidCallback onPush;

  _AppRouteObserver({required this.onPush});

  @override
  void didPush(Route route, Route? previousRoute) {
    onPush();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HearAI',
      theme: buildLightTheme(),
      routes: {
        '/': (context) => const HomePage(),
        '/sign_in': (context) => const SignInPage(),
        '/settings': (context) => const SettingsPage(),
        '/word_book': (context) => WordBookPage(),
      },
      initialRoute: '/',
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
        _AppRouteObserver(
          onPush: () {
            AudioManager().stop(); // 全局停止播放
          },
        ),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh')],
    );
  }
}
