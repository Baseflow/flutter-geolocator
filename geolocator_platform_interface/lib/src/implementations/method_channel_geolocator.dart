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

  Stream<Position> _onPositionChanged;

  @override
  Future<LocationPermission> checkPermission() async {
    try {
      // ignore: omit_local_variable_types
      final int permission = await methodChannel
        .invokeMethod('checkPermission');

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
      final int permission = await methodChannel
        .invokeMethod('requestPermission');

      return permission.toLocationPermission();
    } on PlatformException catch (e, trace) {
      _handlePlatformException(e);

      rethrow;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async =>
      methodChannel.invokeMethod('isLocationServiceEnabled');

  @override
  Future<Position> getLastKnownPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  }) async {
    final locationOptions =
        LocationOptions(accuracy: desiredAccuracy, distanceFilter: 0);

    try {
      final positionMap = await methodChannel.invokeMethod(
          'getLastKnownPosition', locationOptions.toJson());

      return Position.fromMap(positionMap);
    } on PlatformException catch (e) {
      _handlePlatformException(e);

      rethrow;
    }
  }

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Duration timeLimit,
  }) => getPositionStream(
              desiredAccuracy: desiredAccuracy, timeLimit: timeLimit)
          .first;

  @override
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    int timeInterval = 0,
    Duration timeLimit,
  }) {
    final locationOptions = LocationOptions(
      accuracy: desiredAccuracy,
      distanceFilter: distanceFilter,
      timeInterval: timeInterval,
    );

    if (_onPositionChanged != null) {
      return _onPositionChanged;
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
        },
      );
    }

    _onPositionChanged = positionStream
      .map<Position>(
        (dynamic element) => Position.fromMap(element.cast<String, dynamic>()))
      .handleError(
        (error) {
          if (error is PlatformException ) {
            _handlePlatformException(error);
          }
          
          throw error;
        },
      );
    return _onPositionChanged;
  }

  void _handlePlatformException(PlatformException exception) {
    switch(exception.code) {
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
    }
  }
}
