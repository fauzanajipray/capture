import 'package:capture/services/dio_client.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  late final Dio _dio;

  HomeRepository() {
    _dio = DioClient().client;
  }

  /// Get Category Owner
  Future<Map<String, dynamic>> getCategoryOwner() async {
    Response response = await _dio.get('/categories');
    return response.data;
  }
}
