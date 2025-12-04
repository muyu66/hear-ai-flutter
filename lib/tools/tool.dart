import 'dart:ui';

Locale parseLocale(String raw) {
  switch (raw) {
    case 'zh_CN':
      return const Locale('zh', 'CN');
    case 'zh_TW':
      return const Locale('zh', 'TW');
    default:
      return const Locale('en', 'US');
  }
}
