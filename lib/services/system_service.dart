import 'package:hearai/apis/api_service.dart';
import 'package:hearai/models/system_info.dart';

class SystemService extends ApiService {
  Future<SystemInfo> getSystemInfo() async {
    final res = await dio.get('/system/info');
    return SystemInfo.fromJson(res.data);
  }
}
