import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapita_app/presentation/providers/providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPositionAsync = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map Screen')),
      body: currentPositionAsync.when(
        data: (data) => _MapView(latitude: data.$1, longitude: data.$2),
        error: (error, stackTrace) => Text('$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _MapView extends ConsumerStatefulWidget {
  const _MapView({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  __MapViewState createState() => __MapViewState();
}

class __MapViewState extends ConsumerState<_MapView> {
  @override
  Widget build(BuildContext context) {
    final mapController = ref.watch(mapControllerProvider);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 12,
          ),
          markers: mapController.markersSet,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            ref
                .read(mapControllerProvider.notifier)
                .setMapController(controller);
          },
          onLongPress: (argument) {
            ref
                .read(mapControllerProvider.notifier)
                .addMarker(
                  argument.latitude,
                  argument.longitude,
                  'Custom Marker',
                );
          },
        ),
        Positioned(
          bottom: 40.0,
          left: 20.0,
          child: IconButton.filledTonal(
            onPressed: () {
              ref.read(mapControllerProvider.notifier).findUser();
            },
            icon: const Icon(Icons.location_searching),
          ),
        ),
        Positioned(
          bottom: 90.0,
          left: 20.0,
          child: IconButton.filledTonal(
            onPressed: () {
              ref.read(mapControllerProvider.notifier).toggleFollowUser();
            },
            icon: Icon(
              mapController.followUser
                  ? Icons.directions_run
                  : Icons.accessibility_new_outlined,
            ),
          ),
        ),
        Positioned(
          bottom: 140.0,
          left: 20.0,
          child: IconButton.filledTonal(
            onPressed: () {
              ref
                  .read(mapControllerProvider.notifier)
                  .addMarkerCurrentPosition();
            },
            icon: const Icon(Icons.pin_drop),
          ),
        ),
      ],
    );
  }
}
