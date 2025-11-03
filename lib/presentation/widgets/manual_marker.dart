import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/config/helpers/helpers.dart';
import 'package:mapita_app/presentation/providers/providers.dart';

class ManualMarker extends ConsumerWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final searchState = ref.watch(searchProvider);

    return searchState.displayManualMarker
        ? SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                Positioned(top: 70.0, left: 20.0, child: _BackButton()),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0.0, -22.0),
                    child: BounceInDown(
                      from: 100.0,
                      child: const Icon(Icons.location_on_rounded, size: 50.0),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70.0,
                  left: 40.0,
                  child: _ConfirmationButton(size: size),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class _BackButton extends ConsumerWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30.0,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            ref.read(searchProvider.notifier).onDeactivateManualMarker();
          },
        ),
      ),
    );
  }
}

class _ConfirmationButton extends ConsumerWidget {
  const _ConfirmationButton({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);

    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: MaterialButton(
        minWidth: size.width - 120.0,
        color: Colors.black,
        elevation: 0.0,
        height: 40.0,
        shape: const StadiumBorder(),
        onPressed: () async {
          showLoadingMessage(context);

          final start = location.lastKnownLocation;
          if (start == null) return;

          final end = ref.read(mapProvider.notifier).mapCenter;
          if (end == null) return;

          final destination = await ref
              .read(searchProvider.notifier)
              .getCoorsStartToEnd(start, end);

          await ref.read(mapProvider.notifier).drawRoutePolyline(destination);
          ref.read(searchProvider.notifier).onDeactivateManualMarker();

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: const Text(
          'Confirm destination',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
