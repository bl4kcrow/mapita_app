import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mapita_app/domain/entities/entities.dart';

final gpsProvider = AsyncNotifierProvider.autoDispose<GpsNotifier, GpsState>(
  GpsNotifier.new,
);

class GpsNotifier extends AsyncNotifier<GpsState> {
  StreamSubscription? gpsServiceSubscription;

  @override
  Future<GpsState> build() async {
    final isGpsEnabled = await _checkGpsStatus();
    final isPermissionGranted = await _isPermissionGranted();

    ref.onDispose(() => gpsServiceSubscription?.cancel());

    return GpsState(
      isGpsEnabled: isGpsEnabled,
      isPermissionGranted: isPermissionGranted,
    );
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((
      event,
    ) {
      final isEnabled = (event.index == 1) ? true : false;
      state = state.whenData(
        (gpsState) => gpsState.copyWith(isGpsEnabled: isEnabled),
      );
    });

    return isEnable;
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        state = state.whenData(
          (gpsState) => gpsState.copyWith(isPermissionGranted: true),
        );
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        state = state.whenData(
          (gpsState) => gpsState.copyWith(isPermissionGranted: false),
        );
        openAppSettings();
        break;
    }
  }
}
