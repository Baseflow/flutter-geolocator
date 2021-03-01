import 'dart:html' as html;
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

Position toPosition(html.Geoposition webPosition) {
  final coords = webPosition.coords;

  if (coords == null) {
    throw new PositionUpdateException('Received invalid position result.');
  }

  return Position(
    latitude: coords.latitude as double,
    longitude: coords.longitude as double,
    timestamp: webPosition.timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(webPosition.timestamp!)
        : DateTime.now(),
    altitude: coords.altitude as double? ?? 0.0,
    accuracy: coords.accuracy as double? ?? 0.0,
    heading: coords.heading as double? ?? 0.0,
    floor: null,
    speed: coords.speed as double? ?? 0.0,
    speedAccuracy: 0.0,
    isMocked: false,
  );
}
