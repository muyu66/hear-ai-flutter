import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 开关组件
class SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final IconData? icon;
  final Function(bool) onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      secondary: icon == null ? null : FaIcon(icon, size: 18),
      onChanged: onChanged,
    );
  }
}
