import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.light(
  primary: const Color(0xFFFF7A00), // 更明快的橘
  onPrimary: Colors.white,
  primaryContainer: const Color(0xFFFFE5CC), // 柔和浅橘
  onPrimaryContainer: const Color(0xFF4A2600),

  secondary: const Color(0xFF6F6F6F), // 暖中性灰（更简洁）
  onSecondary: Colors.white,
  secondaryContainer: const Color(0xFFF2F2F2),
  onSecondaryContainer: const Color(0xFF3B3B3B),

  tertiary: const Color(0xFF2E8B57), // 柔和暖绿（成功/掌握）
  onTertiary: Colors.white,
  tertiaryContainer: const Color(0xFFCFF6E3),
  onTertiaryContainer: const Color(0xFF063421),

  error: const Color(0xFFE53935), // 更鲜明但轻快的红
  onError: Colors.white,
  errorContainer: const Color(0xFFFFDAD4),
  onErrorContainer: const Color(0xFF410001),

  surface: Colors.white,
  onSurface: const Color(0xFF1A1A1A),
  surfaceContainerHighest: const Color(0xFFF5F5F5), // 暖浅灰，轻量、通透
  onSurfaceVariant: const Color(0xFF6C6C6C),

  outline: const Color(0xFFE0E0E0), // 简化边框色（非常轻）
  outlineVariant: const Color(0xFFF0EFEF),

  shadow: const Color(0x33000000),
  scrim: const Color(0x33000000),

  inverseSurface: const Color(0xFF2E2E2E),
  onInverseSurface: const Color(0xFFF6F6F6),
  inversePrimary: const Color(0xFFFFB877), // 更暖的浅橘高亮'
);

// 扩展 ColorScheme，增加业务自定义颜色
extension Extension on ColorScheme {
  Color get listHighlightText => const Color(0xFFE0E0E0);
  Color get listHighlight => const Color(0xFFFFB877);
}
