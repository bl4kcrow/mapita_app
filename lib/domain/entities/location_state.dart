import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState {
  LocationState({
    this.lastKnownLocation,
    this.myLocationHistory = const [],
    this.followingUser = false,
  });

  final bool followingUser;
  final LatLng? lastKnownLocation;
  final List<LatLng> myLocationHistory;

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnownLocation,
    List<LatLng>? myLocationHistory,
  }) {
    return LocationState(
      followingUser: followingUser ?? this.followingUser,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
    );
  }
}
