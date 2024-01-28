import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class DataListState<T> extends Equatable {
  const DataListState({
    this.status = LoadStatus.initial,
    this.itemList = const [],
    this.page = 1,
    this.error,
    this.nextPageKey,
    this.search,
  });

  final LoadStatus status;
  final List<T> itemList;
  final int page;
  final DioException? error;
  final int? nextPageKey;
  final String? search;

  DataListState<T> copyWith({
    LoadStatus? status,
    List<T>? itemList,
    int? page,
    DioException? error,
    int? nextPageKey,
    String? search,
  }) {
    return DataListState(
      status: status ?? this.status,
      itemList: itemList ?? this.itemList,
      page: page ?? this.page,
      error: error ?? this.error,
      nextPageKey: nextPageKey,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [
        status,
        itemList,
        page,
        error,
        nextPageKey,
        search,
      ];
}
