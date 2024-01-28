import 'package:capture/services/dio_client.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  late final Dio _dio;

  ProfileRepository() {
    _dio = DioClient().client;
  }

  /// Get Profile
  Future<Map<String, dynamic>> getProfile() async {
    Response response = await _dio.get('/profile');
    return response.data;
  }

  /// Update Porfile
  Future<Map<String, dynamic>> updateProfile(String json) async {
    Options options = Options()..contentType = 'application/json';
    Response response =
        await _dio.post('/profile', data: json, options: options);
    return response.data;
  }
}
