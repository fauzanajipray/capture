abstract class ProductListingEvent {}

class FetchItemEvent extends ProductListingEvent {
  final int pageKey;
  final int? categoryId;
  final String? search;

  FetchItemEvent(this.pageKey, this.categoryId, this.search);
}

class ResetSearchTermEvent extends ProductListingEvent {
  final String? search;
  final int? categoryId;
  ResetSearchTermEvent(this.search, this.categoryId);
}

class ResetPage extends ProductListingEvent {}
