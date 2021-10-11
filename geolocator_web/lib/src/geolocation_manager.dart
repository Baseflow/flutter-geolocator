import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

// ignore_for_file: public_member_api_docs
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
