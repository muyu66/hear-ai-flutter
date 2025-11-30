import 'dart:convert';

import 'package:hearai/apis/api_service.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:hearai/models/words.dart';

class WordsService extends ApiService {
  /// 获取句子分页
  Future<List<WordsModel>> getWords() async {
    final res = await dio.get<List<dynamic>>('/words');
    return (res.data ?? []).map((item) => WordsModel.fromJson(item)).toList();
  }

  String getWordsVoiceUrl(int wordsId, {bool slow = false}) {
    final token = AuthStore().accessToken;
    if (token == null) {
      return '';
    }
    final base64Token = base64Encode(utf8.encode(token));
    return '${dio.options.baseUrl}/words/$wordsId/voice_stream?token=$base64Token&slow=$slow';
  }

  // 差评句子
  Future<void> badWords(int wordsId) async {
    await dio.post('/words/$wordsId/bad');
  }
}
