import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/user_profile.dart';
import 'package:hearai/pages/settings/widgets/clickable_tile.dart';
import 'package:hearai/pages/settings/widgets/dropdown_selection_tile.dart';
import 'package:hearai/pages/settings/widgets/editable_text_page.dart';
import 'package:hearai/pages/settings/widgets/remember_selection_page.dart';
import 'package:hearai/pages/settings/widgets/scan_qr.dart';
import 'package:hearai/pages/settings/widgets/section_tile.dart';
import 'package:hearai/pages/settings/widgets/simple_tile.dart';
import 'package:hearai/pages/settings/widgets/slider_tile.dart';
import 'package:hearai/pages/settings/widgets/switch_tile_tile.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/store.dart';
import 'package:hearai/tools/auth.dart';
import 'package:hearai/tools/cache_manager.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/haptics_manager.dart';
import 'package:hearai/tools/save_img.dart';
import 'package:hearai/tools/secure_storage.dart';
import 'package:hearai/tools/share.dart';
import 'package:hearai/widgets/wechat_login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_kit/wechat_kit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _cacheSizeText = '0 B';
  CacheManager cacheManager = CacheManager();
  AuthService authService = AuthService();
  UserProfile _userProfile = UserProfile(
    nickname: "",
    avatar: null,
    rememberMethod: "sm2",
    wordsLevel: 3,
    useMinute: 5,
    multiSpeaker: true,
    isWechat: false,
    sayRatio: 20,
    targetRetention: 90,
  );
  final storeController = Get.put(StoreController());
  final refreshWordsController = Get.put(RefreshWordsController());

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
    _loadProfile();
  }

  Future<void> _loadCacheSize() async {
    final size = await CacheManager().getCacheSize();
    if (mounted) {
      setState(() {
        _cacheSizeText = CacheManager.formatSize(size);
      });
    }
  }

  Future<void> _loadProfile() async {
    try {
      final userProfile = await authService.getProfile();
      setState(() {
        _userProfile = userProfile;
      });
    } catch (e) {
      _showErrorSnackBar('加载设置失败: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    final c = Theme.of(context).colorScheme;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: c.error),
      );
    }
  }

  Future<void> _signOut() async {
    HapticsManager.light();
    await SecureStorageUtils.delete("privateKeyBase64");
    AuthStore().clearToken();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/sign_in');
    }
  }

  void _updateUseMinute(int value) {
    if (!mounted) return;
    HapticsManager.light();
    authService.updateProfile(useMinute: value).then((_) {
      _loadProfile();
      storeController.resetPercent();
    });
  }

  void _updateWordsLevel(int value) {
    if (!mounted) return;
    HapticsManager.light();
    authService.updateProfile(wordsLevel: value).then((_) {
      setState(() {
        _userProfile.wordsLevel = value;
      });
      refreshWordsController.setTrue();
    });
  }

  void _updateSayRatio(int value) {
    if (!mounted) return;
    HapticsManager.light();
    authService.updateProfile(sayRatio: value).then((_) {
      setState(() {
        _userProfile.sayRatio = value;
      });
      refreshWordsController.setTrue();
    });
  }

  void _linkWechat(String code) {
    AuthService()
        .linkWechat(code)
        .then((_) {
          if (!mounted) return;
          showClassicNotify(
            context: context,
            title: "绑定成功",
            dialogType: DialogType.success,
          );
          _loadProfile();
        })
        .catchError((err) {
          if (!mounted) return;
          debugPrint(err);
          showClassicNotify(
            context: context,
            title: "绑定失败",
            dialogType: DialogType.error,
          );
        });
  }

  void _handleScan(String result) {
    final l = AppLocalizations.of(context);

    debugPrint("扫码结果: $result");
    String deviceSessionId = result.split('://')[1];
    showConfirm(
      context: context,
      title: l.confirmSignInDevice,
      dialogType: DialogType.info,
      onConfirm: () {
        HapticsManager.light();
        authCreateDeviceSession(deviceSessionId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),

          // 账号设置
          SectionTitle(
            title: '账号',
            children: [
              ClickableTile(
                title: '昵称',
                icon: FontAwesomeIcons.lightbulb,
                subtitle: _userProfile.nickname,
                onTap: () async {
                  HapticsManager.light();
                  final String? newValue = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditableTextPage(
                        title: "阁下尊姓大名？",
                        value: _userProfile.nickname,
                        validation: (value) {
                          if (value.length > 20 || value.isEmpty) {
                            return false;
                          }
                          if (!RegExp(
                            r'^[\u4e00-\u9fa5_a-zA-Z0-9]+$',
                          ).hasMatch(value)) {
                            return false;
                          }
                          return true;
                        },
                      ),
                    ),
                  );
                  if (newValue != null &&
                      newValue.isNotEmpty &&
                      newValue != _userProfile.nickname) {
                    await authService.updateProfile(nickname: newValue);
                    setState(() {
                      _userProfile.nickname = newValue;
                    });
                  }
                },
              ),
              // 微信绑定
              _userProfile.isWechat
                  ? SimpleTile(title: '已绑定微信', icon: Icons.wechat)
                  : WeChatButton(
                      builder: (context, loading, support, triggerLogin) {
                        return ClickableTile(
                          title: '绑定微信',
                          icon: Icons.wechat,
                          onTap: () async {
                            HapticsManager.light();
                            await triggerLogin();
                          },
                        );
                      },
                      onCode: (code) {
                        HapticsManager.light();
                        _linkWechat(code);
                      },
                      onError: () {
                        showClassicNotify(
                          context: context,
                          title: "绑定失败",
                          dialogType: DialogType.error,
                        );
                      },
                    ),
              // 扫码登录设备
              ClickableTile(
                title: '扫码登录设备',
                icon: Icons.qr_code_scanner,
                onTap: () async {
                  HapticsManager.light();
                  final String? result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScanQr()),
                  );
                  if (result != null) {
                    _handleScan(result);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 学习设置
          SectionTitle(
            title: '学习',
            children: [
              ClickableTile(
                title: '记忆模型',
                icon: FontAwesomeIcons.lightbulb,
                subtitle: rememberMethodList
                    .firstWhereOrNull(
                      (item) => item.value == _userProfile.rememberMethod,
                    )
                    ?.title,
                onTap: () async {
                  HapticsManager.light();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RememberSelectionPage(
                        rememberMethod: _userProfile.rememberMethod,
                        onTap: (String value) async {
                          HapticsManager.light();
                          await authService.updateProfile(
                            rememberMethod: value,
                          );
                          setState(() {
                            _userProfile.rememberMethod = value;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              DropdownSelectionTile<int>(
                title: '难度等级',
                value: _userProfile.wordsLevel,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('菜鸟 🥚')),
                  DropdownMenuItem(value: 2, child: Text('半熟萌新')),
                  DropdownMenuItem(value: 3, child: Text('适中 🍳')),
                  DropdownMenuItem(value: 4, child: Text('老鸟探险者')),
                  DropdownMenuItem(value: 5, child: Text('神仙打架')),
                ],
                onChanged: (value) async {
                  if (value == null) return;
                  _updateWordsLevel(value);
                },
              ),
              DropdownSelectionTile<int>(
                title: '每日学习时间',
                value: _userProfile.useMinute,
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3分钟')),
                  DropdownMenuItem(value: 5, child: Text('5分钟')),
                  DropdownMenuItem(value: 10, child: Text('10分钟 😛')),
                  DropdownMenuItem(value: 20, child: Text('20分钟')),
                  DropdownMenuItem(value: 30, child: Text('30分钟')),
                  DropdownMenuItem(value: 60, child: Text('1小时')),
                  DropdownMenuItem(value: 120, child: Text('2小时')),
                ],
                onChanged: (value) async {
                  if (value == null) return;
                  _updateUseMinute(value);
                },
              ),
              SwitchTile(
                title: '多种发音源',
                value: _userProfile.multiSpeaker,
                onChanged: (value) async {
                  HapticsManager.light();
                  await authService.updateProfile(multiSpeaker: value);
                  setState(() {
                    _userProfile.multiSpeaker = value;
                  });
                },
              ),
              SliderTile(
                title: '口语推送占比',
                value: _userProfile.sayRatio,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _userProfile.sayRatio = value;
                  });
                },
                onChangeEnd: (value) {
                  _updateSayRatio(value);
                },
              ),
              DropdownSelectionTile<int>(
                title: '学习态度',
                value: _userProfile.targetRetention,
                items: const [
                  DropdownMenuItem(value: 80, child: Text('Whatever 🤪')),
                  DropdownMenuItem(value: 85, child: Text('试试看')),
                  DropdownMenuItem(value: 90, child: Text('稳扎稳打 ✊')),
                  DropdownMenuItem(value: 95, child: Text('滴水不漏')),
                ],
                onChanged: (value) async {
                  if (value == null) return;
                  HapticsManager.light();
                  await authService.updateProfile(targetRetention: value);
                  setState(() {
                    _userProfile.targetRetention = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 通用设置
          SectionTitle(
            title: '通用',
            children: [
              Obx(() {
                return SwitchTile(
                  title: '触觉反馈',
                  value: HapticsManager.enabled,
                  onChanged: (value) async {
                    HapticsManager.light();
                    HapticsManager.setEnabled(value);
                  },
                );
              }),
              ClickableTile(
                title: '清理缓存',
                subtitle: _cacheSizeText,
                icon: FontAwesomeIcons.trash,
                onTap: () {
                  HapticsManager.light();
                  showConfirm(
                    context: context,
                    title: l.confirmClean,
                    dialogType: DialogType.warning,
                    onConfirm: () {
                      HapticsManager.light();
                      cacheManager.clearCache().then((_) {
                        _loadCacheSize();
                      });
                    },
                  );
                },
              ),
              ClickableTile(
                title: '捐赠',
                icon: FontAwesomeIcons.handHoldingHeart,
                onTap: () async {
                  HapticsManager.light();
                  try {
                    await launchUrl(
                      Uri.parse(
                        'https://muyu66.github.io/hear-ai-website/#contact',
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('无法打开浏览器：${e.toString()}')),
                    );
                  }
                },
              ),
              ClickableTile(
                title: '前往 HearAI 网站',
                icon: FontAwesomeIcons.globe,
                onTap: () async {
                  HapticsManager.light();
                  try {
                    await launchUrl(
                      Uri.parse('https://muyu66.github.io/hear-ai-website'),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('无法打开浏览器：${e.toString()}')),
                    );
                  }
                },
              ),
              ClickableTile(
                title: '退出账号',
                icon: FontAwesomeIcons.arrowRightFromBracket,
                onTap: () {
                  HapticsManager.light();
                  showConfirm(
                    context: context,
                    title: _userProfile.isWechat
                        ? l.confirmSignOut
                        : l.confirmSignOutWithoutWeChat,
                    dialogType: DialogType.warning,
                    onConfirm: () {
                      HapticsManager.light();
                      _signOut();
                    },
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 42),
          _buildCopyright(context),
          const SizedBox(height: 52),
        ],
      ),
    );
  }

  // Header 区域
  Widget _buildHeader(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    const String inviteUrl = 'https://yourapp.com/invite?user=123';

    Future<void> onTapWechat(Uint8List? bytes) async {
      if (!context.mounted) return;
      if (_userProfile.isWechat) {
        HapticsManager.light();
        if (bytes == null) {
          showClassicNotify(
            context: context,
            title: l.errorUnknown,
            dialogType: DialogType.error,
          );
          return;
        }
        await WechatKitPlatform.instance.shareImage(
          scene: WechatScene.kSession,
          imageData: bytes,
        );
      } else {
        HapticsManager.light();
        showNotify(context: context, title: l.noLinkWechat);
      }
    }

    Future<void> onTapSave(Uint8List? bytes) async {
      HapticsManager.light();
      if (bytes == null) {
        showClassicNotify(
          context: context,
          title: l.errorUnknown,
          dialogType: DialogType.error,
        );
        return;
      }
      await saveImg("share", bytes);
      if (!context.mounted) return;
      showOk(context: context);
    }

    Future<void> onTapCopyUrl() async {
      HapticsManager.light();
      await Clipboard.setData(ClipboardData(text: inviteUrl));
      if (!context.mounted) return;
      showOk(context: context);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 14, bottom: 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                iconSize: 24,
                icon: Icon(FontAwesomeIcons.shareNodes, color: c.secondary),
                onPressed: () async {
                  HapticsManager.light();
                  // 以后可以远程获取

                  showShare(
                    context,
                    qrData: inviteUrl,
                    onTapWechat: onTapWechat,
                    onTapSave: onTapSave,
                    onTapCopyUrl: onTapCopyUrl,
                  );
                },
              ),
              const SizedBox(width: 30),
            ],
          ),
          Icon(Icons.account_circle, color: c.primary, size: 72),
          const SizedBox(height: 12),
          Text(
            _userProfile.nickname,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  // 版权
  Widget _buildCopyright(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Center(
      child: Column(
        children: [
          Text(
            "© 2025 zhuzhu",
            style: t.bodyMedium!.copyWith(color: c.secondary),
          ),
        ],
      ),
    );
  }
}
