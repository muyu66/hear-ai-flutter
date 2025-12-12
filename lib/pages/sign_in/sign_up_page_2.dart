import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hearai/pages/sign_in/widgets/selectable_card.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  List<SelectOption<String>> languages = [
    SelectOption(label: '简体中文', value: 'zh-CN'),
    SelectOption(label: 'English', value: 'en'),
    SelectOption(label: '日本語', value: 'ja'),
  ];

  Set<String> selectedLanguages = {'en'};

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
                    'chooseTargetLang'.tr,
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
                      multiSelect: true,
                      selectedValues: selectedLanguages,
                      onChanged: (newSelected) {
                        HapticsManager.light();
                        setState(() => selectedLanguages = newSelected);
                      },
                    ),

                    const SizedBox(height: 60),

                    ElevatedButton(
                      onPressed: () {
                        HapticsManager.light();
                        Get.toNamed(
                          '/sign-up/3',
                          arguments: {
                            'sourceLang': Get.arguments['sourceLang'],
                            'targetLangs': selectedLanguages.toList(),
                          },
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
