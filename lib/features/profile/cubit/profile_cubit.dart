import 'package:capture/features/profile/models/profile.dart';
import 'package:capture/features/profile/repository/profile_repository.dart';
import 'package:capture/main.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<DataState<Profile>> {
  ProfileCubit(this._repository) : super(const DataState());
  final ProfileRepository _repository;

  Future<void> getProfile() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      Map<String, dynamic> response = await _repository.getProfile();
      Profile? profile = Profile.fromJson(response);

      emit(state.copyWith(
        status: LoadStatus.success,
        data: response,
        item: profile,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
