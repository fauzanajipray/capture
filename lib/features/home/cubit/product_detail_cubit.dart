import 'package:capture/features/home/models/product_detail.dart';
import 'package:capture/features/home/repository/home_repository.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailCubit extends Cubit<DataState<ProductDetail>> {
  ProductDetailCubit(this._repository) : super(const DataState());
  final HomeRepository _repository;

  Future<void> getProductDetail(int merchantId) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      Map<String, dynamic> response =
          await _repository.getProductDetail(merchantId);
      ProductDetail? product = ProductDetail.fromJson(response['data']);

      emit(state.copyWith(
        status: LoadStatus.success,
        data: response,
        item: product,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
