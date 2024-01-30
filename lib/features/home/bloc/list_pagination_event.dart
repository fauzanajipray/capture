abstract class ListPaginationEvent {}

class FetchItemEvent extends ListPaginationEvent {
  final int pageKey;

  FetchItemEvent(this.pageKey);
}

class ResetSearchTermEvent extends ListPaginationEvent {}

class ResetPage extends ListPaginationEvent {}
