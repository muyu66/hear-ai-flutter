import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/dict.dart';

class DictService extends ApiService {
  // 获取内置词典
  Future<List<Dict>> getDict(String word) async {
    final res = await dio.get<List<dynamic>>('/dicts/$word');
    return (res.data ?? []).map((item) => Dict.fromJson(item)).toList();
  }

  // 差评内置词典的单词
  Future<void> bad({required String word, required String dictType}) async {
    await dio.post('/dicts/$word/bad-feedback', data: {"dictType": dictType});
  }
}
