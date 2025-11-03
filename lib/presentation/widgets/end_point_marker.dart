import 'package:flutter/material.dart';

class EndPointMarker extends CustomPainter {
  EndPointMarker({
    required this.kms,
    required this.destination,
  });

  final int kms;
  final String destination;

  @override
  void paint(Canvas canvas, Size size) {
    final blackPencil = Paint()..color = Colors.black;
    final whitePencil = Paint()..color = Colors.white;

    //Draw black circle
    canvas.drawCircle(Offset(size.width * 0.5, size.height - 20), 20, blackPencil);
    //Draw white circle
    canvas.drawCircle(Offset(size.width * 0.5, size.height - 20), 7, whitePencil);

    //Draw white box shadow
    final path = Path();
    canvas.drawShadow(path, Colors.black, 10, false);
    //Draw white box
    path.moveTo(10.0, 20.0);
    path.lineTo(size.width - 10.0, 20.0);
    path.lineTo(size.width - 10.0, 100.0);
    path.lineTo(10.0, 100.0);
    canvas.drawPath(path, whitePencil);

    //Draw black box
    const blackBox = Rect.fromLTWH(10.0, 20.0, 70.0, 80.0);
    canvas.drawRect(blackBox, blackPencil);

    //Draw minutes texts
    final kilometersText = TextSpan(
      text: '$kms',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.w400,
      ),
    );

    final kilometersPainter = TextPainter(
      text: kilometersText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70.0, maxWidth: 70.0);

    kilometersPainter.paint(canvas, const Offset(10, 35));

    const kmsText = TextSpan(
      text: 'Kms',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    );

    final kmsPainter = TextPainter(
      text: kmsText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70.0, maxWidth: 70.0);

    kmsPainter.paint(canvas, const Offset(10.0, 68.0));

    //Draw destination description
    final locationText = TextSpan(
      text: destination,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 22.0,
        fontWeight: FontWeight.w400,
      ),
    );

    final locationPainter = TextPainter(
      text: locationText,
      maxLines: 2,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(minWidth: size.width - 95.0, maxWidth: size.width - 95.0);

    final double offsetY = (destination.length > 25) ? 35 : 48;

    locationPainter.paint(canvas, Offset(90, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
