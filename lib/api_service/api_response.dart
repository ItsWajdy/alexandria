import 'package:dio/dio.dart';

enum ResponseStatus {
  ok,
  error,
}

class ApiResponse {
  final ResponseStatus status;
  final int? statusCode;
  final dynamic data;

  const ApiResponse({
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ApiResponse.ok({
    required int statusCode,
    required dynamic data,
  }) {
    return ApiResponse(
        status: ResponseStatus.ok, statusCode: statusCode, data: data);
  }

  factory ApiResponse.error({
    required int statusCode,
    required dynamic data,
  }) {
    return ApiResponse(
        status: ResponseStatus.error, statusCode: statusCode, data: data);
  }

  factory ApiResponse.fromDioResponse(Response response) {
    switch (response.statusCode! ~/ 100) {
      case 2:
        return ApiResponse(
          status: ResponseStatus.ok,
          statusCode: response.statusCode,
          data: response.data,
        );
      default:
        return ApiResponse(
          status: ResponseStatus.error,
          statusCode: response.statusCode,
          data: response.data,
        );
    }
  }
}
