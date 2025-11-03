import 'package:flutter/material.dart';

class StartPointMarker extends CustomPainter {
  StartPointMarker({
    super.repaint,
    required this.time,
    required this.timeUnit,
    required this.destination,
  });

  final int time;
  final String timeUnit;
  final String destination;

  @override
  void paint(Canvas canvas, Size size) {
    final blackPencil = Paint()..color = Colors.black;
    final whitePencil = Paint()..color = Colors.white;

    //Draw black circle
    canvas.drawCircle(Offset(20, size.height - 20), 20, blackPencil);
    //Draw white circle
    canvas.drawCircle(Offset(20, size.height - 20), 7, whitePencil);

    //Draw white box shadow
    final path = Path();
    canvas.drawShadow(path, Colors.black, 10, false);
    //Draw white box
    path.moveTo(40.0, 20.0);
    path.lineTo(size.width - 10.0, 20.0);
    path.lineTo(size.width - 10.0, 100.0);
    path.lineTo(40.0, 100.0);
    canvas.drawPath(path, whitePencil);

    //Draw black box
    const blackBox = Rect.fromLTWH(40.0, 20.0, 70.0, 80.0);
    canvas.drawRect(blackBox, blackPencil);

    //Draw time texts
    final timeText = TextSpan(
      text: '$time',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.w400,
      ),
    );

    final timePainter = TextPainter(
      text: timeText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70.0, maxWidth: 70.0);

    timePainter.paint(canvas, const Offset(40, 35));

    final timeUnitText = TextSpan(
      text: timeUnit,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    );

    final timeUnitPainter = TextPainter(
      text: timeUnitText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70.0, maxWidth: 70.0);

    timeUnitPainter.paint(canvas, const Offset(40.0, 68.0));

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
    )..layout(minWidth: size.width - 135.0, maxWidth: size.width - 135.0);

    final double offsetY = (destination.length > 20) ? 35 : 48;

    locationPainter.paint(canvas, Offset(120, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
