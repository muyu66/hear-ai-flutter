import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/tools/haptics_manager.dart';
import 'package:ionicons/ionicons.dart';

class Pad extends StatefulWidget {
  final double width;
  final double height;
  final double knobSize;
  final double percent;
  final void Function(String key)? onPressCenter;
  final void Function(String dir)? onDirection;
  final bool showBadge;
  final IconData? icon;

  const Pad({
    super.key,
    this.width = 260,
    this.height = 70,
    this.knobSize = 50,
    this.percent = 1,
    this.onPressCenter,
    this.onDirection,
    this.showBadge = false,
    this.icon = Ionicons.heart_circle,
  });

  @override
  State<Pad> createState() => _PadState();
}

class _PadState extends State<Pad> with SingleTickerProviderStateMixin {
  double dragX = 0;
  final double radius = 30;

  late final AnimationController _resetController;
  Animation<double>? _dragAnimation;
  VoidCallback? _animationListener;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  void animateReset() {
    if (_animationListener != null) {
      _resetController.removeListener(_animationListener!);
    }

    _dragAnimation = Tween<double>(
      begin: dragX,
      end: 0,
    ).animate(CurvedAnimation(parent: _resetController, curve: Curves.easeOut));

    _animationListener = () {
      setState(() {
        dragX = _dragAnimation!.value;
      });
    };

    _resetController
      ..reset()
      ..addListener(_animationListener!)
      ..forward().whenComplete(() {
        if (_animationListener != null) {
          _resetController.removeListener(_animationListener!);
          _animationListener = null;
        }
      });
  }

  Color lerpHSL(Color a, Color b, double t) {
    final hslA = HSLColor.fromColor(a);
    final hslB = HSLColor.fromColor(b);
    final hsl = HSLColor.lerp(hslA, hslB, t.clamp(0, 1))!;
    return hsl.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final knobColor = lerpHSL(
      c.tertiary,
      c.error,
      Curves.easeInOut.transform(widget.percent),
    );
    final leftScale = 1.3 + (max(0, -dragX) / radius) * (2.0 - 1.3);
    final rightScale = 1.3 + (max(0, dragX) / radius) * (2.0 - 1.3);
    final centerOpacity = (1 - (dragX.abs() / 20)).clamp(0.0, 1.0);

    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            LeftButton(scale: leftScale, showBadge: widget.showBadge),
            RightButton(scale: rightScale),
            CenterKnob(
              icon: widget.icon,
              dragX: dragX,
              knobSize: widget.knobSize,
              color: knobColor,
              opacity: centerOpacity,
              onPanUpdate: (dx) {
                setState(() {
                  dragX += dx;
                  dragX = dragX.clamp(-radius, radius);
                });
                HapticsManager.light();
              },
              onPanEnd: () {
                if (dragX > 10) {
                  // 增加明显震动
                  HapticsManager.medium();
                  widget.onDirection?.call("right");
                } else if (dragX < -10) {
                  // 增加明显震动
                  HapticsManager.medium();
                  widget.onDirection?.call("left");
                } else {
                  widget.onPressCenter?.call("center");
                }
                animateReset();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ 分离的按钮组件 ------------------
class LeftButton extends StatelessWidget {
  final double scale;
  final bool showBadge;
  const LeftButton({super.key, required this.scale, this.showBadge = true});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 26,
      child: Transform.scale(
        scale: scale,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.book, size: 22),
            if (showBadge)
              FractionalTranslation(
                translation: const Offset(1.2, -1.2), // x 正向右，y 正向下
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RightButton extends StatelessWidget {
  final double scale;
  const RightButton({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 26,
      child: Transform.scale(
        scale: scale,
        child: const FaIcon(FontAwesomeIcons.gear, size: 22),
      ),
    );
  }
}

class CenterKnob extends StatelessWidget {
  final double dragX;
  final double knobSize;
  final Color color;
  final double opacity;
  final void Function(double dx) onPanUpdate;
  final VoidCallback onPanEnd;
  final IconData? icon;

  const CenterKnob({
    super.key,
    required this.dragX,
    required this.knobSize,
    required this.color,
    required this.opacity,
    required this.onPanUpdate,
    required this.onPanEnd,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return GestureDetector(
      onPanUpdate: (details) => onPanUpdate(details.delta.dx),
      onPanEnd: (_) => onPanEnd(),
      child: Transform.translate(
        offset: Offset(dragX, 0),
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: knobSize,
            height: knobSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: knobSize, color: c.inverseSurface),
          ),
        ),
      ),
    );
  }
}
