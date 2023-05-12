import 'package:dio/dio.dart';
import 'package:weatherapp_flutter/src/data/datasources/remote/services/dio_interceptor.dart';
import 'package:weatherapp_flutter/src/utils/constants/api_url.dart';

class DioClient {
  String baseUrl = '';
  bool _isUnitTest = false;
  late Dio _dio;

  DioClient({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;
    _dio = _createDio();
    if (!_isUnitTest) _dio.interceptors.add(DioInterceptor());
  }

  Dio get dio {
    if (_isUnitTest) {
      return _dio;
    } else {
      final _dio = _createDio();
      if (!_isUnitTest) _dio.interceptors.add(DioInterceptor());
      return _dio;
    }
  }

  Dio _createDio() => Dio(BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      /*headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },*/
      receiveTimeout: 60000,
      connectTimeout: 60000,
      validateStatus: (int? status) {
        return status! > 0;
      }));

  Future<Response> getRequest(
    String url, // {Map<String, dynamic>? queryParameters,}
  ) async {
    try {
      return await dio.get(url);
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
