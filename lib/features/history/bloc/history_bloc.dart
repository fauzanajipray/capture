import 'package:capture/features/history/model/history.dart';
import 'package:capture/features/home/bloc/list_pagination_event.dart';
import 'package:capture/features/home/repository/home_repository.dart';
import 'package:capture/utils/data_list_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class HistoryBloc extends Bloc<ListPaginationEvent, DataListState<History>> {
  HistoryBloc(this.repository) : super(const DataListState()) {
    on<ListPaginationEvent>(
      (event, emit) async {
        if (event is ResetSearchTermEvent) {
          emit(_resetSearching());
        } else if (event is FetchItemEvent) {
          DataListState<History> stateData =
              await fetchHistoryList(event.pageKey);
          emit(stateData);
        } else if (event is ResetPage) {
          emit(_resetPage());
        }
      },
    );
  }

  static const _pageSize = 20;
  final HomeRepository repository;

  DataListState<History> _resetSearching() {
    return state.copyWith(
      status: LoadStatus.reset,
    );
  }

  Future<DataListState<History>> fetchHistoryList(int pageKey) async {
    final lastListingState = state.copyWith(status: LoadStatus.loading);
    try {
      final response = await repository.getHistories(
        pageKey,
      );
      var data = response['data'] as List;

      List<History> newItems = data.map((x) => History.fromJson(x)).toList();
      final isLastPage = newItems.length < _pageSize;
      final nextPageKey = isLastPage ? null : pageKey + 1;

      List<History> itemListBefore;
      if (pageKey == 1) {
        itemListBefore = [];
      } else {
        itemListBefore = lastListingState.itemList;
      }
      return state.copyWith(
        status: LoadStatus.success,
        error: null,
        page: pageKey,
        nextPageKey: nextPageKey,
        itemList: [
          ...itemListBefore,
          ...newItems,
        ],
      );
    } on DioException catch (e) {
      // Handle DioException and return a new state with the error
      return state.copyWith(
        status: LoadStatus.failure,
        error: e,
        nextPageKey: lastListingState.nextPageKey,
        itemList: lastListingState.itemList,
      );
    }
  }

  DataListState<History> _resetPage() {
    return state.copyWith(status: LoadStatus.reset, page: 1);
  }
}
