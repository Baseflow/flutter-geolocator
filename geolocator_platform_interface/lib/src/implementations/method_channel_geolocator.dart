import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_platform_interface/src/errors/permission_denied_exception.dart';
import 'package:location_permissions/location_permissions.dart'
    as permissionLib;
import 'package:meta/meta.dart';

import '../../geolocator_platform_interface.dart';
import '../enums/enums.dart';
import '../geolocator_platform_interface.dart';
import '../models/position.dart';
import 'location_options.dart';

/// An implementation of [GeolocatorPlatform] that uses method channels.
class MethodChannelGeolocator extends GeolocatorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      MethodChannel('flutter.baseflow.com/geolocator');

  /// The event channel used to receive [Position] updates from the native
  /// platform.
  @visibleForTesting
  EventChannel eventChannel =
      EventChannel('flutter.baseflow.com/geolocator_updates');

  /// The permission handler which is used to handle requests to access
  /// the location on the device.
  @visibleForTesting
  permissionLib.LocationPermissions permissionHandler =
      permissionLib.LocationPermissions();

  /// On Android devices you can set [forceAndroidLocationManager]
  /// to true to force the plugin to use the [LocationManager] to determine the
  /// position instead of the [FusedLocationProviderClient]. On iOS this is ignored.
  bool forceAndroidLocationManager = false;

  Stream<Position> _onPositionChanged;

  @override
  Future<PermissionStatus> checkPermissions({
    Permission locationPermission = Permission.location,
  }) async {
    final permissionStatus = await permissionHandler.checkPermissionStatus(
        level: _toLocationPermissionLevel(locationPermission));

    return _fromLocationPermissionStatus(permissionStatus);
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    final permissionLib.ServiceStatus serviceStatus =
        await permissionHandler.checkServiceStatus();

    return serviceStatus == permissionLib.ServiceStatus.enabled ? true : false;
  }

  @override
  Future<Position> getLastKnownPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Permission permission = Permission.location,
  }) async {
    final permissionStatus = await _getLocationPermission(permission);

    if (permissionStatus == PermissionStatus.granted) {
      final locationOptions = LocationOptions(
          accuracy: desiredAccuracy,
          distanceFilter: 0,
          forceAndroidLocationManager: forceAndroidLocationManager);

      final positionMap = await methodChannel.invokeMethod(
          'getLastKnownPosition', locationOptions.toJson());

      try {
        return Position.fromMap(positionMap);
      } on ArgumentError {
        return null;
      }
    } else {
      throw PermissionDeniedException(permission);
    }
  }

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Permission permission = Permission.location,
    Duration timeLimit,
  }) =>
      getPositionStream(
              desiredAccuracy: desiredAccuracy,
              permission: permission,
              timeLimit: timeLimit)
          .first;

  @override
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    int timeInterval = 0,
    Permission permission = Permission.location,
    Duration timeLimit,
  }) async* {
    final permissionStatus = await _getLocationPermission(permission);
    final locationOptions = LocationOptions(
      accuracy: desiredAccuracy,
      distanceFilter: distanceFilter,
      timeInterval: timeInterval,
      forceAndroidLocationManager: forceAndroidLocationManager,
    );

    if (permissionStatus == PermissionStatus.granted) {
      if (_onPositionChanged == null) {
        final positionStream = eventChannel.receiveBroadcastStream(
          locationOptions.toJson(),
        );

        if (timeLimit != null) {
          positionStream.timeout(
            timeLimit,
            onTimeout: (s) {
              s.close();
              throw TimeoutException(
                'Time limit reached while waiting for position update.',
                timeLimit,
              );
            },
          );
        }

        _onPositionChanged = positionStream.map<Position>((dynamic element) =>
            Position.fromMap(element.cast<String, dynamic>()));
      }
      yield* _onPositionChanged;
    } else {
      throw PermissionDeniedException(permission);
    }
  }

  Future<PermissionStatus> _getLocationPermission(
    Permission permission,
  ) async {
    final locationPermissionLevel = _toLocationPermissionLevel(permission);
    var permissionStatus = await permissionHandler.checkPermissionStatus(
        level: locationPermissionLevel);

    if (permissionStatus != permissionLib.PermissionStatus.granted) {
      permissionStatus = await permissionHandler.requestPermissions(
          permissionLevel: locationPermissionLevel);
    }

    return _fromLocationPermissionStatus(permissionStatus);
  }

  static permissionLib.LocationPermissionLevel _toLocationPermissionLevel(
    Permission permission,
  ) {
    switch (permission) {
      case Permission.locationAlways:
        return permissionLib.LocationPermissionLevel.locationAlways;
      case Permission.locationWhenInUse:
        return permissionLib.LocationPermissionLevel.locationWhenInUse;
      default:
        return permissionLib.LocationPermissionLevel.location;
    }
  }

  static PermissionStatus _fromLocationPermissionStatus(
    permissionLib.PermissionStatus status,
  ) {
    switch (status) {
      case permissionLib.PermissionStatus.denied:
        return PermissionStatus.denied;
      case permissionLib.PermissionStatus.granted:
        return PermissionStatus.granted;
      case permissionLib.PermissionStatus.restricted:
        return PermissionStatus.restricted;
      default:
        return PermissionStatus.unknown;
    }
  }
}
