import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/word_dict.dart';

class WordService extends ApiService {
  // 获取内置词典
  Future<WordDict> getWordDict(String word) async {
    final res = await dio.get('/word/$word/dict');
    if (res.data == null) {
      throw Exception('获取内置词典失败');
    }
    return WordDict.fromJson(res.data);
  }

  // 差评内置词典的单词
  Future<void> badWordDict(String word) async {
    await dio.post('/word/$word/dict/bad');
  }

  /// 获取单词发音
  String getWordVoiceUrl(String word, {bool slow = false}) {
    return '${dio.options.baseUrl}/word/$word/voice_stream?slow=$slow';
  }
}
