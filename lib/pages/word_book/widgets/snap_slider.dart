import 'package:flutter/material.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SnapSlider extends StatefulWidget {
  final List<Widget> children;
  final Function(int) onChanged;
  final Function(int) onFinished;
  final double width;
  final double height;

  const SnapSlider({
    super.key,
    required this.children,
    required this.onChanged,
    required this.onFinished,
    this.width = 80,
    this.height = 100,
  });

  @override
  State<SnapSlider> createState() => _SnapSliderState();
}

class _SnapSliderState extends State<SnapSlider> with TickerProviderStateMixin {
  double _position = 0;
  late double _step;
  int _currentIndex = 2;

  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    assert(widget.children.length >= 2);
    _step = 1 / (widget.children.length - 1);
    _initChildrenAnimation();
  }

  void _initChildrenAnimation() {
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );

    _iconScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_iconController);
  }

  void _update(Offset localPosition) {
    final dx = localPosition.dx.clamp(0, widget.width);
    final ratio = dx / widget.width;
    final nearest = (ratio / _step).round().clamp(
      0,
      widget.children.length - 1,
    );

    final newPosition = nearest * _step;
    final changed = _currentIndex != nearest;

    if (changed) {
      _currentIndex = nearest;
      widget.onChanged(nearest);

      // 图标缩放动画
      _iconController.forward(from: 0);

      // Haptic
      HapticsManager.light();
    }

    setState(() {
      _position = newPosition;
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = widget.height * 0.1;
    final c = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        HapticsManager.medium();
        widget.onFinished(_currentIndex);
      },
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);
        _update(local);
      },
      onTapDown: (details) {
        HapticsManager.medium();
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);
        _update(local);
      },
      child: Container(
        width: widget.width,
        // 增加高度，比如 80，让用户更容易抓到
        height: widget.height,
        alignment: Alignment.center,
        child: Column(
          children: [
            // 动态缩放图标
            AnimatedBuilder(
              animation: _iconScale,
              builder: (_, _) {
                return Transform.scale(
                  scale: _iconScale.value,
                  child: widget.children[_currentIndex],
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: widget.width,
              height: buttonHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 椭圆背景按钮
                  Container(
                    width: widget.width,
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      color: c.primary,
                      borderRadius: BorderRadius.circular(buttonHeight),
                    ),
                  ),

                  // 小球（滑块）
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOut,
                    left: _position * (widget.width - buttonHeight),
                    child: SizedBox(width: buttonHeight, height: buttonHeight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
