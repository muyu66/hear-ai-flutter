import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/sentence.dart';

class SentenceService extends ApiService {
  /// 获取句子分页
  Future<List<SentenceModel>> getSentences() async {
    final res = await dio.get<List<dynamic>>('/sentences');
    return (res.data ?? [])
        .map((item) => SentenceModel.fromJson(item))
        .toList();
  }

  String getPronunciationUrl(
    String sentenceId, {
    bool slow = false,
    required String lang,
  }) {
    return '${dio.options.baseUrl}/sentences/$sentenceId/pronunciation?slow=$slow&lang=$lang&timestamp=${DateTime.now().millisecondsSinceEpoch}';
  }

  // 差评句子
  Future<void> bad(String sentenceId) async {
    await dio.post('/sentences/$sentenceId/bad-feedback');
  }

  // 记住句子
  Future<void> remember({
    required String sentenceId,
    required int hintCount,
    required int thinkingTime,
  }) async {
    await dio.post(
      '/sentences/$sentenceId/remember',
      data: {"hintCount": hintCount, "thinkingTime": thinkingTime},
    );
  }
}
