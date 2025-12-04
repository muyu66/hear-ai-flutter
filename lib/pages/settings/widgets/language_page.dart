import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SelectionItem {
  final String title;
  final String subTitle;
  final Function()? onTap;

  const SelectionItem({
    required this.title,
    required this.subTitle,
    required this.onTap,
  });
}

/// 语言选择页
class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  int? selectedIndex;
  final List<SelectionItem> languageList = [
    SelectionItem(
      title: 'en_US'.tr,
      subTitle: 'English',
      onTap: () {
        Get.updateLocale(const Locale('en', 'US'));
        GetStorage().write('language', "en_US");
      },
    ),
    SelectionItem(
      title: 'zh_CN'.tr,
      subTitle: '简体中文',
      onTap: () {
        Get.updateLocale(const Locale('zh', 'CN'));
        GetStorage().write('language', "zh_CN");
      },
    ),
    SelectionItem(
      title: 'zh_TW'.tr,
      subTitle: '繁體中文',
      onTap: () {
        Get.updateLocale(const Locale('zh', 'TW'));
        GetStorage().write('language', "zh_TW");
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        if (Get.locale == const Locale('en', 'US')) {
          selectedIndex = 0;
        }
        if (Get.locale == const Locale('zh', 'CN')) {
          selectedIndex = 1;
        }
        if (Get.locale == const Locale('zh', 'TW')) {
          selectedIndex = 2;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("selectLanguage".tr, style: t.titleMedium)),
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
                    item.onTap?.call();
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
