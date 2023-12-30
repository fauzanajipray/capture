import 'package:capture/services/dio_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  late final Dio _dio;

  AuthRepository() {
    _dio = DioClient().client;
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    Response response =
        await _dio.post('/login', data: {"email": email, "password": password});
    return response.data;
  }
}
