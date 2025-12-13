import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hearai/models/sentence_version.dart';
import 'package:hearai/services/sentence_service.dart';

class SentenceVersionPage extends StatefulWidget {
  const SentenceVersionPage({super.key});

  @override
  State<SentenceVersionPage> createState() => _SentenceVersionPageState();
}

class _SentenceVersionPageState extends State<SentenceVersionPage> {
  List<SentenceVersion> versions = [];
  final sentenceService = SentenceService();

  @override
  void initState() {
    super.initState();

    sentenceService.getVersion().then((value) {
      setState(() {
        versions = value;
      });
    });
  }

  Widget _row(String title, String value) {
    final t = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(title, style: t.textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: t.textTheme.labelMedium),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }

  Widget _versionCard(SentenceVersion v) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 0.3,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            _row('语言', v.lang.tr),
            _divider(),
            _row('词条数量', v.totalCount),
            _divider(),
            _row('最近更新', _formatDate(v.updatedAt)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return '${date.year}-${_two(date.month)}-${_two(date.day)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("sentenceVersion".tr, style: t.titleMedium)),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: versions.length,
          itemBuilder: (context, index) {
            final v = versions[index];
            return _versionCard(v);
          },
        ),
      ),
    );
  }
}
