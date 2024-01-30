import 'package:capture/features/home/models/category.dart';
import 'package:capture/features/home/repository/home_repository.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._repository) : super(const CategoryState());
  final HomeRepository _repository;

  Future<void> getCategory() async {
    if (state.data.isEmpty) emit(state.copyWith(status: LoadStatus.loading));
    try {
      Map<String, dynamic> response = await _repository.getCategoryOwner();
      var data = response['data'] as List;
      List<Category> list = data.map((x) => Category.fromJson(x)).toList();

      emit(state.copyWith(
        status: LoadStatus.success,
        data: list,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}

class CategoryState extends Equatable {
  const CategoryState({
    this.status = LoadStatus.initial,
    this.data = const [],
    this.error,
  });
  final LoadStatus status;
  final List<Category> data;
  final DioException? error;

  CategoryState copyWith({
    LoadStatus? status,
    List<Category>? data,
    DioException? error,
  }) {
    return CategoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        data,
        error,
      ];
}
