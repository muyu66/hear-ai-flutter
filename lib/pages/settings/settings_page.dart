import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/models/user_profile.dart';
import 'package:hearai/pages/settings/widgets/scan_qr.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/store.dart';
import 'package:hearai/tools/auth.dart';
import 'package:hearai/tools/cache_manager.dart';
import 'package:hearai/tools/dialog.dart';
import 'package:hearai/tools/secure_storage.dart';
import 'package:hearai/widgets/wechat_login.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    "匿名用户",
    null,
    "pow",
    3,
    10,
    true,
    false,
  );

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
    HapticFeedback.lightImpact();
    await SecureStorageUtils.delete("privateKeyBase64");
    AuthStore().clearToken();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/sign_in');
    }
  }

  void _updateUseMinute(int value) {
    if (!mounted) return;
    final store = Provider.of<Store>(context, listen: false);

    HapticFeedback.lightImpact();
    authService.updateProfile(useMinute: value).then((_) {
      _loadProfile();
      store.resetPercent();
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
        HapticFeedback.lightImpact();
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
          _buildSectionTitle(context, '账号'),
          _buildCard(
            context,
            children: [
              _buildEditableTextField(
                title: '昵称',
                value: _userProfile.nickname,
                onChanged: (value) async {
                  HapticFeedback.lightImpact();
                  await authService.updateProfile(nickname: value);
                  _loadProfile();
                },
              ),
              // 微信绑定
              _userProfile.isWechat
                  ? _buildSimpleTile(title: '已绑定微信', icon: Icons.wechat)
                  : WeChatButton(
                      builder: (context, loading, support, triggerLogin) {
                        return _buildClickableTile(
                          title: '绑定微信',
                          icon: Icons.wechat,
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            await triggerLogin();
                          },
                        );
                      },
                      onCode: (code) {
                        HapticFeedback.lightImpact();
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
              _buildClickableTile(
                title: '扫码登录设备',
                icon: Icons.qr_code_scanner,
                onTap: () async {
                  HapticFeedback.lightImpact();
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
          _buildSectionTitle(context, '学习'),
          _buildCard(
            context,
            children: [
              _buildDropdownSelection<String>(
                title: '记忆法',
                value: _userProfile.rememberMethod,
                items: const [
                  DropdownMenuItem(value: 'pow', child: Text('指数间隔')),
                  DropdownMenuItem(value: 'fc', child: Text('遗忘曲线')),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    HapticFeedback.lightImpact();
                    await authService.updateProfile(rememberMethod: value);
                    _loadProfile();
                  }
                },
              ),
              _buildDropdownSelection<int>(
                title: '难度等级',
                value: _userProfile.wordsLevel,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('🥚 菜鸟')),
                  DropdownMenuItem(value: 2, child: Text('🐣 半熟萌新')),
                  DropdownMenuItem(value: 3, child: Text('🍳 适中')),
                  DropdownMenuItem(value: 4, child: Text('🦉 老鸟探险者')),
                  DropdownMenuItem(value: 5, child: Text('🤯 神仙打架')),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    HapticFeedback.lightImpact();
                    await authService.updateProfile(wordsLevel: value);
                    _loadProfile();
                  }
                },
              ),
              _buildDropdownSelection<int>(
                title: '每日学习时间',
                value: _userProfile.useMinute,
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3分钟')),
                  DropdownMenuItem(value: 5, child: Text('5分钟')),
                  DropdownMenuItem(value: 10, child: Text('10分钟')),
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
              _buildSwitchTile(
                title: '多种发音源',
                value: _userProfile.multiSpeaker,
                onChanged: (value) async {
                  HapticFeedback.lightImpact();
                  await authService.updateProfile(multiSpeaker: value);
                  _loadProfile();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 通用设置
          _buildSectionTitle(context, '通用'),
          _buildCard(
            context,
            children: [
              _buildClickableTile(
                title: '清理缓存',
                subtitle: _cacheSizeText,
                icon: FontAwesomeIcons.trash,
                onTap: () {
                  HapticFeedback.lightImpact();
                  showConfirm(
                    context: context,
                    title: l.confirmClean,
                    dialogType: DialogType.warning,
                    onConfirm: () {
                      HapticFeedback.lightImpact();
                      cacheManager.clearCache().then((_) {
                        _loadCacheSize();
                      });
                    },
                  );
                },
              ),
              _buildClickableTile(
                title: '捐赠',
                icon: FontAwesomeIcons.handHoldingHeart,
                onTap: () async {
                  HapticFeedback.lightImpact();
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
              _buildClickableTile(
                title: '前往 HearAI 网站',
                icon: FontAwesomeIcons.globe,
                onTap: () async {
                  HapticFeedback.lightImpact();
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
              _buildClickableTile(
                title: '退出账号',
                icon: FontAwesomeIcons.arrowRightFromBracket,
                onTap: () {
                  HapticFeedback.lightImpact();
                  showConfirm(
                    context: context,
                    title: _userProfile.isWechat
                        ? l.confirmSignOut
                        : l.confirmSignOutWithoutWeChat,
                    dialogType: DialogType.warning,
                    onConfirm: () {
                      HapticFeedback.lightImpact();
                      _signOut();
                    },
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 36),
          _buildCopyright(context),
          const SizedBox(height: 42),
        ],
      ),
    );
  }

  // 可编辑文本字段组件
  Widget _buildEditableTextField({
    required String title,
    required String value,
    required Function(String) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit, size: 20),
      onTap: () {
        HapticFeedback.lightImpact();
        _showEditDialog(title, value, onChanged);
      },
    );
  }

  void _showEditDialog(
    String title,
    String currentValue,
    Function(String) onChanged,
  ) {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('修改$title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '请输入$title',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty && newValue != currentValue) {
                onChanged(newValue);
              }
              Navigator.pop(context);
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }

  // 下拉选择组件（使用 DropdownMenuItem）
  Widget _buildDropdownSelection<T>({
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    final c = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: c.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              alignment: Alignment.centerRight,
              items: items,
              onChanged: (T? newValue) {
                onChanged(newValue);
              },
              onTap: () {
                HapticFeedback.lightImpact();
              },
              enableFeedback: true,
              icon: const Icon(Icons.arrow_drop_down, size: 24),
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              style: TextStyle(fontSize: 14, color: c.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  // 开关组件
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    IconData? icon,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      secondary: icon == null ? null : FaIcon(icon, size: 18),
      onChanged: onChanged,
    );
  }

  // 可点击项目组件
  Widget _buildClickableTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function() onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: FaIcon(icon, size: 20),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  // 纯展示项目组件
  Widget _buildSimpleTile({
    required String title,
    String? subtitle,
    required IconData icon,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: FaIcon(icon, size: 20),
    );
  }

  // Header 区域
  Widget _buildHeader(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 48, bottom: 22),
      child: Column(
        children: [
          Icon(Icons.account_circle, color: c.primary, size: 72),
          const SizedBox(height: 12),
          Text(
            _userProfile.nickname,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 分组标题
  Widget _buildSectionTitle(BuildContext context, String title) {
    final c = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: c.primary,
        ),
      ),
    );
  }

  // 卡片包装
  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final c = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: c.outline,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          return Column(
            children: [
              widget,
              if (index != children.length - 1)
                Divider(height: 1, thickness: 1, color: c.outlineVariant),
            ],
          );
        }).toList(),
      ),
    );
  }

  // 版权
  Widget _buildCopyright(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Text(
            "© 2025 zhuzhu",
            style: TextStyle(fontSize: 14, color: c.secondary),
          ),
          Text(
            "Version 1.0.0",
            style: TextStyle(fontSize: 14, color: c.secondary),
          ),
        ],
      ),
    );
  }
}
