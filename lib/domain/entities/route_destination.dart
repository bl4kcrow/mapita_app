import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class RouteDestination {
  RouteDestination({
    required this.points,
    required this.duration,
    required this.distance,
  });

  final List<LatLng> points;
  final String duration;
  final int distance;
}
