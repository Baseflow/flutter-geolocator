import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'src/geolocation_manager.dart';
import 'src/permissions_manager.dart';
import 'src/html_geolocation_manager.dart';
import 'src/html_permissions_manager.dart';


/// The web implementation of [GeolocatorPlatform].
///
/// This class implements the `package:geolocator` functionality for the web.
class GeolocatorPlugin extends GeolocatorPlatform {
  static const _permissionQuery = {'name': 'geolocation'};

  final GeolocationManager? _geolocation;
  final PermissionsManager? _permissions;

  /// Registers this class as the default instance of [GeolocatorPlatform].
  static void registerWith(Registrar registrar) {
    final geolocation = html.window.navigator.geolocation;
    final permissions = html.window.navigator.permissions;

    HtmlGeolocationManager? htmlGeolocation;
    HtmlPermissionsManager? htmlPermissions;

    if (geolocation != null) {
      htmlGeolocation = HtmlGeolocationManager(geolocation);
    }

    if (permissions != null) {
      htmlPermissions = HtmlPermissionsManager(permissions);
    }

    GeolocatorPlatform.instance = GeolocatorPlugin.private(
      htmlGeolocation,
      htmlPermissions,
    );
  }

  @visibleForTesting
  GeolocatorPlugin.private(GeolocationManager? geolocation, PermissionsManager? permissions)
      : _geolocation = geolocation,
        _permissions = permissions;

  bool get _locationServicesEnabled => _geolocation != null;

  @override
  Future<LocationPermission> checkPermission() async {
    if (_permissions == null) {
      throw PlatformException(
        code: 'LOCATION_SERVICES_NOT_SUPPORTED',
        message: 'Location services are not supported on this browser.',
      );
    }

    return await _permissions!.query(
      _permissionQuery,
    );
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

      return result;
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

    Position? previousPosition = null;

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
            previousPosition!.latitude as double,
            previousPosition!.longitude as double,
            geoposition.latitude as double,
            geoposition.longitude as double);
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

  PlatformException _unsupported(String method) {
    return PlatformException(
      code: 'UNSUPPORTED_OPERATION',
      message: '$method is not supported on the web platform.',
    );
  }
}
