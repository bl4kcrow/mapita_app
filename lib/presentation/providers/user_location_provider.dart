import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final userLocationProvider = FutureProvider.autoDispose<(double, double)>((
  ref,
) async {
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
      throw 'Location permmission is denied';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied, we cannot request permission';
  }

  final Position location = await Geolocator.getCurrentPosition();
  return (location.latitude, location.longitude);
});
