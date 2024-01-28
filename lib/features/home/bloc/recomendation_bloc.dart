import 'package:capture/features/home/bloc/recomendation_event.dart';
import 'package:capture/features/home/models/recomendation.dart';
import 'package:capture/features/home/repository/home_repository.dart';
import 'package:capture/utils/data_list_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class RecomendationBloc
    extends Bloc<RecomendationEvent, DataListState<Recomendation>> {
  RecomendationBloc(this.repository) : super(const DataListState()) {
    on<RecomendationEvent>(
      (event, emit) async {
        if (event is ResetSearchTermEvent) {
          emit(_resetSearching());
        } else if (event is FetchItemEvent) {
          DataListState<Recomendation> stateData =
              await fetchProductList(event.pageKey, state.search);
          emit(stateData);
        } else if (event is ResetPage) {
          emit(_resetPage());
        }
      },
    );
  }

  static const _pageSize = 20;
  final HomeRepository repository;

  DataListState<Recomendation> _resetSearching() {
    return state.copyWith(
      status: LoadStatus.reset,
    );
  }

  Future<DataListState<Recomendation>> fetchProductList(int pageKey,
      [String? search, String? categoryId]) async {
    final lastListingState = state.copyWith(status: LoadStatus.loading);
    try {
      final response = await repository.getRecomendation(
        pageKey,
      );
      var data = response['data'] as List;

      List<Recomendation> newItems =
          data.map((x) => Recomendation.fromJson(x)).toList();
      final isLastPage = newItems.length < _pageSize;
      final nextPageKey = isLastPage ? null : pageKey + 1;

      List<Recomendation> itemListBefore;
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

  DataListState<Recomendation> _resetPage() {
    return state.copyWith(status: LoadStatus.reset, page: 1);
  }
}
