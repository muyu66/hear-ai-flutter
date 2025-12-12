import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hearai/l10n/app_translations.dart';
import 'package:hearai/pages/home/home_page.dart';
import 'package:hearai/pages/settings/settings_page.dart';
import 'package:hearai/pages/sign_in/sign_in_page.dart';
import 'package:hearai/pages/sign_in/sign_up_page_1.dart';
import 'package:hearai/pages/sign_in/sign_up_page_2.dart';
import 'package:hearai/pages/sign_in/sign_up_page_3.dart';
import 'package:hearai/pages/splash/splash.dart';
import 'package:hearai/pages/word_book/word_book_page.dart';
import 'package:hearai/themes/light/theme.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:hearai/tools/tool.dart';

// 全局路由监听
class _AppRouteObserver extends NavigatorObserver {
  _AppRouteObserver();

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) async {
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
    final lang = GetStorage().read<String>('language') ?? 'zh_CN';

    return GetMaterialApp(
      translations: AppTranslations(),
      locale: parseLocale(lang),
      fallbackLocale: const Locale('zh', 'CN'),
      debugShowCheckedModeBanner: false,
      title: 'HearAI',
      theme: buildLightTheme(),
      navigatorKey: navigatorKey,
      routes: {
        '/splash': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/sign-in': (context) => const SignInPage(),
        '/settings': (context) => const SettingsPage(),
        '/word-book': (context) => const WordBookPage(),
        '/sign-up/1': (context) => const SignUpPage1(),
        '/sign-up/2': (context) => const SignUpPage2(),
        '/sign-up/3': (context) => const SignUpPage3(),
      },
      initialRoute: '/splash',
      navigatorObservers: [routeObserver, _AppRouteObserver()],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh')],
    );
  }
}
