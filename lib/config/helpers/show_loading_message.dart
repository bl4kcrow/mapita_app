import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showLoadingMessage(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Wait please'),
      content: Container(
        height: 100.0,
        width: 100.0,
        margin: const EdgeInsets.only(top:15.0),
        child: Column(
          children: [
            Text('Calculating route'),
            Gap(15.0),
            CircularProgressIndicator(strokeWidth: 3, color: Colors.black),
          ],
        ),
      ),
    ),
  );
}
