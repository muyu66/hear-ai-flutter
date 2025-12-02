import 'package:flutter/material.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:hearai/tools/haptics_manager.dart';

class EditableTextTile extends StatelessWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;

  const EditableTextTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit, size: 20),
      onTap: () {
        HapticsManager.light();
        _showEditDialog(context);
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: value);

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
              if (newValue.isNotEmpty && newValue != value) {
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
}
