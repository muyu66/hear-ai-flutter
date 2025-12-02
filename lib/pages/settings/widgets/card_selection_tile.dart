import 'package:flutter/material.dart';

class CardSelectionTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String title;
  final String subTitle;
  final Widget icon;
  final String content;

  const CardSelectionTile({
    super.key,
    required this.selected,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Card(
      elevation: selected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: selected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text(title, style: t.titleSmall)),
                  icon,
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(subTitle, style: t.bodyLarge)],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      content,
                      style: t.bodyLarge!.copyWith(color: c.secondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
