import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 纯展示项目组件
class SimpleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const SimpleTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: FaIcon(icon, size: 20),
    );
  }
}
