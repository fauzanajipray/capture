import 'package:capture/constant/app.dart';
import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio _dio = Dio();
  AuthCubit? authCubit;
  static final DioClient _dioClient = DioClient._internal();

  factory DioClient({AuthCubit? authCubit}) {
    if (authCubit != null) {
      _dioClient.authCubit = authCubit;
    }
    return _dioClient;
  }

  void init() {
    String token = "";
    if (authCubit != null) {
      token = authCubit!.state.token;
      if (token.isNotEmpty) {
        _dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = token;
            return handler.next(options);
          },
          onResponse: (response, handler) {
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            return handler.next(e);
          },
        ));
      }
    }
  }

  DioClient._internal() {
    _dio
      ..options.baseUrl = AppConstant.baseUrl
      ..options.receiveTimeout =
          const Duration(milliseconds: AppConstant.apiReceiveTimeout)
      ..options.sendTimeout =
          const Duration(milliseconds: AppConstant.apiSendTimeout)
      ..options.headers['Accept'] = 'application/json';
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        final authCubit = this.authCubit;
        if (authCubit != null) {
          if (e.type == DioExceptionType.badResponse) {
            int? statusCode = e.response?.statusCode;
            if (statusCode == 401) {
              authCubit.setUnauthenticated();
            }
          }
        }
        return handler.next(e);
      },
    ));
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }
  }

  Dio get client => _dio;
}
