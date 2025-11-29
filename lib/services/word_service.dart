import 'dart:convert';

import 'package:hearai/apis/api_service.dart';
import 'package:hearai/apis/auth_store.dart';
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
    final token = AuthStore().accessToken;
    if (token == null) {
      return '';
    }
    final base64Token = base64Encode(utf8.encode(token));
    return '${dio.options.baseUrl}/word/$word/voice_stream?token=$base64Token&slow=$slow';
  }
}
