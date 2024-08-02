import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:web/web.dart' as web;

/// Converts the Geoposition object into a [Position] object.
Position toPosition(web.GeolocationPosition webPosition) {
  final coords = webPosition.coords;

  return Position(
    latitude: coords.latitude,
    longitude: coords.longitude,
    timestamp: DateTime.fromMillisecondsSinceEpoch(webPosition.timestamp),
    altitude: coords.altitude ?? 0.0,
    altitudeAccuracy: coords.altitudeAccuracy ?? 0.0,
    accuracy: coords.accuracy as double? ?? 0.0,
    heading: coords.heading ?? 0.0,
    headingAccuracy: 0.0,
    floor: null,
    speed: coords.speed ?? 0.0,
    speedAccuracy: 0.0,
    isMocked: false,
  );
}

/// Converts the permission result received from the browser into a
/// [LocationPermission] value.
LocationPermission toLocationPermission(String? webPermission) {
  switch (webPermission) {
    case 'granted':
      return LocationPermission.whileInUse;
    case 'prompt':
      return LocationPermission.denied;
    case 'denied':
      return LocationPermission.deniedForever;
    default:
      throw ArgumentError(
          '$webPermission cannot be converted to a LocationPermission.');
  }
}

/// Converts an error received from the browser into a custom Geolocator
/// exception.
Exception convertPositionError(web.GeolocationPositionError error) {
  switch (error.code) {
    case 1:
      return PermissionDeniedException(error.message);
    case 2:
      return PositionUpdateException(error.message);
    case 3:
      return TimeoutException(error.message);
    default:
      return PlatformException(
        code: error.code.toString(),
        message: error.message,
      );
  }
}
