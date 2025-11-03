import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapita_app/presentation/widgets/widgets.dart';

Future<BitmapDescriptor> getStartCustomMarker({
  required int time,
  required String timeUnit,
  required String destination,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(350.0, 150.0);

  final startMarker = StartPointMarker(
    time: time,
    timeUnit: timeUnit,
    destination: destination,
  );

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final bytesImage = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.bytes(
    bytesImage!.buffer.asUint8List(),
    bitmapScaling: MapBitmapScaling.none,
  );
}

Future<BitmapDescriptor> getEndCustomMarker({
  required int kms,
  required String destination,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(350.0, 150.0);

  final endMarker = EndPointMarker(kms: kms, destination: destination);

  endMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final bytesImage = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.bytes(
    bytesImage!.buffer.asUint8List(),
    bitmapScaling: MapBitmapScaling.none,
  );
}
