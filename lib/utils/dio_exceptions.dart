import 'dart:convert';

import 'package:capture/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DioExceptions implements Exception {
  late String message;
  Map<String, List<String>>? mappedMessage;
  String? typeError;
  Response? response;
  DioExceptions.fromDioError(DioException dioError, BuildContext context) {
    response = dioError.response;
    mappedMessage = null;
    // if (dioError is! DioError) {
    //   message = AppLocalizations.of(context)!.server_error;
    //   return;
    // }
    logger.d(dioError.type);
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with the server.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with the server.";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          context,
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with the server.";
        break;
      case DioExceptionType.badCertificate:
        message =
            "Failed to verify the response from the server. Please try to update the application to the newest version.";
        break;
      case DioExceptionType.connectionError:
        message = "Failed to connect to the server.";
        break;
      case DioExceptionType.unknown:
        message = "Unexpected error occurred.";
        break;
      default:
        message = 'Unexpected error occurred.';
        break;
    }
  }

  DioExceptions.fromDioError422(DioException dioError, BuildContext context) {
    mappedMessage = null;
    if (dioError.type == DioExceptionType.badResponse) {
      var statusCode = dioError.response?.statusCode;
      if (statusCode == 422) {
        message = _handleError(
          context,
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      }
    }
  }

  DioExceptions.typeDioError(DioException dioError, BuildContext context,
      {String? defaults}) {
    typeError = null;
    if (dioError.type == DioExceptionType.badResponse) {
      var statusCode = dioError.response?.statusCode;
      if (statusCode == 422 || statusCode == 404 || statusCode == 403) {
        dynamic error = dioError.response?.data;
        if (error is List<int>) {
          try {
            String jsonError = utf8.decode(error);
            error = json.decode(jsonError);
          } catch (e) {
            error = {};
          }
        }
        typeError = error['type'] ?? '';
      }
      if (statusCode == 500) {
        typeError = defaults;
      }
    }
  }

  String _handleError(BuildContext context, int? statusCode, dynamic error) {
    if (error is List<int>) {
      try {
        String jsonError = utf8.decode(error);
        error = json.decode(jsonError);
      } catch (e) {
        error = {};
      }
    }
    switch (statusCode) {
      case 400:
        return error['message'] ?? "Bad Request";
      case 401:
        return error['message'] ?? "Unauthorized";
      case 429:
        return error['message'] ?? "Too Many Attempts";
      case 422:
        if (error is Map<String, dynamic> &&
            error['errors'] is Map<String, dynamic>) {
          mappedMessage = {};
          error = error['errors'];
          // print(error);
          for (var item in error.keys) {
            if (error[item] is String) {
              mappedMessage?[item.toString()] = [error[item]];
            } else {
              mappedMessage?[item.toString()] = List<String>.from(error[item]);
            }
          }
          // print(mappedMessage);
          return "";
        }
        return error['message'] ?? "Unprocessable Entity";
      case 403:
        return error['message'] ?? "Forbidden";
      case 404:
        return error['message'] ?? "Not Found";
      case 500:
        return "Internal Server Error";
      case 502:
        return error['message'] ?? "Bad Gateway";
      default:
        return "Unexpected error occurred.";
    }
  }

  @override
  String toString() => message;
}
