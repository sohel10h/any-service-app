import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_package;
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/auth_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/data/model/network/refresh_token_model.dart';

class ApiService {
  late Dio _dio;
  final AuthRepo _authRepo = AuthRepo();

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
      log("AuthToken GET = $authToken");
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
      log("AuthToken DELETE = $authToken");
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
      log("AuthToken PUT = $authToken");
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
      log("AuthToken POST = $authToken");
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

  Future<dynamic> postRefreshTokenAndRetry(Future<dynamic> Function() retryCallback) async {
    bool refreshed = await _postRefreshToken();
    if (refreshed) {
      log("Retrying the previous request after token refresh...");
      return await retryCallback();
    } else {
      log("Failed to refresh token, user should re-login.");
      HelperFunction.logOut();
      return null;
    }
  }

  Future<bool> _postRefreshToken() async {
    try {
      final refreshToken = StorageHelper.getValue(StorageHelper.refreshToken);
      if (refreshToken.isEmpty) {
        log("No refresh token found — user must log in again.");
        return false;
      }
      final params = {
        ApiParams.refreshToken: refreshToken,
      };
      log("RefreshToken POST Params: $params");
      final response = await _authRepo.postRefreshToken(params);
      if (response is String) {
        log("RefreshToken failed from api service response: $response");
        return false;
      } else {
        final model = response as RefreshTokenModel;
        if (model.status == 200 || model.status == 201) {
          StorageHelper.setValue(StorageHelper.authToken, model.data?.accessToken ?? "");
          StorageHelper.setValue(StorageHelper.refreshToken, model.data?.refreshToken ?? "");
          log("Token refreshed successfully.");
          return true;
        } else {
          log("RefreshToken failed with status: ${model.status}");
          return false;
        }
      }
    } catch (e) {
      log("RefreshToken catch error: ${e.toString()}");
      return false;
    }
  }
}
