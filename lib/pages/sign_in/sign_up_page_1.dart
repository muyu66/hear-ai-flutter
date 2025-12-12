import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hearai/pages/sign_in/widgets/selectable_card.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {
  List<SelectOption<String>> languages = [
    SelectOption(label: '简体中文', value: 'zh-CN'),
    SelectOption(label: 'English', value: 'en'),
    SelectOption(label: '日本語', value: 'ja'),
  ];

  Set<String> selectedLanguage = {'zh-CN'};

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: t.colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'chooseSourceLang'.tr,
                    style: t.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    SelectableCard<String>(
                      options: languages,
                      multiSelect: false,
                      selectedValues: selectedLanguage,
                      onChanged: (newSelected) {
                        HapticsManager.light();
                        setState(() => selectedLanguage = newSelected);
                      },
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        HapticsManager.light();
                        Get.toNamed(
                          '/sign-up/2',
                          arguments: {'sourceLang': selectedLanguage.first},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('next'.tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
