import 'package:geolocator/geolocator.dart';

class PositionFactory {
  static Position createMockPosition() {
    return Position(
        latitude: 52.561270,
        longitude: 5.639382,
        timestamp: DateTime.fromMillisecondsSinceEpoch(500, isUtc: true),
        mocked: true,
        altitude: 3000.0,
        accuracy: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
  }
}
