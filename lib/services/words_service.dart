import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/words.dart';

class WordsService extends ApiService {
  /// 获取句子分页
  Future<List<WordsModel>> getWords() async {
    final res = await dio.get<List<dynamic>>('/words');
    return (res.data ?? []).map((item) => WordsModel.fromJson(item)).toList();
  }

  String getWordsVoiceUrl(int wordsId, {bool slow = false}) {
    return '${dio.options.baseUrl}/words/$wordsId/voice_stream?slow=$slow';
  }

  // 差评句子
  Future<void> badWords(int wordsId) async {
    await dio.post('/words/$wordsId/bad');
  }

  // 记住句子
  Future<void> rememberWords(int wordsId, int hintCount) async {
    await dio.post('/words/$wordsId/remember', data: {"hintCount": hintCount});
  }
}
