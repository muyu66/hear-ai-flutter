import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/sentence.dart';
import 'package:hearai/models/sentence_version.dart';

class SentenceService extends ApiService {
  /// 获取句子分页
  Future<List<SentenceModel>> getSentences() async {
    final res = await dio.get<List<dynamic>>('/sentences');
    return (res.data ?? [])
        .map((item) => SentenceModel.fromJson(item))
        .toList();
  }

  /// 获取句子版本
  Future<List<SentenceVersion>> getVersion() async {
    final res = await dio.get<List<dynamic>>('/sentences/version');
    return (res.data ?? [])
        .map((item) => SentenceVersion.fromJson(item))
        .toList();
  }

  // 获取句子发音
  Future<Uint8List> getPronunciation(
    String sentenceId, {
    bool slow = false,
    required String lang,
  }) async {
    final response = await dio.get<List<int>>(
      '/sentences/$sentenceId/pronunciation',
      queryParameters: {
        'slow': slow,
        'lang': lang,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.data == null || response.data!.isEmpty) {
      throw Exception('Audio bytes is empty');
    }

    return Uint8List.fromList(response.data!);
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
