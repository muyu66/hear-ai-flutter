import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearai/tools/haptics_manager.dart';

/// 文本编辑页
class EditableTextPage extends StatefulWidget {
  final String title;
  final String value;
  final bool Function(String value)? validation;
  const EditableTextPage({
    super.key,
    required this.title,
    required this.value,
    this.validation,
  });

  @override
  State<EditableTextPage> createState() => _EditableTextPageState();
}

class _EditableTextPageState extends State<EditableTextPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: -5), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -5, end: 5), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 5, end: -5), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -5, end: 5), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 5, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  /// 调用这个方法即可触发震动
  void shake() {
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: t.titleMedium),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.check),
            onPressed: () {
              HapticsManager.light();
              if (widget.validation != null &&
                  !widget.validation!(_controller.text)) {
                shake();
              } else {
                Navigator.pop(context, _controller.text);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0), // X 轴左右移动
                child: child,
              );
            },
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        (widget.validation == null
                            ? true
                            : widget.validation!(_controller.text))
                        ? c.tertiary
                        : c.error,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
