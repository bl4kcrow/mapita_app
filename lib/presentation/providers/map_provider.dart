import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapita_app/domain/entities/entities.dart';
import 'package:mapita_app/presentation/providers/providers.dart';

final mapProvider = NotifierProvider.autoDispose<MapNotifier, MapState>(
  MapNotifier.new,
);

class MapNotifier extends Notifier<MapState> {
  GoogleMapController? _mapController;
  ProviderSubscription<LocationState>? _locationState;
  LatLng? mapCenter;

  @override
  build() {
    ref.onDispose(() => _locationState?.close());
    return MapState();
  }

  void onInitMap(GoogleMapController controller) {
    _mapController = controller;

    _locationState = ref.listen(locationProvider, (prev, next) {
      if (next.lastKnownLocation != null &&
          next.lastKnownLocation != prev?.lastKnownLocation) {
        if (state.isFollowingUser) {
          moveCamera(next.lastKnownLocation!);
        }
        if (state.showMyRoute == true) {
          updateUserPolylines(next.myLocationHistory);
        }
      }
    });

    state = state.copyWith(isMapInitialized: true);
  }

  void onStartFollowingUser() {
    if (_locationState?.read().lastKnownLocation != null) {
      moveCamera(_locationState!.read().lastKnownLocation!);
    }
    state = state.copyWith(isFollowingUser: true);
  }

  void onStopFollowingUser() {
    state = state.copyWith(isFollowingUser: false);
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  void updateUserPolylines(List<LatLng> points) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: points,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;

    state = state.copyWith(polylines: currentPolylines);
  }

  Future<void> drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: destination.points,
    );

    final polylines = Map<String, Polyline>.from(state.polylines);
    polylines['route'] = myRoute;

    state = state.copyWith(polylines: polylines);
  }

  void onToggleUserRoute() {
    final bool showMyRoute = !state.showMyRoute;

    if (showMyRoute == false) {
      Map<String, Polyline> polylines = Map.from(state.polylines);
      polylines.remove('myRoute');
      state = state.copyWith(showMyRoute: showMyRoute, polylines: polylines);
    } else {
      state = state.copyWith(showMyRoute: showMyRoute);
    }
  }
}
