class AuthStore {
  // 单例
  static final AuthStore _instance = AuthStore._internal();
  factory AuthStore() => _instance;
  AuthStore._internal();

  // 内存中的 accessToken（应用运行期间有效）
  String? _accessToken;

  String? get accessToken => _accessToken;

  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;

  // 登录时保存
  void setToken(String token) {
    _accessToken = token;
  }

  // 登出时清除
  void clearToken() {
    _accessToken = null;
  }
}
