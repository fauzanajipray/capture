import 'package:capture/features/profile/models/profile.dart';
import 'package:capture/features/profile/repository/profile_repository.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpdateCubit extends Cubit<DataState<Profile>> {
  ProfileUpdateCubit(this._repository) : super(const DataState<Profile>());
  final ProfileRepository _repository;

  Future<void> update(Profile request) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      String data = request.toRawJson();
      Map<String, dynamic>? response = await _repository.updateProfile(data);

      Profile? newProfile = Profile.fromJson(response);
      emit(state.copyWith(
        status: LoadStatus.success,
        data: response,
        item: newProfile,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
