import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearai/tools/audio_manager.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  final AudioManager audioManager = AudioManager();
  bool isHandling = false;
  Timer? _scanThrottleTimer;

  late AnimationController lineController;
  late Animation<double> lineAnimation;

  @override
  void initState() {
    super.initState();

    // 扫描线动画
    lineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    lineAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: lineController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    lineController.dispose();
    _scanThrottleTimer?.cancel();
    super.dispose();
  }

  void _handleBarcode(String raw) {
    if (!raw.startsWith("hearai-device-session://")) return;

    // 播放音效 & 震动反馈
    audioManager.playAsset("assets/sounds/scan.opus");
    HapticFeedback.selectionClick();

    Navigator.pop(context, raw);
  }

  @override
  Widget build(BuildContext context) {
    final overlaySize = 280.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            scanWindow: Rect.fromCenter(
              center: MediaQuery.of(context).size.center(Offset.zero),
              width: overlaySize,
              height: overlaySize,
            ),
            onDetect: (capture) {
              if (_scanThrottleTimer?.isActive ?? false) return;

              _scanThrottleTimer = Timer(
                const Duration(milliseconds: 300),
                () {},
              );

              final Barcode? barcode = capture.barcodes.firstOrNull;
              final raw = barcode?.rawValue;
              if (raw == null) return;

              _handleBarcode(raw);
            },
          ),

          _buildScannerOverlay(overlaySize),
          _buildScanLine(overlaySize),

          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "将二维码放入框内自动扫描",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(double size) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final left = (width - size) / 2;
        final top = (height - size) / 2;

        return Stack(
          children: [
            // 上
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: top,
              child: Container(color: Colors.black54),
            ),
            // 下
            Positioned(
              left: 0,
              top: top + size,
              right: 0,
              bottom: 0,
              child: Container(color: Colors.black54),
            ),
            // 左
            Positioned(
              left: 0,
              top: top,
              width: left,
              height: size,
              child: Container(color: Colors.black54),
            ),
            // 右
            Positioned(
              right: 0,
              top: top,
              width: left,
              height: size,
              child: Container(color: Colors.black54),
            ),
            // 扫描框边框
            Positioned(
              left: left,
              top: top,
              width: size,
              height: size,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScanLine(double overlaySize) {
    return AnimatedBuilder(
      animation: lineAnimation,
      builder: (context, _) {
        final topOffset =
            (MediaQuery.of(context).size.height - overlaySize) / 2 +
            overlaySize * lineAnimation.value;

        return Positioned(
          left: (MediaQuery.of(context).size.width - overlaySize) / 2,
          top: topOffset,
          width: overlaySize,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.greenAccent.withOpacity(0.0),
                  Colors.greenAccent,
                  Colors.greenAccent.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
