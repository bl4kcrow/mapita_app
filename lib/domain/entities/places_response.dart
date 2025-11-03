import 'dart:convert';

class PlacesResponse {
  final List<Place> places;

  PlacesResponse({required this.places});

  PlacesResponse copyWith({List<Place>? places}) =>
      PlacesResponse(places: places ?? this.places);

  factory PlacesResponse.fromJson(String str) =>
      PlacesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlacesResponse.fromMap(Map<String, dynamic> json) => PlacesResponse(
    places: List<Place>.from(json["places"].map((x) => Place.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "places": List<dynamic>.from(places.map((x) => x.toMap())),
  };
}

class Place {
  final Location location;
  final DisplayName displayName;
  final String formattedAddress;

  Place({
    required this.location,
    required this.displayName,
    required this.formattedAddress,
  });

  Place copyWith({
    Location? location,
    DisplayName? displayName,
    String? formattedAddress,
  }) => Place(
    location: location ?? this.location,
    displayName: displayName ?? this.displayName,
    formattedAddress: formattedAddress ?? this.formattedAddress,
  );

  factory Place.fromJson(String str) => Place.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Place.fromMap(Map<String, dynamic> json) => Place(
    location: Location.fromMap(json["location"]),
    displayName: DisplayName.fromMap(json["displayName"]),
    formattedAddress: json["formattedAddress"],
  );

  Map<String, dynamic> toMap() => {
    "location": location.toMap(),
    "displayName": displayName.toMap(),
    "formattedAddress": formattedAddress,
  };
}

class DisplayName {
  final String text;
  final String languageCode;

  DisplayName({required this.text, required this.languageCode});

  DisplayName copyWith({String? text, String? languageCode}) => DisplayName(
    text: text ?? this.text,
    languageCode: languageCode ?? this.languageCode,
  );

  factory DisplayName.fromJson(String str) =>
      DisplayName.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DisplayName.fromMap(Map<String, dynamic> json) =>
      DisplayName(text: json["text"], languageCode: json["languageCode"]);

  Map<String, dynamic> toMap() => {"text": text, "languageCode": languageCode};
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  Location copyWith({double? latitude, double? longitude}) => Location(
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );

  factory Location.fromJson(String str) => Location.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> json) => Location(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
