import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectOption<T> {
  final String label;
  final T value;

  SelectOption({required this.label, required this.value});
}

class SelectableCard<T> extends StatelessWidget {
  final List<SelectOption<T>> options;
  final bool multiSelect;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>> onChanged;

  const SelectableCard({
    super.key,
    required this.options,
    this.multiSelect = false,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selectedValues.contains(option.value);

          return ListTile(
            title: Text(option.label.tr),
            trailing: isSelected
                ? Icon(Icons.check, color: t.colorScheme.primary)
                : null,
            onTap: () {
              final newSelected = Set<T>.from(selectedValues);
              if (isSelected) {
                newSelected.remove(option.value);
              } else {
                if (multiSelect) {
                  newSelected.add(option.value);
                } else {
                  newSelected
                    ..clear()
                    ..add(option.value);
                }
              }
              onChanged(newSelected);
            },
          );
        },
      ),
    );
  }
}
