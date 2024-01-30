import 'package:capture/features/transaction/model/transaction_callback.dart';
import 'package:capture/services/dio_client.dart';
import 'package:dio/dio.dart';

class TransactionRepository {
  late final Dio _dio;

  TransactionRepository() {
    _dio = DioClient().client;
  }

  Future<Map<String, dynamic>> createTransaction(String merchantId) async {
    Response response = await _dio.post('/midtrans/create', data: {
      "merchant_id": merchantId,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> callbackPayment(TransactionCallback data) async {
    String json = data.toRawJson();
    Options options = Options()..contentType = 'application/json';
    Response response =
        await _dio.post('/midtrans/callback', data: json, options: options);
    return response.data;
  }
}
