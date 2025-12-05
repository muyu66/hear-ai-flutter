import 'package:get_storage/get_storage.dart';
import 'package:hearai/models/user_profile.dart';
import 'package:hearai/models/word_book.dart';
import 'package:hearai/models/word_book_summary.dart';

class MemoryCache {
  // 单例
  MemoryCache._internal();
  static final MemoryCache _instance = MemoryCache._internal();
  factory MemoryCache() => _instance;

  static GetStorage? _box;

  static void init(GetStorage storage) {
    _box = storage;
  }

  WordBookSummary? loadWordBookSummary() {
    if (_box == null) {
      throw StateError('Storage not initialized. Call Storage.init() first.');
    }

    final data = _box!.read("WordBookSummary");
    if (data == null) return null;
    return WordBookSummary.fromJson(data);
  }

  void saveWordBookSummary(WordBookSummary data) async {
    if (_box == null) {
      throw StateError('Storage not initialized. Call Storage.init() first.');
    }

    _box!.writeInMemory("WordBookSummary", data.toJson());
  }

  UserProfile? loadUserProfile() {
    if (_box == null) {
      throw StateError('Storage not initialized. Call Storage.init() first.');
    }

    final data = _box!.read("UserProfile");
    if (data == null) return null;
    return UserProfile.fromJson(data);
  }

  void saveUserProfile(UserProfile data) async {
    if (_box == null) {
      throw StateError('Storage not initialized. Call Storage.init() first.');
    }

    _box!.writeInMemory("UserProfile", data.toJson());
  }

  List<WordBook>? loadWordBookList() {
    if (_box == null) {
      throw StateError('Storage not initialized. Call Storage.init() first.');
    }

    final data = _box!.read("WordBookList");
    if (data == null) return null;
    return (data as List).map((e) => WordBook.fromJson(e)).toList();
  }

  void saveWordBookList(List<WordBook> data) async {
    if (_box == null) {
      throw StateError('Storage not initialized. Call Storage.init() first.');
    }

    // 保存前把每个对象转换成 Map
    final jsonList = data.map((e) => e.toJson()).toList();
    await _box!.write("WordBookList", jsonList);
  }
}
