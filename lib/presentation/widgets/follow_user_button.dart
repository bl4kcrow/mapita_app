import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapita_app/presentation/providers/providers.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25.0,
        child: IconButton(
          icon: Icon(
            mapState.isFollowingUser
                ? Icons.directions_run_rounded
                : Icons.hail_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            ref.read(mapProvider.notifier).onStartFollowingUser();
          },
        ),
      ),
    );
  }
}
