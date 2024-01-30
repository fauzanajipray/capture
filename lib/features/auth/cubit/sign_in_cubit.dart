import 'package:capture/features/auth/repository/auth_repositry.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SignInCubit extends Cubit<DataState<String>> {
  SignInCubit(this._authRepository) : super(const DataState<String>());
  final AuthRepository _authRepository;

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      Map<String, dynamic> response =
          await _authRepository.signIn(email, password);
      emit(state.copyWith(
          status: LoadStatus.success, data: response, error: null));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
