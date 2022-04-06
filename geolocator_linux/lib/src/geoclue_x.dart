import 'package:geoclue/geoclue.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

extension GeoClueLocationAccuracyStatus on GeoClueAccuracyLevel {
  LocationAccuracyStatus toStatus() {
    if (this == GeoClueAccuracyLevel.none) {
      return LocationAccuracyStatus.unknown;
    }
    if (this == GeoClueAccuracyLevel.exact) {
      return LocationAccuracyStatus.precise;
    }
    return LocationAccuracyStatus.reduced;
  }
}

extension GeoCluePosition on GeoClueLocation {
  Position toPosition() {
    return Position(
      accuracy: accuracy,
      altitude: altitude ?? 0,
      heading: heading ?? 0,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      speed: speed ?? 0,
      speedAccuracy: 0,
    );
  }
}
