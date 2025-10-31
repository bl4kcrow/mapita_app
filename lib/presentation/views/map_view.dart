import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapita_app/config/themes/themes.dart';
import 'package:mapita_app/presentation/providers/providers.dart';

class MapView extends ConsumerWidget {
  const MapView({
    super.key,
    required this.initialLocation,
    required this.polylines,
  });

  final LatLng initialLocation;
  final Set<Polyline> polylines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Listener(
        onPointerMove: (event) =>
            ref.read(mapProvider.notifier).onStopFollowingUser(),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines: polylines,
          style: jsonEncode(uberMapTheme),
          onMapCreated: (controller) {
            ref.read(mapProvider.notifier).onInitMap(controller);
          },
          onCameraMove: (position) {
            ref.read(mapProvider.notifier).mapCenter = position.target;
          },
        ),
      ),
    );
  }
}
