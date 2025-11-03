import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:mapita_app/domain/entities/entities.dart';

class RouteDestination {
  RouteDestination({
    required this.points,
    required this.duration,
    required this.distance,
    required this.finalPlace,
  });

  final List<LatLng> points;
  final String duration;
  final int distance;
  final Place finalPlace;
}
