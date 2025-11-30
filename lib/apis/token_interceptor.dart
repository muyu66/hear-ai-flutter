// token_interceptor.dart
import 'package:dio/dio.dart';
import 'package:hearai/apis/api_client.dart';
import 'package:hearai/app.dart';
import 'package:hearai/tools/auth.dart';

import 'auth_store.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AuthStore().accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // token无效 或者 私钥无效
      final needRedirect = await authSignIn();
      if (needRedirect) {
        navigatorKey.currentState?.pushNamed('/sign_in');
        return;
      }
      // ---------- 重试逻辑开始 ----------
      try {
        final originDio = ApiClient().dio;
        final RequestOptions request = err.requestOptions;

        // 使用新的 token 更新 Header
        final newToken = AuthStore().accessToken;
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
        }

        final Response retryResponse = await originDio.fetch(request);
        return handler.resolve(retryResponse);
      } catch (e) {
        return handler.next(err);
      }
      // ---------- 重试逻辑结束 ----------
    }
    // 继续抛出
    return handler.next(err);
  }
}
