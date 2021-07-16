import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'src/geolocation_manager.dart';
import 'src/permissions_manager.dart';
import 'src/html_geolocation_manager.dart';
import 'src/html_permissions_manager.dart';

export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// The web implementation of [GeolocatorPlatform].
///
/// This class implements the `package:geolocator` functionality for the web.
class GeolocatorPlugin extends GeolocatorPlatform {
  static const _permissionQuery = {'name': 'geolocation'};

  final GeolocationManager _geolocation;
  final PermissionsManager _permissions;

  /// Registers this class as the default instance of [GeolocatorPlatform].
  static void registerWith(Registrar registrar) {
    GeolocatorPlatform.instance = GeolocatorPlugin.private(
      HtmlGeolocationManager(),
      HtmlPermissionsManager(),
    );
  }

  @visibleForTesting
  GeolocatorPlugin.private(
      GeolocationManager geolocation, PermissionsManager permissions)
      : _geolocation = geolocation,
        _permissions = permissions;

  /// Returns a [Future] containing a [bool] value indicating whether location
  /// services are enabled on the device.
  ///
  /// This will always return `true` on the web as the web platform doesn't know
  /// the concept of a separate location service which has to be enabled.
  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<LocationPermission> checkPermission() async {
    if (!_permissions.permissionsSupported) {
      throw PlatformException(
        code: 'LOCATION_SERVICES_NOT_SUPPORTED',
        message: 'Location services are not supported on this browser.',
      );
    }

    return await _permissions.query(
      _permissionQuery,
    );
  }

  @override
  Future<LocationPermission> requestPermission() async {
    try {
      await _geolocation.getCurrentPosition();
      return LocationPermission.whileInUse;
    } catch (e) {
      return LocationPermission.deniedForever;
    }
  }

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
    final result = await _geolocation.getCurrentPosition(
      enableHighAccuracy: _enableHighAccuracy(desiredAccuracy),
      timeout: timeLimit,
    );

    return result;
  }

  @override
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    int timeInterval = 0,
    Duration? timeLimit,
  }) {
    Position? previousPosition;

    return _geolocation
        .watchPosition(
      enableHighAccuracy: _enableHighAccuracy(desiredAccuracy),
      timeout: timeLimit,
    )
        .skipWhile((geoposition) {
      if (distanceFilter == 0) {
        return false;
      }

      double distance = 0;

      if (previousPosition != null) {
        distance = distanceBetween(
            previousPosition!.latitude,
            previousPosition!.longitude,
            geoposition.latitude,
            geoposition.longitude);
      } else {
        return false;
      }

      previousPosition = geoposition;
      return distance < distanceFilter;
    });
  }

  @override
  Future<bool> openAppSettings() => throw _unsupported('openAppSettings');

  @override
  Future<bool> openLocationSettings() =>
      throw _unsupported('openLocationSettings');

  bool _enableHighAccuracy(LocationAccuracy accuracy) =>
      accuracy.index >= LocationAccuracy.high.index;

  PlatformException _unsupported(String method) {
    return PlatformException(
      code: 'UNSUPPORTED_OPERATION',
      message: '$method is not supported on the web platform.',
    );
  }
}
