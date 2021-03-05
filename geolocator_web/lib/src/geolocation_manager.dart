import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

abstract class GeolocationManager {
  Future<Position> getCurrentPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  });

  Stream<Position> watchPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  });
}
