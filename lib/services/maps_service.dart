import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:mapita_app/domain/entities/entities.dart';

class MapsService {
  MapsService() : _dioMaps = Dio();
  final Dio _dioMaps;

  final String _baseRoutesUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';
  final String _baseSearchPlacesUrl =
      'https://places.googleapis.com/v1/places:searchText';
  final String _baseNearbySearchPlaceUrl =
      'https://places.googleapis.com/v1/places:searchNearby';

  final Map<String, dynamic> _headers = {
    'Content-Type': 'application/json',
    'X-Android-Package': dotenv.get('ANDROID_PACKAGE'),
    'X-Android-Cert': dotenv.get('ANDROID_CERT_SHA1'),
    'X-Goog-Api-Key': dotenv.get('GOOGLE_MAPS_API_KEY'),
  };

  Future<RouteResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    _headers['X-Goog-FieldMask'] =
        'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline';

    final Map<String, dynamic> body = {
      'origin': {
        'location': {
          'latLng': {'latitude': start.latitude, 'longitude': start.longitude},
        },
      },
      'destination': {
        'location': {
          "latLng": {'latitude': end.latitude, 'longitude': end.longitude},
        },
      },
      'travelMode': 'DRIVE',
      'routingPreference': 'TRAFFIC_AWARE',
      'computeAlternativeRoutes': false,
      'routeModifiers': {
        'avoidTolls': false,
        'avoidHighways': false,
        'avoidFerries': false,
      },
      'languageCode': 'en-US',
      'units': 'METRIC',
    };

    final response = await _dioMaps.post(
      _baseRoutesUrl,
      options: Options(headers: _headers),
      data: body,
    );

    final data = RouteResponse.fromMap(response.data);

    return data;
  }

  Future<List<Place>> getResultsByQuery(LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    _headers['X-Goog-FieldMask'] =
        'places.displayName,places.location,places.formattedAddress';

    final Map<String, dynamic> body = {
      "textQuery": query,
      "maxResultCount": 6,
      "locationBias": {
        "circle": {
          "center": {
            "latitude": proximity.latitude,
            "longitude": proximity.longitude,
          },
          "radius": 500.0,
        },
      },
    };

    final response = await _dioMaps.post(
      _baseSearchPlacesUrl,
      options: Options(headers: _headers),
      data: body,
    );

    final data = PlacesResponse.fromMap(response.data);

    return data.places;
  }

  Future<Place> getPlaceByCoors(LatLng coors) async {
    _headers['X-Goog-FieldMask'] =
        'places.displayName,places.location,places.formattedAddress';

    final Map<String, dynamic> body = {
      "maxResultCount": 1,
      "locationRestriction": {
        "circle": {
          "center": {"latitude": coors.latitude, "longitude": coors.longitude},
          "radius": 30.0,
        },
      },
    };

    final response = await _dioMaps.post(
      _baseNearbySearchPlaceUrl,
      options: Options(headers: _headers),
      data: body,
    );

    final data = PlacesResponse.fromMap(response.data);

    return data.places.first;
  }
}
