import 'package:capture/features/home/models/product.dart';
import 'package:capture/utils/load_status.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ProductListingState extends Equatable {
  const ProductListingState({
    this.status = LoadStatus.initial,
    this.itemList = const [],
    this.page = 1,
    this.categoryId,
    this.search,
    this.error,
    this.nextPageKey,
  });

  final LoadStatus status;
  final List<Product> itemList;
  final int page;
  final String? categoryId;
  final String? search;
  final DioException? error;
  final int? nextPageKey;

  ProductListingState copyWith({
    LoadStatus? status,
    List<Product>? itemList,
    int? page,
    String? categoryId,
    String? search,
    int? totalDiscount,
    DioException? error,
    int? nextPageKey,
  }) {
    return ProductListingState(
      status: status ?? this.status,
      itemList: itemList ?? this.itemList,
      page: page ?? this.page,
      categoryId: categoryId ?? this.categoryId,
      search: search ?? this.search,
      error: error ?? this.error,
      nextPageKey: nextPageKey,
    );
  }

  @override
  List<Object?> get props => [
        status,
        itemList,
        page,
        categoryId,
        search,
        error,
        nextPageKey,
      ];
}
