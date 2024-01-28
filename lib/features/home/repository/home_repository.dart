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

  // Get Recomendation
  Future<Map<String, dynamic>> getRecomendation(int page) async {
    final queryParameters = {
      'page': page.toString(),
    };
    Response response = await _dio.get('/merchant/recomendation',
        queryParameters: queryParameters);
    return response.data;
  }
}
