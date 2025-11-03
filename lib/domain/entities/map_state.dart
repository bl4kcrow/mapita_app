import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoute = false,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) : polylines = polylines ?? const {},
       markers = markers ?? const {};

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) {
    return MapState(
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      showMyRoute: showMyRoute ?? this.showMyRoute,
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
    );
  }
}
