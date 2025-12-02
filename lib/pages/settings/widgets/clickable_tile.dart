import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 可点击项目组件
class ClickableTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Function() onTap;
  const ClickableTile({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: FaIcon(icon, size: 20),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
