import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/presentation/providers/providers.dart';
import 'package:mapita_app/presentation/views/views.dart';
import 'package:mapita_app/presentation/widgets/widgets.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  late LocationNotifier locationNotifier;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      locationNotifier = ref.read(locationProvider.notifier);
      locationNotifier.startFollowingUser();
    });
  }

  @override
  void dispose() {
    locationNotifier.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final mapState = ref.watch(mapProvider);

    return Scaffold(
      body: location.lastKnownLocation == null
          ? const Center(child: Text('Wait a minute...'))
          : SingleChildScrollView(
              child: Stack(
                children: [
                  MapView(
                    initialLocation: location.lastKnownLocation!,
                    polylines: mapState.polylines.values.toSet(),
                    markers: mapState.markers.values.toSet(),
                  ),
                  const CustomSearchBar(),
                  const ManualMarker(),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          ToggleUserRouteButton(),
          FollowUserButton(),
          CurrentLocationButton(),
        ],
      ),
    );
  }
}
