import 'package:flutter/material.dart';

final appTextTheme = TextTheme(
  displayLarge: AppTextStyles.display,
  headlineLarge: AppTextStyles.headline,
  titleLarge: AppTextStyles.title,

  bodyLarge: AppTextStyles.body,
  bodyMedium: AppTextStyles.body,
  bodySmall: AppTextStyles.bodySm,

  labelMedium: AppTextStyles.label,
  labelSmall: AppTextStyles.label,
);

class AppTypographyTokens {
  // 字体家族（中英文混排）
  static const fontFamily = 'Lexend';
  static const fallback = ['Noto Sans SC'];

  // 字重
  static const weightRegular = FontWeight.w400;
  static const weightMedium = FontWeight.w500;
  static const weightSemibold = FontWeight.w600;
  static const weightBold = FontWeight.w700;

  // 字号（为学习类场景优化）
  static const sizeXs = 11.0;
  static const sizeSm = 13.0;
  static const sizeMd = 15.0;
  static const sizeLg = 17.0;
  static const sizeXl = 20.0;
  static const sizeXxl = 24.0;
  static const sizeDisplay = 30.0; // 单词大标题

  // 行高（紧凑但可读）
  static const heightTight = 1.2;
  static const heightNormal = 1.32;
  static const heightRelaxed = 1.42;
}

class AppTextStyles {
  // 单词大标题（学习界面的主词）
  static const display = TextStyle(
    fontFamily: AppTypographyTokens.fontFamily,
    fontFamilyFallback: AppTypographyTokens.fallback,
    fontWeight: AppTypographyTokens.weightSemibold,
    fontSize: AppTypographyTokens.sizeDisplay,
    height: AppTypographyTokens.heightTight,
  );

  // 模块标题（例如“今日单词”“听力训练”）
  static const headline = TextStyle(
    fontFamily: AppTypographyTokens.fontFamily,
    fontFamilyFallback: AppTypographyTokens.fallback,
    fontWeight: AppTypographyTokens.weightSemibold,
    fontSize: AppTypographyTokens.sizeXxl,
    height: AppTypographyTokens.heightTight,
  );

  // 分组标题（例如列表标题）
  static const title = TextStyle(
    fontFamily: AppTypographyTokens.fontFamily,
    fontFamilyFallback: AppTypographyTokens.fallback,
    fontWeight: AppTypographyTokens.weightMedium,
    fontSize: AppTypographyTokens.sizeXl,
    height: AppTypographyTokens.heightNormal,
  );

  // 正文（释义、例句主文本）
  static const body = TextStyle(
    fontFamily: AppTypographyTokens.fontFamily,
    fontFamilyFallback: AppTypographyTokens.fallback,
    fontWeight: AppTypographyTokens.weightRegular,
    fontSize: AppTypographyTokens.sizeMd,
    height: AppTypographyTokens.heightRelaxed,
  );

  // 说明文字（例句翻译、提示、次级文本）
  static const bodySm = TextStyle(
    fontFamily: AppTypographyTokens.fontFamily,
    fontFamilyFallback: AppTypographyTokens.fallback,
    fontWeight: AppTypographyTokens.weightRegular,
    fontSize: AppTypographyTokens.sizeSm,
    height: AppTypographyTokens.heightRelaxed,
  );

  // 标签按钮（Tab、Chip、按钮文字）
  static const label = TextStyle(
    fontFamily: AppTypographyTokens.fontFamily,
    fontFamilyFallback: AppTypographyTokens.fallback,
    fontWeight: AppTypographyTokens.weightMedium,
    fontSize: AppTypographyTokens.sizeSm,
    height: AppTypographyTokens.heightNormal,
  );
}
