import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hearai/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;

void showShare(
  BuildContext context, {
  required String qrData,
  required Future<void> Function(Uint8List? bytes) onTapWechat,
  required Future<void> Function(Uint8List? bytes) onTapSave,
  required void Function() onTapCopyUrl,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _ShareDialog(
      qrData: qrData,
      onTapWechat: onTapWechat,
      onTapSave: onTapSave,
      onTapCopyUrl: onTapCopyUrl,
    ),
  );
}

class _ShareDialog extends StatefulWidget {
  final String qrData;
  final Future<void> Function(Uint8List? bytes) onTapWechat;
  final Future<void> Function(Uint8List? bytes) onTapSave;
  final void Function() onTapCopyUrl;

  const _ShareDialog({
    required this.qrData,
    required this.onTapWechat,
    required this.onTapSave,
    required this.onTapCopyUrl,
  });

  @override
  State<_ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<_ShareDialog> {
  // GlobalKey 用来获取预览图的 RenderObject
  final GlobalKey _previewKey = GlobalKey();

  // 将预览图转成 bytes
  Future<Uint8List?> _capturePreviewBytes() async {
    try {
      RenderRepaintBoundary? boundary =
          _previewKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes == null) return null;

      final imageTmp = img.decodeImage(pngBytes);
      if (imageTmp == null) return null;
      // 编码为 JPG（无透明度）
      final jpg = img.encodeJpg(imageTmp, quality: 100);
      return Uint8List.fromList(jpg);
    } catch (e) {
      debugPrint('capture preview error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Stack(
      children: [
        GestureDetector(onTap: () => Navigator.of(context).pop()),
        // 弹框内容
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: c.onPrimary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareButton(
                      icon: Icons.wechat,
                      label: '微信好友',
                      onTap: () async {
                        Uint8List? bytes = await _capturePreviewBytes();
                        await widget.onTapWechat(bytes);
                      },
                    ),
                    _ShareButton(
                      icon: Icons.save,
                      label: '保存到相册',
                      onTap: () async {
                        Uint8List? bytes = await _capturePreviewBytes();
                        await widget.onTapSave(bytes);
                      },
                    ),
                    _ShareButton(
                      icon: Icons.copy,
                      label: '复制链接',
                      onTap: () async {
                        widget.onTapCopyUrl();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 预览图在遮罩上方
        Center(
          child: Transform.translate(
            offset: Offset(0, -280),
            child: RepaintBoundary(
              key: _previewKey,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                // 为了保存到本地的图片好看，所以不加阴影
                elevation: 0,
                child: Container(
                  width: 260,
                  height: 260,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // 标题
                      Text(
                        "HearAI",
                        style: t.titleLarge!.copyWith(color: c.primary),
                      ),

                      // 二维码
                      QrImageView(
                        data: widget.qrData,
                        version: QrVersions.auto,
                        size: 130,
                        embeddedImage: const AssetImage(
                          'assets/icon/logo_960.png',
                        ),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(24, 24),
                        ),
                      ),

                      // 分享文本
                      const SizedBox(height: 20),
                      Text(
                        l.shareText,
                        style: t.labelMedium!.copyWith(color: c.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  const _ShareButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          IconButton(onPressed: onTap, icon: Icon(icon, size: 28)),
          Text(label),
        ],
      ),
    );
  }
}
