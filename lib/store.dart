import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';

class HapticsController extends GetxController {
  static const _key = 'haptics_enabled';
  final storage = GetStorage();
  RxBool enabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    // 从本地存储加载状态
    enabled.value = storage.read(_key) ?? true;
  }

  Future<void> setEnabled(bool value) async {
    enabled.value = value;
    storage.write(_key, value); // 保存到本地
  }
}

class StoreController extends GetxController {
  var percent = 1.0;
  var showBadge = false;
  IconData padIcon = Ionicons.heart_circle;

  void setPercent(double newValue) {
    percent = newValue.clamp(0.0, 1.0);
    update();
  }

  void resetPercent() {
    percent = 1.0;
    update();
  }

  void setShowBadge(bool newValue) {
    showBadge = newValue;
    update();
  }

  void setPadIcon(IconData newValue) {
    padIcon = newValue;
    update();
  }
}

class RefreshWordsController extends GetxController {
  var refreshWords = false;

  void setTrue() {
    refreshWords = true;
    update();
  }

  void setFalse() {
    refreshWords = false;
    update();
  }
}
