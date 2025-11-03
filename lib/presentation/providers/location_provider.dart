import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapita_app/domain/entities/entities.dart';

final locationProvider =
    NotifierProvider.autoDispose<LocationNotifier, LocationState>(
      LocationNotifier.new,
    );

class LocationNotifier extends Notifier<LocationState> {
  StreamSubscription? positionStream;

  @override
  build() {
    ref.onDispose(() => stopFollowingUser());
    return LocationState();
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    onNewUserLocation(LatLng(position.latitude, position.longitude));
  }

  void onNewUserLocation(LatLng newLocation) {
    state = state.copyWith(
      lastKnownLocation: newLocation,
      myLocationHistory: [...state.myLocationHistory, newLocation],
    );
  }

  void startFollowingUser() {
    state = state.copyWith(followingUser: true);
    positionStream = Geolocator.getPositionStream().listen((event) {
      final LatLng newLocation = LatLng(event.latitude, event.longitude);
      onNewUserLocation(newLocation);
    });
  }

  void stopFollowingUser() {
    state = state.copyWith(followingUser: false);
    positionStream?.cancel();
    debugPrint('Stop following user');
  }
}
