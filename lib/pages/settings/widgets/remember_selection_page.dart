import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hearai/pages/settings/widgets/card_selection_tile.dart';

class SelectionItem {
  final String title;
  final String subTitle;
  final Widget icon;
  final String content;
  final String value;
  final bool enabled;

  const SelectionItem({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.content,
    required this.value,
    required this.enabled,
  });
}

// 定义选项数据列表
final List<SelectionItem> rememberMethodList = const [
  SelectionItem(
    value: "zhuzhu",
    title: "Zhuzhu 1.0",
    subTitle: "自研算法",
    icon: Text("⭐⭐⭐⭐"),
    content: "基于用户行为数据研发。其核心思想是尽可能多角度从用户数据出发，为每一位用户量身定制最适合最有效率的记忆方法。",
    enabled: true,
  ),
  SelectionItem(
    value: "fsrs",
    title: "FSRS 6.0",
    subTitle: "长期算法",
    icon: Text("⭐⭐⭐⭐⭐"),
    content: "智能间隔重复调度算法。用遗忘模型而不是经验公式，依据用户行为真实拟合“记忆保持概率曲线”，从而给出最优复习间隔。",
    enabled: true,
  ),
  SelectionItem(
    value: "fsrsst",
    title: "FSRS ST",
    subTitle: "短期算法",
    icon: Text("⭐⭐⭐"),
    content: "在极短时间内将新知识牢固编码进工作记忆与短期长期记忆交界区，不追求最小化长期复习次数，而是最大化短期记忆强度与稳定性。",
    enabled: true,
  ),
  SelectionItem(
    value: "sm2",
    title: "SuperMemo 2",
    subTitle: "经典算法",
    icon: Text("⭐⭐⭐"),
    content: "基于间隔重复的学习系统。它的核心思想是根据每次复习的表现，动态调整下次复习的时间间隔，以最大化记忆效率。",
    enabled: true,
  ),
];

/// 记忆模型选择页
class RememberSelectionPage extends StatefulWidget {
  final String rememberMethod;
  final Function(String value) onTap;
  const RememberSelectionPage({
    super.key,
    required this.rememberMethod,
    required this.onTap,
  });

  @override
  State<RememberSelectionPage> createState() => _RememberSelectionPageState();
}

class _RememberSelectionPageState extends State<RememberSelectionPage> {
  int? selectedIndex;
  String _rememberMethod = "smz";

  @override
  void initState() {
    super.initState();
    _rememberMethod = widget.rememberMethod;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("chooseRememberModel".tr, style: t.titleMedium),
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: rememberMethodList.length,
            itemBuilder: (context, index) {
              final item = rememberMethodList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: CardSelectionTile(
                  title: item.title,
                  subTitle: item.subTitle,
                  icon: item.icon,
                  content: item.content,
                  selected: _rememberMethod == item.value,
                  onTap: item.enabled
                      ? () {
                          widget.onTap(item.value);
                          setState(() {
                            _rememberMethod = item.value;
                          });
                        }
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
