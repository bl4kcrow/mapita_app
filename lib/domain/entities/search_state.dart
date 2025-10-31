import 'package:mapita_app/domain/entities/entities.dart';

class SearchState {
  SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const [],
  });

  final bool displayManualMarker;
  final List<Place> places;
  final List<Place> history;

  SearchState copyWith({
    bool? displayManualMarker,
    List<Place>? places,
    List<Place>? history,
  }) {
    return SearchState(
      displayManualMarker: displayManualMarker ?? this.displayManualMarker,
      places: places ?? this.places,
      history: history ?? this.history,
    );
  }
}
