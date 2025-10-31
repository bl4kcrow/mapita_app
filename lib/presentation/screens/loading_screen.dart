import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/presentation/providers/providers.dart';
import 'package:mapita_app/presentation/screens/screens.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGpsProvider = ref.watch(gpsProvider);

    return Scaffold(
      body: asyncGpsProvider.when(
        data: (gpsState) => gpsState.isAllGranted
            ? const MapScreen()
            : const GpsAccessScreen(),
        error: (error, stackTrace) => Text('$error'),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
