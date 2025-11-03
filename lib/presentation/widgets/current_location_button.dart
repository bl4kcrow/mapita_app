import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/presentation/providers/providers.dart';
import 'package:mapita_app/presentation/widgets/widgets.dart';

class CurrentLocationButton extends ConsumerWidget {
  const CurrentLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25.0,
        child: IconButton(
          icon: const Icon(Icons.my_location_outlined, color: Colors.black),
          onPressed: () {
            if (location.lastKnownLocation != null) {
              ref
                  .read(mapProvider.notifier)
                  .moveCamera(location.lastKnownLocation!);
            } else {
              final snackBar = CustomSnackbar(message: 'There is no location');
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }
}
