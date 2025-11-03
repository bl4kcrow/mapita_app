import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String message,
    String buttonLabel = 'Ok',
    super.duration = const Duration(seconds: 2),
    VoidCallback? onOk,
  }) : super(
         content: Text(message),
         action: SnackBarAction(
           label: buttonLabel,
           onPressed: () {
             if (onOk != null) {
               onOk();
             }
           },
         ),
       );
}
