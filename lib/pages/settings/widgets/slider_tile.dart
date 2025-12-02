import 'package:flutter/material.dart';
import 'package:hearai/tools/haptics_manager.dart';

class SliderTile extends StatelessWidget {
  final String title;
  final int value;
  final Function(int) onChanged;
  final Function(int) onChangeEnd;
  final int min;
  final int max;
  final int divisions;

  const SliderTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
    this.min = 0,
    this.max = 100,
    this.divisions = 100,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: t.bodyMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 160,
                child: Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: divisions,
                  label: value.toString(),
                  activeColor: c.primary,
                  onChangeEnd: (double newValue) {
                    HapticsManager.light();
                    onChangeEnd(newValue.round());
                  },
                  onChanged: (double newValue) {
                    HapticsManager.light();
                    onChanged(newValue.round());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
