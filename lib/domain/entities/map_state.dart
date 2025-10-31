import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoute = false,
    Map<String, Polyline>? polylines,
  }) : polylines = polylines ?? const {};

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;
  final Map<String, Polyline> polylines;

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
  }) {
    return MapState(
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      showMyRoute: showMyRoute ?? this.showMyRoute,
      polylines: polylines ?? this.polylines,
    );
  }
}
