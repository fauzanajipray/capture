import 'package:capture/features/home/bloc/product_listing_event.dart';
import 'package:capture/features/home/bloc/product_listing_state.dart';
import 'package:capture/features/home/models/product.dart';
import 'package:capture/features/home/repository/home_repository.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSearchBloc extends Bloc<ProductListingEvent, ProductListingState> {
  ProductSearchBloc(this.repository) : super(const ProductListingState()) {
    on<ProductListingEvent>(
      (event, emit) async {
        if (event is ResetSearchTermEvent) {
          emit(_resetSearching(event.search, event.categoryId));
        } else if (event is FetchItemEvent) {
          ProductListingState stateData = await fetchProductList(
            event.pageKey,
            search: event.search ?? state.search,
            categoryId: "${event.categoryId ?? ''}",
          );
          emit(stateData);
        } else if (event is ResetPage) {
          emit(_resetPage());
        }
      },
    );
  }

  static const _pageSize = 20;
  final HomeRepository repository;

  ProductListingState _resetSearching(String? search, int? categoryId) {
    return state.copyWith(
        status: LoadStatus.reset,
        search: search,
        categoryId: (categoryId != null) ? '$categoryId' : '');
  }

  Future<ProductListingState> fetchProductList(
    int pageKey, {
    String? search,
    String? categoryId,
  }) async {
    final lastListingState = state.copyWith(status: LoadStatus.loading);
    try {
      final response = await repository.getProductList(
        pageKey,
        categoryId,
        search,
      );
      var data = response['data'] as List;

      List<Product> newItems = data.map((x) => Product.fromJson(x)).toList();
      final isLastPage = newItems.length < _pageSize;
      final nextPageKey = isLastPage ? null : pageKey + 1;

      List<Product> itemListBefore;
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

  ProductListingState _resetPage() {
    return state.copyWith(status: LoadStatus.reset, page: 1);
  }
}
