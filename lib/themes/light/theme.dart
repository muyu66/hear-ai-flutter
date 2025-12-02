import 'package:flutter/material.dart';
import 'package:hearai/themes/light/color_schemes.dart';
import 'package:hearai/themes/light/typography.dart';

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  final bool allowSnapshotting;
  final bool allowEnterRouteSnapshotting;
  final Color? backgroundColor;

  const NoAnimationPageTransitionsBuilder({
    this.allowSnapshotting = true,
    this.allowEnterRouteSnapshotting = true,
    this.backgroundColor,
  });

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 👇 直接返回 child，不加任何动画
    return child;
  }
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    brightness: Brightness.light,
    textTheme: appTextTheme,
    splashColor: lightColorScheme.primaryContainer, // 水波纹
    highlightColor: lightColorScheme.primaryContainer, // 按下高亮
    hoverColor: lightColorScheme.primaryContainer, // 鼠标悬停（桌面/WEB）
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
        TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
        TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
      },
    ),
  );
}
