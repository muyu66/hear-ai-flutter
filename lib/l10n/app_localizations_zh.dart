// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get confirm => '当然';

  @override
  String get cancel => '不';

  @override
  String get confirmDelete => '确定要删除吗？';

  @override
  String confirmDeleteWordBooks(Object word) {
    return '将 $word 从单词本中删除？';
  }

  @override
  String get confirmClean => '确定要清理吗？';

  @override
  String get confirmSignOut => '如未绑定微信，退出后将无法再次登录本账号。';
}
