import 'package:flutter/material.dart';

final appTextTheme = TextTheme(
  displayLarge: AppTextStyles.displayLg,
  displayMedium: AppTextStyles.display,
  displaySmall: AppTextStyles.displaySm,

  bodyLarge: AppTextStyles.body,
  bodyMedium: AppTextStyles.body,
  bodySmall: AppTextStyles.bodySm,

  labelLarge: AppTextStyles.labelLg,
  labelMedium: AppTextStyles.label,
  labelSmall: AppTextStyles.labelSm,

  titleLarge: AppTextStyles.titleLg,
  titleMedium: AppTextStyles.title,
  titleSmall: AppTextStyles.titleSm,

  headlineLarge: AppTextStyles.headlineLg,
  headlineMedium: AppTextStyles.headline,
  headlineSmall: AppTextStyles.headlineSm,
);

class AppTypographyTokens {
  // 字体家族（中英文混排）
  static const fontFamilyEnText = 'EnText';
  static const fontFamilyZhText = 'ZhText';
  static const fontFamilyZhUI = 'ZhUI';
  static const fontFamilySplashUI = 'SplashUI';

  // 字重
  static const weight400 = FontWeight.w400;
  static const weight500 = FontWeight.w500;
  static const weight600 = FontWeight.w600;
  static const weight700 = FontWeight.w700;

  // 字号
  static const size12 = 12.0;
  static const size14 = 14.0;
  static const size16 = 16.0;
  static const size18 = 18.0;
  static const size20 = 20.0;
  static const size22 = 22.0;
  static const size24 = 24.0;
  static const size30 = 30.0; // 单词大标题
  static const size42 = 42.0;

  // 行高（紧凑但可读）
  static const heightTight = 1.2;
  static const heightNormal = 1.32;
  static const heightRelaxed = 1.42;
}

class AppTextStyles {
  // 单词大标题（学习界面的主词）
  static const displayLg = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size42,
    height: AppTypographyTokens.heightTight,
  );

  static const display = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size30,
    height: AppTypographyTokens.heightTight,
  );

  static const displaySm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size24,
    height: AppTypographyTokens.heightTight,
  );

  // 模块标题（例如“今日单词”“听力训练”）
  static const headlineLg = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size30,
    height: AppTypographyTokens.heightTight,
  );

  static const headline = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size24,
    height: AppTypographyTokens.heightTight,
  );

  static const headlineSm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size24,
    height: AppTypographyTokens.heightTight,
  );

  // 分组标题（例如列表标题）
  static const titleLg = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size24,
    height: AppTypographyTokens.heightNormal,
  );

  static const title = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size22,
    height: AppTypographyTokens.heightNormal,
  );

  static const titleSm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight600,
    fontSize: AppTypographyTokens.size18,
    height: AppTypographyTokens.heightNormal,
  );

  // 正文（释义、例句主文本）
  static const bodyLarge = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight400,
    fontSize: AppTypographyTokens.size16,
    height: AppTypographyTokens.heightNormal,
  );

  // 正文（释义、例句主文本）
  static const body = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight400,
    fontSize: AppTypographyTokens.size14,
    height: AppTypographyTokens.heightNormal,
  );

  // 说明文字（例句翻译、提示、次级文本）
  static const bodySm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight400,
    fontSize: AppTypographyTokens.size12,
    height: AppTypographyTokens.heightNormal,
  );

  // 标签按钮（Tab、Chip、按钮文字）
  static const labelLg = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight500,
    fontSize: AppTypographyTokens.size18,
    height: AppTypographyTokens.heightNormal,
  );

  static const label = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight500,
    fontSize: AppTypographyTokens.size14,
    height: AppTypographyTokens.heightNormal,
  );

  static const labelSm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyZhUI,
    fontWeight: AppTypographyTokens.weight500,
    fontSize: AppTypographyTokens.size12,
    height: AppTypographyTokens.heightNormal,
  );

  static const splashText = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilySplashUI,
    fontSize: AppTypographyTokens.size42,
    fontWeight: AppTypographyTokens.weight600,
    height: AppTypographyTokens.heightTight,
  );

  // 印刷体
  static const printTextLg = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyEnText,
    fontFamilyFallback: [AppTypographyTokens.fontFamilyZhText],
    fontWeight: AppTypographyTokens.weight400,
    fontSize: AppTypographyTokens.size22,
    height: AppTypographyTokens.heightRelaxed,
  );

  // 印刷体
  static const printText = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyEnText,
    fontFamilyFallback: [AppTypographyTokens.fontFamilyZhText],
    fontWeight: AppTypographyTokens.weight400,
    fontSize: AppTypographyTokens.size18,
    height: AppTypographyTokens.heightRelaxed,
  );

  // 印刷体
  static const printTextSm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamilyEnText,
    fontFamilyFallback: [AppTypographyTokens.fontFamilyZhText],
    fontWeight: AppTypographyTokens.weight400,
    fontSize: AppTypographyTokens.size16,
    height: AppTypographyTokens.heightRelaxed,
  );
}

extension Extension on TextTheme {
  TextStyle get splashText => AppTextStyles.splashText;
  TextStyle get printTextLg => AppTextStyles.printTextLg;
  TextStyle get printText => AppTextStyles.printText;
  TextStyle get printTextSm => AppTextStyles.printTextSm;
}
