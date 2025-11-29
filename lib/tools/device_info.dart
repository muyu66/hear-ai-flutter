import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// 获取设备信息
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceData = {
          "brand": androidInfo.brand,
          "model": androidInfo.model,
          "version": androidInfo.version.release,
          "sdkInt": androidInfo.version.sdkInt,
          "id": androidInfo.id,
          "device": androidInfo.device,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceData = {
          "name": iosInfo.name,
          "systemName": iosInfo.systemName,
          "systemVersion": iosInfo.systemVersion,
          "model": iosInfo.model,
          "localizedModel": iosInfo.localizedModel,
          "identifierForVendor": iosInfo.identifierForVendor,
        };
      }
    } catch (e) {
      deviceData = {"error": "Failed to get device info: $e"};
    }

    return deviceData;
  }
}
