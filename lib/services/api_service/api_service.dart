import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      receiveTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
    );

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.validateStatus = (status) {
      return status! < 500;
    };

    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    // _dio.interceptors.add(PrettyDioLogger(requestHeader: false,request: true,requestBody: true));
  }

  /// ====================================> get Data ================================>
  Future<dynamic> get(String endpoint, {String fcmToken = ""}) async {
    Response response;
    try {
      String authToken = StorageHelper.getValue(StorageHelper.authToken);
      log("AuthToken = $authToken");
      if (authToken.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authToken";
      }
      response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      return e.message;
    }
  }

  /// ====================================> delete Data ================================>
  Future<dynamic> del(String endpoint) async {
    Response response;
    try {
      String authToken = StorageHelper.getValue(StorageHelper.authToken);
      if (authToken.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authToken";
      }
      response = await _dio.delete(endpoint);
      return response;
    } on DioException catch (e) {
      return e.message;
    }
  }

  /// ================================> put Data ===============================>
  Future<dynamic> put(String endpoint, var params) async {
    Response response;
    try {
      String authToken = StorageHelper.getValue(StorageHelper.authToken);
      if (authToken.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authToken";
      }
      response = await _dio.put(endpoint, data: params);
      return response;
    } on DioException catch (e) {
      return e.message;
    }
  }

  /// =================================> post Data =============================>
  Future<dynamic> post(String endpoint, var params, {bool isItFile = false}) async {
    Response response;
    try {
      String authToken = StorageHelper.getValue(StorageHelper.authToken);
      if (authToken.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authToken";
        if (isItFile) _dio.options.headers["Content-Type"] = "multipart/form-data";
        if (isItFile) _dio.options.headers["accept"] = "*/*";
      }
      response = await _dio.post(endpoint, data: params);
      return response;
    } on DioException catch (e) {
      return e.message;
    }
  }
}
