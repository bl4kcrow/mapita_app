import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final watchLocationProvider = StreamProvider.autoDispose<(double, double)>((
  ref,
) async* {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled';
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permission is denied';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location permission is permanently denied, we cannot request permission';
  }

  await for (final location in Geolocator.getPositionStream()) {
    yield (location.latitude, location.longitude);
  }
});
