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

  Future<Map<String, dynamic>> signUp(String name, String email,
      String password, String passwordConfirm) async {
    Response response = await _dio.post('/register', data: {
      "nama": name,
      "email": email,
      "password": password,
      "confirm_password": passwordConfirm
    });
    return response.data;
  }
}
