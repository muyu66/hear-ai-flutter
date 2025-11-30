import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/sign_in_req.dart';
import 'package:hearai/models/sign_up_req.dart';
import 'package:hearai/models/sign_up_res.dart';
import 'package:hearai/models/sign_up_wechat_req.dart';
import 'package:hearai/models/user_profile.dart';

class AuthService extends ApiService {
  /// 用户注册
  Future<SignUpRes> signUp(SignUpReq req) async {
    final res = await dio.post('/auth/sign_up', data: req.toJson());
    return SignUpRes.fromJson(res.data);
  }

  /// 微信用户注册
  Future<SignUpRes> signUpWechat(SignUpWechatReq req) async {
    final res = await dio.post('/auth/sign_up_wechat', data: req.toJson());
    return SignUpRes.fromJson(res.data);
  }

  /// 绑定微信
  Future<void> linkWechat(String code) async {
    await dio.post('/auth/link_wechat', data: {"code": code});
  }

  /// 用户登录
  Future<SignUpRes> signIn(SignInReq req) async {
    final res = await dio.post('/auth/sign_in', data: req.toJson());
    return SignUpRes.fromJson(res.data);
  }

  /// 更新用户信息
  Future<void> updateProfile({
    String? nickname,
    String? rememberMethod,
    int? wordsLevel,
    int? useMinute,
    bool? multiSpeaker,
  }) async {
    final data = {
      'nickname': nickname,
      'rememberMethod': rememberMethod,
      'wordsLevel': wordsLevel,
      'useMinute': useMinute,
      'multiSpeaker': multiSpeaker,
    }..removeWhere((key, value) => value == null);

    await dio.post('/auth/profile', data: data);
  }

  /// 查看用户信息
  Future<UserProfile> getProfile() async {
    final res = await dio.get('/auth/profile');
    return UserProfile.fromJson(res.data);
  }
}
