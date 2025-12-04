import 'package:hearai/apis/api_service.dart';

class WordService extends ApiService {
  /// 获取单词发音
  String getPronunciation(String word, {bool slow = false}) {
    return '${dio.options.baseUrl}/words/$word/pronunciation?slow=$slow';
  }
}
