import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:service_dashboard/app/core/constants/app_constant.dart';

typedef UnauthorizedCallback = void Function();

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  final String _baseUrl = AppConstant.baseUrl;

  late final Dio dio;
  UnauthorizedCallback? onUnauthorized;

  NetworkManager._init() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl))
      ..interceptors.add(
        InterceptorsWrapper(
          onError: (DioException error, ErrorInterceptorHandler handler) async {
            if (error.response?.statusCode == 404) {
              if (kDebugMode) {
                print("404 Hatası: İstenen kaynak bulunamadı.");
              }
              return handler.resolve(Response(
                requestOptions: error.requestOptions,
                statusCode: 404,
              ));
            } else if (error.response?.statusCode == 401) {
              if (kDebugMode) {
                print('Unauthorized: ${error.response?.data['message']}');
              }
              if (onUnauthorized != null) {
                onUnauthorized!();
              }
            }
            return handler.next(error);
          },
        ),
      );
  }
  void setUnauthorizedCallback(UnauthorizedCallback callback) {
    onUnauthorized = callback;
  }
}

class AuthNetworkManager {
  static AuthNetworkManager? _instance;
  static AuthNetworkManager get instance {
    _instance ??= AuthNetworkManager._init();
    return _instance!;
  }

  late final Dio dio;

  AuthNetworkManager._init() {
    dio = Dio(BaseOptions(baseUrl: AppConstant.baseUrl));
  }
}
