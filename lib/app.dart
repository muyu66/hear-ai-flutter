import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/l10n/app_translations.dart';
import 'package:hearai/pages/home/home_page.dart';
import 'package:hearai/pages/settings/settings_page.dart';
import 'package:hearai/pages/sign_in/sign_in_page.dart';
import 'package:hearai/pages/splash/splash.dart';
import 'package:hearai/pages/word_book/word_book_page.dart';
import 'package:hearai/themes/light/theme.dart';
import 'package:hearai/tools/audio_manager.dart';

// 全局路由监听
class _AppRouteObserver extends NavigatorObserver {
  _AppRouteObserver();

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) async {
    debugPrint("当前route = ${topRoute.settings.name}");
    AudioManager().stop();
  }
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: Locale('zh', 'CN'),
      fallbackLocale: Locale('zh', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'HearAI',
      theme: buildLightTheme(),
      navigatorKey: navigatorKey,
      routes: {
        '/splash': (context) => const SplashPage(enableAnimation: false),
        '/home': (context) => const HomePage(),
        '/sign_in': (context) => const SignInPage(),
        '/settings': (context) => const SettingsPage(),
        '/word_book': (context) => const WordBookPage(),
      },
      initialRoute: '/splash',
      navigatorObservers: [routeObserver, _AppRouteObserver()],
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
