import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hearai/store.dart';

/// 静态代理类
class HapticsManager {
  // 确保单例初始化
  static void init() {
    if (!Get.isRegistered<HapticsController>()) {
      Get.put(HapticsController());
    }
  }

  static bool get enabled => Get.find<HapticsController>().enabled.value;

  static void setEnabled(bool value) =>
      Get.find<HapticsController>().setEnabled(value);

  static void light() {
    if (enabled) HapticFeedback.lightImpact();
  }

  static void medium() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  static void heavy() {
    if (enabled) HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    if (enabled) HapticFeedback.selectionClick();
  }
}
