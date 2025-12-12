import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SelectionItem {
  final String title;
  final String subTitle;
  final String value;

  const SelectionItem({
    required this.title,
    required this.subTitle,
    required this.value,
  });
}

final List<SelectionItem> languageList = [
  SelectionItem(title: 'en'.tr, subTitle: 'English', value: "en"),
  SelectionItem(title: 'zh_CN'.tr, subTitle: '简体中文', value: "zh-CN"),
  SelectionItem(title: 'ja'.tr, subTitle: '日本語', value: "ja"),
];

class TargetLangPage extends StatefulWidget {
  final List<String> initValues;
  final List<String> disabledValues; // 禁止选择
  final Function(List<String> values) onTap;
  const TargetLangPage({
    super.key,
    required this.initValues,
    required this.onTap,
    this.disabledValues = const [],
  });

  @override
  State<TargetLangPage> createState() => _TargetLangPageState();
}

class _TargetLangPageState extends State<TargetLangPage> {
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    for (var value in widget.initValues) {
      final int index = languageList.indexWhere(
        (item) => item.value == value && !widget.disabledValues.contains(value),
      );
      if (index != -1) selectedIndexes.add(index);
    }
  }

  void _onItemTap(int index) {
    final item = languageList[index];
    if (widget.disabledValues.contains(item.value)) return; // 禁止选择直接返回

    HapticsManager.light();
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });

    // 至少选择一个
    if (selectedIndexes.isEmpty) {
      setState(() {
        selectedIndexes.add(index); // 恢复本次选择
      });
      return;
    }

    final selectedValues = selectedIndexes
        .map((i) => languageList[i].value)
        .toList();
    widget.onTap(selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("chooseTargetLang".tr, style: t.titleMedium)),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: languageList.length,
          itemBuilder: (context, index) {
            final item = languageList[index];
            final selected = selectedIndexes.contains(index);
            final disabled = widget.disabledValues.contains(item.value);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Card(
                elevation: selected ? 12 : 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.outline,
                    width: selected ? 2 : 0.3,
                  ),
                ),
                child: InkWell(
                  onTap: disabled ? null : () => _onItemTap(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.title, style: t.titleSmall),
                        Text(
                          item.subTitle,
                          style: disabled
                              ? t.bodyLarge?.copyWith(color: Colors.grey)
                              : t.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
