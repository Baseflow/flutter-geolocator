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

extension GeoClueLocationAccuracy on LocationAccuracy {
  GeoClueAccuracyLevel toGeoClueAccuracyLevel() {
    switch (this) {
      case LocationAccuracy.reduced:
      case LocationAccuracy.lowest:
        return GeoClueAccuracyLevel.country;
      case LocationAccuracy.low:
        return GeoClueAccuracyLevel.city;
      case LocationAccuracy.medium:
        return GeoClueAccuracyLevel.neighborhood;
      case LocationAccuracy.high:
        return GeoClueAccuracyLevel.street;
      case LocationAccuracy.best:
      case LocationAccuracy.bestForNavigation:
        return GeoClueAccuracyLevel.exact;
      default:
        return GeoClueAccuracyLevel.none;
    }
  }
}
