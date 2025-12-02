import 'package:flutter/material.dart';
import 'package:hearai/tools/haptics_manager.dart';

// 下拉选择组件（使用 DropdownMenuItem）
class DropdownSelectionTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;

  const DropdownSelectionTile({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title)],
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
                HapticsManager.light();
              },
              enableFeedback: true,
              icon: const Icon(Icons.arrow_drop_down, size: 24),
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              style: t.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
