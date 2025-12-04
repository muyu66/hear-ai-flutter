import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/words.dart';

class SentenceService extends ApiService {
  /// 获取句子分页
  Future<List<WordsModel>> getSentences() async {
    final res = await dio.get<List<dynamic>>('/sentences');
    return (res.data ?? []).map((item) => WordsModel.fromJson(item)).toList();
  }

  String getPronunciationUrl(int sentenceId, {bool slow = false}) {
    return '${dio.options.baseUrl}/sentences/$sentenceId/pronunciation?slow=$slow';
  }

  // 差评句子
  Future<void> bad(int sentenceId) async {
    await dio.post('/sentences/$sentenceId/bad-feedback');
  }

  // 记住句子
  Future<void> remember({
    required int sentenceId,
    required int hintCount,
    required int thinkingTime,
  }) async {
    await dio.post(
      '/sentences/$sentenceId/remember',
      data: {"hintCount": hintCount, "thinkingTime": thinkingTime},
    );
  }
}
