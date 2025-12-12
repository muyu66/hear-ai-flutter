import 'package:get/get.dart';
import 'package:hearai/l10n/en.dart';
import 'package:hearai/l10n/zh_cn.dart';
import 'package:hearai/l10n/zh_tw.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': zhCn,
    'en': en,
    'zh_TW': zhTw,
  };
}
