import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../geolocator_platform_interface.dart';
import '../enums/enums.dart';
import '../errors/errors.dart';
import '../extensions/extensions.dart';
import '../geolocator_platform_interface.dart';
import '../models/location_options.dart';
import '../models/position.dart';

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

  /// On Android devices you can set [forceAndroidLocationManager]
  /// to true to force the plugin to use the [LocationManager] to determine the
  /// position instead of the [FusedLocationProviderClient]. On iOS this is
  /// ignored.
  bool forceAndroidLocationManager = false;

  Stream<Position> _positionStream;

  @override
  Future<LocationPermission> checkPermission() async {
    try {
      // ignore: omit_local_variable_types
      final int permission =
          await methodChannel.invokeMethod('checkPermission');

      return permission.toLocationPermission();
    } on PlatformException catch (e) {
      _handlePlatformException(e);

      rethrow;
    }
  }

  @override
  Future<LocationPermission> requestPermission() async {
    try {
      // ignore: omit_local_variable_types
      final int permission =
          await methodChannel.invokeMethod('requestPermission');

      return permission.toLocationPermission();
    } on PlatformException catch (e) {
      _handlePlatformException(e);

      rethrow;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async =>
      methodChannel.invokeMethod('isLocationServiceEnabled');

  @override
  Future<Position> getLastKnownPosition({
    bool forceAndroidLocationManager = false,
  }) async {
    try {
      final parameters = <String, dynamic>{
        'forceAndroidLocationManager': forceAndroidLocationManager,
      };

      final positionMap =
          await methodChannel.invokeMethod('getLastKnownPosition', parameters);

      return Position.fromMap(positionMap);
    } on PlatformException catch (e) {
      _handlePlatformException(e);

      rethrow;
    }
  }

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration timeLimit,
  }) async {
    final locationOptions = LocationOptions(
      accuracy: desiredAccuracy,
      forceAndroidLocationManager: forceAndroidLocationManager,
    );

    try {
      Future<dynamic> positionFuture;

      if (timeLimit != null) {
        positionFuture = methodChannel
            .invokeMethod(
              'getCurrentPosition',
              locationOptions.toJson(),
            )
            .timeout(timeLimit);
      } else {
        positionFuture = methodChannel.invokeMethod(
          'getCurrentPosition',
          locationOptions.toJson(),
        );
      }

      final positionMap = await positionFuture;
      return Position.fromMap(positionMap);
    } on PlatformException catch (e) {
      _handlePlatformException(e);

      rethrow;
    }
  }

  @override
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    int timeInterval = 0,
    Duration timeLimit,
  }) {
    final locationOptions = LocationOptions(
      accuracy: desiredAccuracy,
      distanceFilter: distanceFilter,
      forceAndroidLocationManager: forceAndroidLocationManager,
      timeInterval: timeInterval,
    );

    if (_positionStream != null) {
      return _positionStream;
    }

    var positionStream = eventChannel.receiveBroadcastStream(
      locationOptions.toJson(),
    );

    if (timeLimit != null) {
      positionStream = positionStream.timeout(
        timeLimit,
        onTimeout: (s) {
          s.addError(TimeoutException(
            'Time limit reached while waiting for position update.',
            timeLimit,
          ));
          s.close();
          _positionStream = null;
        },
      );
    }

    _positionStream = positionStream
        .map<Position>((dynamic element) =>
            Position.fromMap(element.cast<String, dynamic>()))
        .handleError(
      (error) {
        _positionStream = null;
        if (error is PlatformException) {
          _handlePlatformException(error);
        }

        throw error;
      },
    );

    return _positionStream;
  }

  @override
  Future<bool> openAppSettings() async =>
      methodChannel.invokeMethod('openAppSettings');

  @override
  Future<bool> openLocationSettings() async =>
      methodChannel.invokeMethod('openLocationSettings');

  void _handlePlatformException(PlatformException exception) {
    switch (exception.code) {
      case 'LOCATION_SERVICES_DISABLED':
        throw LocationServiceDisabledException();
      case 'LOCATION_SUBSCRIPTION_ACTIVE':
        throw AlreadySubscribedException();
      case 'PERMISSION_DEFINITIONS_NOT_FOUND':
        throw PermissionDefinitionsNotFoundException(exception.message);
      case 'PERMISSION_DENIED':
        throw PermissionDeniedException(exception.message);
      case 'PERMISSION_REQUEST_IN_PROGRESS':
        throw PermissionRequestInProgressException(exception.message);
      case 'LOCATION_UPDATE_FAILURE':
        throw PositionUpdateException(exception.message);
      default:
        throw exception;
    }
  }
}
