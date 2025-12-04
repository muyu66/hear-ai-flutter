import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hearai/pages/settings/widgets/card_selection_tile.dart';

class SelectionItem {
  final String title;
  final String subTitle;
  final Widget icon;
  final String content;
  final String value;

  const SelectionItem({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.content,
    required this.value,
  });
}

// 定义选项数据列表
final List<SelectionItem> rememberMethodList = const [
  SelectionItem(
    value: "sm2",
    title: "SM-2",
    subTitle: "经典算法",
    icon: Text("⭐⭐⭐⭐"),
    content: "间隔重复领域最具影响力的经典算法，它通过动态调整复习间隔和易度因子，帮助用户在遗忘临界点高效巩固记忆。",
  ),
  SelectionItem(
    value: "asmplus",
    title: "ASM+",
    subTitle: "自适应算法",
    icon: Text("⭐⭐⭐⭐"),
    content:
        "在 SM-2 基础上深度优化的新一代自适应记忆调度算法，引入动态初始间隔、平滑难度调整、历史提示稳定性评估和失败软重置机制，显著提升个性化与鲁棒性。",
  ),
  SelectionItem(
    value: "arss",
    title: "ARSS",
    subTitle: "数据建模",
    icon: Text("⭐⭐⭐⭐⭐"),
    content:
        "轻量级、数据驱动的间隔重复调度算法，专为“全局拟合 + 单词级微调”场景设计。它在 FSRS 记忆模型基础上，仅依赖单次复习记录实现个性化调度，兼顾科学性与工程效率。",
  ),
  SelectionItem(
    value: "st",
    title: "ShortTerm",
    subTitle: "短期突击记忆",
    icon: Text("⭐⭐⭐"),
    content:
        "在极短时间内（通常 6 小时至 24 小时）将新知识牢固编码进工作记忆与短期长期记忆交界区，不追求最小化长期复习次数，而是最大化短期记忆强度与稳定性。",
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
  String _rememberMethod = "sm2";

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
                  onTap: () {
                    widget.onTap(item.value);
                    setState(() {
                      _rememberMethod = item.value;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
