import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:service_dashboard/app/core/base/model/base_request_model.dart';
import 'package:service_dashboard/app/core/enums/service_path.dart';
import 'package:service_dashboard/app/core/manager/network_manager.dart';

class ApiService {
  final _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer ${AppStatics.meModel?.mobileApiToken}',
  };

  Map<String, String> get headers => _headers;
  Future getListData<T extends BaseModel>({
    required T objectModel,
    required String path,
    Map<String, dynamic>? queryParameters,
    T? extraModel,
  }) async {
    try {
      final response = await NetworkManager.instance.dio.get(
        path,
        options: Options(headers: _headers, extra: extraModel?.toJson()),
        queryParameters: queryParameters,
      );

      if (response.statusCode == HttpStatus.ok) {
        final resultPosts = List<T>.from(response.data['data'].map((e) => objectModel.fromJson(e)));
        log(response.data.toString());

        return resultPosts;
      }
    } on DioException catch (e) {
      log('DioError: ${e.message}');
      log('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      log('$objectModel-->$e');
    }
  }

  Future getObjectData<T extends BaseModel>({
    required T objectModel,
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await NetworkManager.instance.dio.get(
        path,
        options: options ?? Options(headers: _headers),
        queryParameters: queryParameters,
      );

      if (response.statusCode == HttpStatus.ok) {
        log(response.data.toString());
        return objectModel.fromJson(response.data['data']);
      }
    } on DioException catch (e) {
      log(e.response?.data);
      log('ERROR: $e');
    }
  }

   Future<bool> checkService(int serviceId) async {
    try {
      final response = await NetworkManager.instance.dio.post(
        ServicePath.checkService.subUrl, 
        options: Options(headers: _headers),
        data: jsonEncode({'serviceId': serviceId}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final checkService = response.data['data']['checkService'] ?? false;
        return checkService;
      } else {
        log('Servis kontrolü başarısız: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      log('DioError: ${e.message}');
      log('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      return false;
    }
  }
}
