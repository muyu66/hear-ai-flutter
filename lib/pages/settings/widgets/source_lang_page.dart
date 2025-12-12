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

class SourceLangPage extends StatefulWidget {
  final String initValue;
  final Function(String value) onTap;
  const SourceLangPage({
    super.key,
    required this.initValue,
    required this.onTap,
  });

  @override
  State<SourceLangPage> createState() => _SourceLangPageState();
}

class _SourceLangPageState extends State<SourceLangPage> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      final int index = languageList.indexWhere(
        (item) => item.value == widget.initValue,
      );
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("chooseSourceLang".tr, style: t.titleMedium)),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: languageList.length,
          itemBuilder: (context, index) {
            final item = languageList[index];
            final selected = selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Card(
                elevation: selected ? 12 : 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: selected
                      ? BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        )
                      : BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 0.3,
                        ),
                ),
                child: InkWell(
                  onTap: () {
                    HapticsManager.light();
                    widget.onTap(item.value);
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text(item.title, style: t.titleSmall),
                        ),
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text(item.subTitle, style: t.bodyLarge),
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
