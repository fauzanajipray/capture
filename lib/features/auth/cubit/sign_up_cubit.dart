import 'package:capture/features/auth/repository/auth_repositry.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SignUpCubit extends Cubit<DataState<String>> {
  SignUpCubit(this._authRepository) : super(const DataState<String>());
  final AuthRepository _authRepository;

  Future<void> signUp(String name, String email, String password,
      String passwordConfirm) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      Map<String, dynamic> response =
          await _authRepository.signUp(name, email, password, passwordConfirm);
      emit(state.copyWith(
          status: LoadStatus.success, data: response, error: null));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
