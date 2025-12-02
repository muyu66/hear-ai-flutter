import 'dart:typed_data';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveImg(String name, Uint8List bytes) async {
  // 请求权限（Android 13+ 或 iOS）
  final status = await Permission.photos.request();
  if (!status.isGranted) return;

  await ImageGallerySaverPlus.saveImage(
    bytes,
    quality: 100,
    name: "${name}_${DateTime.now().millisecondsSinceEpoch}",
  );
}
