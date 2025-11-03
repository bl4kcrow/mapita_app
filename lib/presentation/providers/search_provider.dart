import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:mapita_app/domain/entities/entities.dart';
import 'package:mapita_app/services/services.dart';

final searchProvider =
    NotifierProvider.autoDispose<SearchNotifier, SearchState>(
      SearchNotifier.new,
    );

class SearchNotifier extends Notifier<SearchState> {
  late MapsService _mapsService;

  @override
  build() {
    _mapsService = MapsService();
    return SearchState();
  }

  void onActivateManualMarker() {
    state = state.copyWith(displayManualMarker: true);
  }

  void onDeactivateManualMarker() {
    state = state.copyWith(displayManualMarker: false);
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final routeResponse = await _mapsService.getCoorsStartToEnd(
      start,
      end,
    );

    final distance = routeResponse.routes.first.distanceMeters;
    final duration = routeResponse.routes.first.duration;
    final decodedPolylines = decodePolyline(
      routeResponse.routes.first.segment.encodedPolyline,
    );

    final points = decodedPolylines
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    final finalPlace = await _mapsService.getPlaceByCoors(end);

    return RouteDestination(
      points: points,
      duration: duration,
      distance: distance,
      finalPlace: finalPlace,
    );
  }

  Future<void> getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await _mapsService.getResultsByQuery(proximity, query);
    state = state.copyWith(places: newPlaces);
  }

  void addPlaceToHistory(Place place) {
    state = state.copyWith(history: [place, ...state.history]);
  }
}
