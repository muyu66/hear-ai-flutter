import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtils {
  // 创建 storage 实例
  static final _storage = FlutterSecureStorage();

  /// 写入
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 读取
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// 存在
  static Future<bool> has(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// 删除某个 key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// 删除全部
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
