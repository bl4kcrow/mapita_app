import 'dart:convert';

class RouteResponse {
    final List<Route> routes;

  RouteResponse({
        required this.routes,
    });

  RouteResponse copyWith({
        List<Route>? routes,
    }) => 
      RouteResponse(
            routes: routes ?? this.routes,
        );

  factory RouteResponse.fromJson(String str) =>
      RouteResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

  factory RouteResponse.fromMap(Map<String, dynamic> json) => RouteResponse(
        routes: List<Route>.from(json["routes"].map((x) => Route.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "routes": List<dynamic>.from(routes.map((x) => x.toMap())),
    };
}

class Route {
    final int distanceMeters;
    final String duration;
    final Segment segment;

    Route({
        required this.distanceMeters,
        required this.duration,
        required this.segment,
    });

    Route copyWith({
        int? distanceMeters,
        String? duration,
        Segment? segment,
    }) => 
        Route(
            distanceMeters: distanceMeters ?? this.distanceMeters,
            duration: duration ?? this.duration,
            segment: segment ?? this.segment,
        );

    factory Route.fromJson(String str) => Route.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Route.fromMap(Map<String, dynamic> json) => Route(
        distanceMeters: json["distanceMeters"],
        duration: json["duration"],
        segment: Segment.fromMap(json["polyline"]),
    );

    Map<String, dynamic> toMap() => {
        "distanceMeters": distanceMeters,
        "duration": duration,
        "polyline": segment.toMap(),
    };
}

class Segment {
    final String encodedPolyline;

    Segment({
        required this.encodedPolyline,
    });

    Segment copyWith({
        String? encodedPolyline,
    }) => 
        Segment(
            encodedPolyline: encodedPolyline ?? this.encodedPolyline,
        );

    factory Segment.fromJson(String str) => Segment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Segment.fromMap(Map<String, dynamic> json) => Segment(
        encodedPolyline: json["encodedPolyline"],
    );

    Map<String, dynamic> toMap() => {
        "encodedPolyline": encodedPolyline,
    };
}
