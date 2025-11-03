import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/presentation/providers/providers.dart';

class ToggleUserRouteButton extends ConsumerWidget {
  const ToggleUserRouteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25.0,
        child: IconButton(
          icon: const Icon(Icons.more_horiz_rounded),
          color: Colors.black,
          onPressed: () {
            ref.read(mapProvider.notifier).onToggleUserRoute();
          },
        ),
      ),
    );
  }
}
