import 'package:hearai/apis/api_service.dart';

class SplashService extends ApiService {
  // 获取随机欢迎语
  Future<List<String>> getRandomWords() async {
    final res = await dio.get<List<dynamic>>('/splash/random-words');
    if (res.data == null) return [];
    return (res.data ?? []).map((e) => e.toString()).toList();
  }
}
