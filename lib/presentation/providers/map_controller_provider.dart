import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  MapState({
    this.isReady = false,
    this.followUser = false,
    this.markers = const [],
    this.controller,
  });

  final bool isReady;
  final bool followUser;
  final List<Marker> markers;
  final GoogleMapController? controller;

  Set<Marker> get markersSet {
    return Set.from(markers);
  }

  MapState copyWith({
    bool? isReady,
    bool? followUser,
    List<Marker>? markers,
    GoogleMapController? controller,
  }) {
    return MapState(
      isReady: isReady ?? this.isReady,
      followUser: followUser ?? this.followUser,
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
    );
  }
}

final mapControllerProvider =
    NotifierProvider.autoDispose<MapNotifier, MapState>(MapNotifier.new);

class MapNotifier extends Notifier<MapState> {
  @override
  build() {
    trackUser().listen((event) {
      lastKnownLocation = (event.$1, event.$2);
    });

    return MapState();
  }

  StreamSubscription? followUserSubscription;
  (double, double)? lastKnownLocation;

  void addMarker(double latitude, double longitude, String name) {
    final newMarker = Marker(
      markerId: MarkerId('${state.markers.length}'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name,
        snippet: 'This is the window snippet',
      ),
    );

    state = state.copyWith(markers: [...state.markers, newMarker]);
  }

  void addMarkerCurrentPosition() {
    if (lastKnownLocation == null) return;

    addMarker(
      lastKnownLocation!.$1,
      lastKnownLocation!.$2,
      'Point along the user way',
    );
  }

  Stream<(double, double)> trackUser() async* {
    await for (final pos in Geolocator.getPositionStream()) {
      yield (pos.latitude, pos.longitude);
    }
  }

  void setMapController(GoogleMapController controller) {
    state = state.copyWith(controller: controller, isReady: true);
  }

  findUser() {
    if (lastKnownLocation == null) return;

    goToLocation(lastKnownLocation!.$1, lastKnownLocation!.$2);
  }

  goToLocation(double latitude, double longitude) {
    final newPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15,
    );

    state.controller?.animateCamera(
      CameraUpdate.newCameraPosition(newPosition),
    );
  }

  toggleFollowUser() {
    state = state.copyWith(followUser: !state.followUser);

    if (state.followUser) {
      findUser();

      followUserSubscription = trackUser().listen(
        (event) => goToLocation(event.$1, event.$2),
      );
    } else {
      followUserSubscription?.cancel();
    }
  }
}
