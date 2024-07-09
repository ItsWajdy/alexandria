import 'dart:convert';
import 'dart:io';
import 'package:alexandria/api_service/api_response.dart';
import 'package:dio/dio.dart';

enum RequestType {
  get,
  post,
  put,
  patch,
  delete,
}

class BooksApiService {
  BooksApiService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  static const String _baseUrl = 'https://api.library.of.alexandria.com';
  final Dio _dio;

  Future<ApiResponse> request({
    required RequestType requestType,
    required String endpoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? body,
    File? file,
    String? accessToken,
  }) async {
    Object data = jsonEncode(body);

    Response response;
    switch (requestType) {
      case RequestType.get:
        response = await _dio.get(endpoint, queryParameters: parameters);
        break;
      case RequestType.post:
        response =
            await _dio.post(endpoint, queryParameters: parameters, data: data);
        break;
      case RequestType.put:
        response =
            await _dio.put(endpoint, queryParameters: parameters, data: data);
        break;
      case RequestType.patch:
        response =
            await _dio.patch(endpoint, queryParameters: parameters, data: data);
        break;
      case RequestType.delete:
        response = await _dio.delete(endpoint,
            queryParameters: parameters, data: data);
        break;
    }

    return ApiResponse.fromDioResponse(response);
  }
}
