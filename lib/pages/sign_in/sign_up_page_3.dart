import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hearai/pages/sign_in/widgets/selectable_card.dart';
import 'package:hearai/services/auth_service.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SignUpPage3 extends StatefulWidget {
  const SignUpPage3({super.key});

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  final AuthService authService = AuthService();
  List<SelectOption<int>> levels = [
    SelectOption(label: 'wordsLevel0', value: 0),
    SelectOption(label: 'wordsLevel1', value: 1),
    SelectOption(label: 'wordsLevel2', value: 2),
    SelectOption(label: 'wordsLevel3', value: 3),
    SelectOption(label: 'wordsLevel4', value: 4),
    SelectOption(label: 'wordsLevel5', value: 5),
  ];

  Set<int> selectedLevel = {1};

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
                    'chooseLevel'.tr,
                    style: t.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    SelectableCard<int>(
                      options: levels,
                      multiSelect: false,
                      selectedValues: selectedLevel,
                      onChanged: (newSelected) {
                        HapticsManager.light();
                        setState(() => selectedLevel = newSelected);
                      },
                    ),

                    const SizedBox(height: 60),

                    ElevatedButton(
                      onPressed: () async {
                        HapticsManager.light();
                        final sourceLang = Get.arguments['sourceLang'];
                        final targetLang = Get.arguments['targetLang'];
                        final level = selectedLevel.first;
                        await authService.updateProfile(
                          wordsLevel: level,
                          sourceLang: sourceLang,
                          targetLang: targetLang,
                        );
                        Get.offAllNamed('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('signUp'.tr),
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
