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

  /// Creates a GeolocatorPlugin
  ///
  /// This constructor is public for testing purposes only. It should not be
  /// used outside this class.
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
    bool forceLocationManager = false,
  }) =>
      throw _unsupported('getLastKnownPosition');

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    final result = await _geolocation.getCurrentPosition(
      enableHighAccuracy: _enableHighAccuracy(locationSettings?.accuracy),
      timeout: locationSettings?.timeLimit,
    );

    return result;
  }

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    Position? previousPosition;

    return _geolocation
        .watchPosition(
      enableHighAccuracy: _enableHighAccuracy(locationSettings?.accuracy),
      timeout: locationSettings?.timeLimit,
    )
        .skipWhile((geoposition) {
      if (locationSettings?.distanceFilter == 0 ||
          locationSettings?.distanceFilter == null) {
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
      return distance < locationSettings!.distanceFilter;
    });
  }

  @override
  Future<bool> openAppSettings() => throw _unsupported('openAppSettings');

  @override
  Future<bool> openLocationSettings() =>
      throw _unsupported('openLocationSettings');

  bool _enableHighAccuracy(LocationAccuracy? accuracy) {
    if (accuracy == null) {
      return false;
    }
    switch (accuracy) {
      case LocationAccuracy.lowest:
      case LocationAccuracy.low:
      case LocationAccuracy.medium:
      case LocationAccuracy.reduced:
        return false;
      case LocationAccuracy.high:
      case LocationAccuracy.best:
      case LocationAccuracy.bestForNavigation:
        return true;
    }
  }

  PlatformException _unsupported(String method) {
    return PlatformException(
      code: 'UNSUPPORTED_OPERATION',
      message: '$method is not supported on the web platform.',
    );
  }
}
