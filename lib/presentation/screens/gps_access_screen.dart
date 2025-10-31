import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/presentation/providers/providers.dart';

class GpsAccessScreen extends ConsumerWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGpsProvider = ref.watch(gpsProvider);

    return Scaffold(
      body: Center(
        child: asyncGpsProvider.when(
          data: (gpsState) =>
              gpsState.isGpsEnabled ? _AccessButton() : _EnableGpsMessage(),
          error: (error, stackTrace) => Text('$error'),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _AccessButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso a la localización'),
        MaterialButton(
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            ref.read(gpsProvider.notifier).askGpsAccess();
          },
          child: const Text(
            'Solicitar Acceso',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe de habilitar el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}
