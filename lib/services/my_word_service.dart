import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/result_bool.dart';
import 'package:hearai/models/result_int.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/models/word_book_summary.dart';

class MyWordService extends ApiService {
  // 单词是否存在单词本
  Future<ResultBool> exist(String word) async {
    final res = await dio.get('/my/words/${Uri.encodeComponent(word)}/exist');
    return ResultBool.fromJson(res.data);
  }

  // 新增单词到单词本
  Future<void> add({required String word, required String lang}) async {
    await dio.post<void>('/my/words', data: {"word": word, "lang": lang});
  }

  // 获取单词本概况
  Future<WordBookSummary> getSummary() async {
    final res = await dio.get('/my/words/summary');
    return WordBookSummary.fromJson(res.data);
  }

  // 获取今天的单词本概况
  Future<ResultInt> getNow() async {
    final res = await dio.get('/my/words/now');
    return ResultInt.fromJson(res.data);
  }

  // 获取单词本列表
  Future<List<WordBook>> getWords({required int offset}) async {
    final res = await dio.get<List<dynamic>>('/my/words?offset=$offset');
    return (res.data ?? []).map((e) => WordBook.fromJson(e)).toList();
  }

  // 记住单词
  Future<void> remember({
    required String word,
    required int hintCount,
    required int thinkingTime,
  }) async {
    await dio.post<void>(
      '/my/words/$word/remember',
      data: {"hintCount": hintCount, "thinkingTime": thinkingTime},
    );
  }

  // 报告这个单词质量不行
  Future<void> bad(String word) async {
    await dio.post<void>('/my/words/$word/bad-feedback');
  }

  // 从单词本剔除单词
  Future<void> delete(String word) async {
    await dio.post<void>('/my/words/$word/delete');
  }
}
