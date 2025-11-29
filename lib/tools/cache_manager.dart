import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  // 单例
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  /// 获取缓存总大小（单位：字节）
  Future<int> getCacheSize() async {
    // 只需计算临时目录大小（已包含 flutter_cache_manager 的缓存）
    final tempDir = await getTemporaryDirectory();
    return _getDirectorySize(tempDir);
  }

  /// 清理所有缓存
  Future<void> clearCache() async {
    // 1. 清理 flutter_cache_manager 的逻辑缓存（释放内存 + 标记文件可删）
    await DefaultCacheManager().emptyCache();

    // 2. 清理临时目录（物理删除文件）
    final tempDir = await getTemporaryDirectory();
    await _deleteDirectory(tempDir);

    // 3. 重新创建临时目录（某些系统要求目录存在）
    await tempDir.create(recursive: true);
  }

  /// 计算目录大小（递归）
  Future<int> _getDirectorySize(Directory dir) async {
    if (!await dir.exists()) return 0;
    int size = 0;
    try {
      final entities = await dir.list(recursive: true).toList();
      for (final entity in entities) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (e) {
      // 忽略权限或文件被占用错误
    }
    return size;
  }

  /// 删除目录及其内容
  Future<void> _deleteDirectory(Directory dir) async {
    if (!await dir.exists()) return;
    try {
      await dir.delete(recursive: true);
    } catch (e) {
      // 某些文件可能正被使用，跳过
    }
  }

  /// 格式化字节数为人类可读格式（如 1.2 MB）
  static String formatSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024.0;
      i++;
    }
    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }
}
