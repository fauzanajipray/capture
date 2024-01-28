abstract class RecomendationEvent {}

class FetchItemEvent extends RecomendationEvent {
  final int pageKey;

  FetchItemEvent(this.pageKey);
}

class ResetSearchTermEvent extends RecomendationEvent {}

class ResetPage extends RecomendationEvent {}
