// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get confirm => '好的';

  @override
  String get cancel => '不了';

  @override
  String get confirmDelete => '确定要删除吗？';

  @override
  String confirmDeleteWordBooks(Object word) {
    return '将 $word 从单词本中删除？';
  }

  @override
  String get confirmClean => '确定要清理吗？';

  @override
  String get confirmSignOut => '确定要退出吗？';

  @override
  String get confirmSignOutWithoutWeChat => '未绑定微信，退出后将无法再次登录本账号';

  @override
  String get confirmSignUpGuest => '临时账号只能保持30天，尽快绑定微信哦';

  @override
  String get reportSuccess => '感谢您的贡献';

  @override
  String get todo => '我还没有想好哩...';

  @override
  String get confirmSignInDevice => '确认登录 Chrome 插件？';

  @override
  String get shareText => '忍不住安利一个英语学习 APP';

  @override
  String get noLinkWechat => '还没有绑定微信哦';

  @override
  String get errorUnknown => '哦豁，程序出错了 👀';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get confirm => '好的';

  @override
  String get cancel => '不了';

  @override
  String get confirmDelete => '确定要删除吗？';

  @override
  String confirmDeleteWordBooks(Object word) {
    return '将 $word 从单词本中删除？';
  }

  @override
  String get confirmClean => '确定要清理吗？';

  @override
  String get confirmSignOut => '确定要退出吗？';

  @override
  String get confirmSignOutWithoutWeChat => '未绑定微信，退出后将无法再次登录本账号';

  @override
  String get confirmSignUpGuest => '临时账号只能保持30天，尽快绑定微信哦';

  @override
  String get reportSuccess => '感谢您的贡献';

  @override
  String get todo => '我还没有想好哩...';
}
