import 'package:dio/dio.dart';
import 'api_client.dart';

abstract class ApiService {
  final Dio dio = ApiClient().dio;
}
