import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/dict_model.dart';

class DictService extends ApiService {
  // 获取内置词典
  Future<DictModel> getDict(String word, String lang) async {
    print('/dicts/${Uri.encodeComponent(word)}?lang=$lang');
    final res = await dio.get('/dicts/${Uri.encodeComponent(word)}?lang=$lang');
    return DictModel.fromJson(res.data);
  }

  // 差评内置词典的单词
  Future<void> bad({required String id}) async {
    await dio.post('/dicts/bad-feedback', data: {"id": id});
  }

  // 获取单词发音
  Future<Uint8List> getPronunciation(
    String word, {
    bool slow = false,
    required String lang,
  }) async {
    final response = await dio.get<List<int>>(
      '/dicts/${Uri.encodeComponent(word)}/pronunciation',
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
}
