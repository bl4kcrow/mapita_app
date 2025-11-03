import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/config/delegates/delegates.dart';
import 'package:mapita_app/presentation/providers/providers.dart';

class CustomSearchBar extends ConsumerWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    return searchState.displayManualMarker == true
        ? const SizedBox.shrink()
        : FadeInDown(
            duration: const Duration(milliseconds: 300),
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                width: double.infinity,
                height: 50.0,
                child: GestureDetector(
                  onTap: () async {
                    final result = await showSearch(
                      context: context,
                      delegate: SearchDestinationDelegate(ref),
                    );

                    if (result?.manual == true) {
                      ref
                          .read(searchProvider.notifier)
                          .onActivateManualMarker();
                    } else if (result?.position != null) {
                      final start = ref
                          .read(locationProvider)
                          .lastKnownLocation;
                      if (start == null) return;

                      final end = result?.position;
                      if (end == null) return;

                      final destination = await ref
                          .read(searchProvider.notifier)
                          .getCoorsStartToEnd(start, end);

                      await ref
                          .read(mapProvider.notifier)
                          .drawRoutePolyline(destination);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Where are you going?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
