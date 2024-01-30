import 'package:capture/features/transaction/model/snap_create.dart';
import 'package:capture/features/transaction/model/transaction_callback.dart';
import 'package:capture/features/transaction/repository/transaction_repository.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallbackPaymentCubit extends Cubit<DataState<SnapCreate>> {
  CallbackPaymentCubit(this._repository) : super(const DataState());
  final TransactionRepository _repository;

  Future<void> callbackPayment(TransactionCallback data) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      Map<String, dynamic> response = await _repository.callbackPayment(data);
      SnapCreate? snapCreate = SnapCreate.fromJson(response['data']);
      emit(state.copyWith(
        status: LoadStatus.success,
        data: response,
        item: snapCreate,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
