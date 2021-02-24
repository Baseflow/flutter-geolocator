import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// The web implementation of [GeolocatorPlatform].
///
/// This class implements the `package:geolocator` functionality for the web.
class GeolocatorPlugin extends GeolocatorPlatform {
  static const _permissionQuery = {'name': 'geolocation'};

  final html.Geolocation? _geolocation;
  final html.Permissions? _permissions;

  /// Registers this class as the default instance of [GeolocatorPlatform].
  static void registerWith(Registrar registrar) {
    GeolocatorPlatform.instance = GeolocatorPlugin._(html.window.navigator);
  }

  GeolocatorPlugin._(html.Navigator navigator)
      : _geolocation = navigator.geolocation,
        _permissions = navigator.permissions;

  bool get _locationServicesEnabled => _geolocation != null;

  @override
  Future<LocationPermission> checkPermission() async {
    if (_permissions == null) {
      throw PlatformException(
        code: 'LOCATION_SERVICES_NOT_SUPPORTED',
        message: 'Location services are not supported on this browser.',
      );
    }

    final html.PermissionStatus result = await _permissions!.query(
      _permissionQuery,
    );

    return _toLocationPermission(result.state);
  }

  @override
  Future<LocationPermission> requestPermission() async {
    if (_geolocation == null) {
      throw PlatformException(
        code: 'LOCATION_SERVICES_NOT_SUPPORTED',
        message: 'Location services are not supported on this browser.',
      );
    }

    try {
      _geolocation!.getCurrentPosition();
      return LocationPermission.whileInUse;
    } catch (e) {
      return LocationPermission.denied;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() =>
      Future.value(_locationServicesEnabled);

  @override
  Future<Position> getLastKnownPosition({
    bool forceAndroidLocationManager = false,
  }) =>
      throw _unsupported('getLastKnownPosition');

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) async {
    if (!_locationServicesEnabled) {
      throw LocationServiceDisabledException();
    }

    try {
      final result = await _geolocation!.getCurrentPosition(
        enableHighAccuracy: _enableHighAccuracy(desiredAccuracy),
        timeout: timeLimit,
      );

      return _toPosition(result);
    } on html.PositionError catch (e) {
      throw _convertPositionError(e);
    }
  }

  @override
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    int timeInterval = 0,
    Duration? timeLimit,
  }) {
    if (!_locationServicesEnabled) {
      throw LocationServiceDisabledException();
    }

    html.Geoposition? previousPosition = null;

    return _geolocation!
        .watchPosition(
          enableHighAccuracy: _enableHighAccuracy(desiredAccuracy),
          timeout: timeLimit,
        )
        .handleError((error) => throw _convertPositionError(error))
        .skipWhile((geoposition) {
      if (distanceFilter == 0) {
        return false;
      }

      double distance = 0;

      if (previousPosition != null) {
        distance = distanceBetween(
            previousPosition!.coords!.latitude as double,
            previousPosition!.coords!.longitude as double,
            geoposition.coords!.latitude as double,
            geoposition.coords!.longitude as double);
      }
      previousPosition = geoposition;
      return distance < distanceFilter;
    }).map(_toPosition);
  }

  @override
  Future<bool> openAppSettings() => throw _unsupported('openAppSettings');

  @override
  Future<bool> openLocationSettings() =>
      throw _unsupported('openLocationSettings');

  Exception _convertPositionError(html.PositionError error) {
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

  bool _enableHighAccuracy(LocationAccuracy accuracy) =>
      accuracy.index >= LocationAccuracy.high.index;

  LocationPermission _toLocationPermission(String? webPermission) {
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

  Position _toPosition(html.Geoposition webPosition) {
    final coords = webPosition.coords;

    if (coords == null) {
      throw new PositionUpdateException('Received invalid position result.');
    }

    return Position(
      latitude: coords.latitude as double,
      longitude: coords.longitude as double,
      timestamp: webPosition.timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(webPosition.timestamp! /*!*/)
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

  PlatformException _unsupported(String method) {
    return PlatformException(
      code: 'UNSUPPORTED_OPERATION',
      message: '$method is not supported on the web platform.',
    );
  }
}
