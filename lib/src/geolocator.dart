library geolocator;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/src/models/geolocation_enums.dart';
import 'package:geolocator/src/models/location_accuracy.dart';
import 'package:geolocator/src/models/location_options.dart';
import 'package:geolocator/src/models/placemark.dart';
import 'package:geolocator/src/models/position.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

/// Provides easy access to the platform specific location services
/// (CLLocationManager on iOS and FusedLocationProviderClient on Android)

class Geolocator {
  const Geolocator._();

  static const MethodChannel methodChannel =
      MethodChannel('flutter.baseflow.com/geolocator/methods');
  static const EventChannel eventChannel =
      EventChannel('flutter.baseflow.com/geolocator/events');

  static const Geolocator instance = Geolocator._();

  static Observable<Position> _positions;

  /// Returns a [Future] containing the current [GeolocationStatus] indicating
  /// the availability of location services on the device.
  Future<GeolocationStatus> checkGeolocationPermissionStatus(
      {GeolocationPermission locationPermission =
          GeolocationPermission.location}) async {
    final PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(permission(locationPermission));
    return status(permissionStatus);
  }

  /// Indicates whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled() async {
    final ServiceStatus serviceStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);

    return serviceStatus == ServiceStatus.enabled;
  }

  static GooglePlayServicesAvailability _googlePlayServicesAvailability;

  FutureOr<bool> _shouldForceAndroidLocationManager(
      [bool forceAndroidLocationManager]) async {
    forceAndroidLocationManager ??= false;
    // By doing this check here, we save the App from always checking if Google
    // Play Services are available (which is not necessary if the developer
    // wants to force the use of the LocationManager).
    if (forceAndroidLocationManager) {
      return true;
    }

    _googlePlayServicesAvailability ??= await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability();

    return _googlePlayServicesAvailability !=
        GooglePlayServicesAvailability.success;
  }

  /// Returns the current position taking the supplied [desiredAccuracy] into account.
  ///
  /// When the [desiredAccuracy] is not supplied, it defaults to best.
  ///
  /// On Android devices you can set [forceAndroidLocationManager] to true to
  /// force the plugin to use the [LocationManager] to determine the position
  /// instead of the [FusedLocationProviderClient].
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
  }) async {
    assert(desiredAccuracy != null);
    final PermissionStatus permission = await _getLocationPermission();

    print('PermissionStatus: $permission');
    if (permission == PermissionStatus.granted) {
      final bool forceLocationManager =
          await _shouldForceAndroidLocationManager(forceAndroidLocationManager);

      print('forceLocationManager: $forceLocationManager');
      final LocationOptions locationOptions = LocationOptions.fromValues(
        accuracy: desiredAccuracy,
        distanceFilter: 0,
        forceAndroidLocationManager: forceLocationManager,
      );

      print('locationOptions.json: ${locationOptions.json}');
      final Map<dynamic, dynamic> positionMap =
          await methodChannel.invokeMethod(
        'getCurrentPosition',
        locationOptions.json,
      );

      print('positionMap: $positionMap');

      return Position.fromJson(positionMap);
    } else {
      throw _handleInvalidPermissions(permission);
    }
  }

  /// Returns the last known position stored on the users device.
  ///
  /// On Android we look for the location provider matching best with the
  /// supplied [desiredAccuracy]. On iOS this parameter is ignored.
  /// When no position is available, null is returned.
  ///
  /// On Android devices you can set [forceAndroidLocationManager] to true to
  /// force the plugin to use the [LocationManager] to determine the position
  /// instead of the [FusedLocationProviderClient].
  Future<Position> getLastKnownPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
  }) async {
    assert(desiredAccuracy != null);
    final PermissionStatus permission = await _getLocationPermission();

    if (permission == PermissionStatus.granted) {
      final bool forceLocationManager =
          await _shouldForceAndroidLocationManager(forceAndroidLocationManager);

      final LocationOptions locationOptions = LocationOptions.fromValues(
        accuracy: desiredAccuracy,
        distanceFilter: 0,
        forceAndroidLocationManager: forceLocationManager,
      );
      final Map<dynamic, dynamic> positionMap =
          await methodChannel.invokeMethod(
        'getLastKnownPosition',
        locationOptions.json,
      );

      return Position.fromJson(positionMap);
    } else {
      throw _handleInvalidPermissions(permission);
    }
  }

  /// Fires whenever the location changes outside the bounds of the
  /// [desiredAccuracy].
  ///
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application
  /// is killed.
  ///
  /// ```
  /// final StreamSubscription<Position> positionStream =
  ///     Geolocator.instance.getPosition().listen((Position position) {
  ///   // Handle position changes
  /// });
  ///
  /// // When no longer needed cancel the subscription
  /// positionStream.cancel();
  /// ```
  ///
  /// You can customize the behaviour of the location updates by supplying an
  /// instance [LocationOptions] class. When you don't supply any specific
  /// options, default values will be used for each setting.
  ///
  /// NOTE: Make sure to unsubscribe from the stream when your are done.
  Stream<Position> getPosition([LocationOptions options]) {
    options ??= LocationOptions.defaultOptions;

    return _positions ??= Observable<PermissionStatus>.fromFuture(
            _getLocationPermission())
        .flatMap((PermissionStatus status) => status == PermissionStatus.granted
            ? Observable<dynamic>(
                    eventChannel.receiveBroadcastStream(options.json))
                .map(Position.fromJson)
            : Observable<Position>.error(_handleInvalidPermissions(status)))
        .share()
        .doOnCancel(() => _positions = null)
        .doOnError((dynamic error, StackTrace stackTrace) => _positions = null);
  }

  Future<PermissionStatus> _getLocationPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      final Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions(<PermissionGroup>[PermissionGroup.location]);

      return permissionStatus[PermissionGroup.location] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  PlatformException _handleInvalidPermissions(PermissionStatus permission) {
    if (permission == PermissionStatus.denied) {
      return PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details: null,
      );
    } else if (permission == PermissionStatus.disabled) {
      return PlatformException(
        code: 'PERMISSION_DISABLED',
        message: 'Location data is not available on device',
        details: null,
      );
    }
    return null;
  }

  /// Returns a list of [Placemark] instances found for the supplied address.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied address could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be
  /// returned.
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The [localeIdentifier] should be formatted using the syntax:
  /// [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromAddress(String address,
      {String localeIdentifier}) async {
    final Map<String, String> parameters = <String, String>{'address': address};
    if (localeIdentifier != null) {
      parameters['localeIdentifier'] = localeIdentifier;
    }

    final List<dynamic> placemarks =
        await methodChannel.invokeMethod('placemarkFromAddress', parameters);
    return Placemark.fromList(placemarks).toList();
  }

  /// Returns a list of [Placemark] instances found for the supplied
  /// coordinates.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied coordinates could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be
  /// returned.
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The [localeIdentifier] should be formatted using the syntax:
  /// [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromCoordinates(
      double latitude, double longitude,
      {String localeIdentifier}) async {
    final Map<String, dynamic> parameters = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude
    };

    if (localeIdentifier != null) {
      parameters['localeIdentifier'] = localeIdentifier;
    }

    final List<dynamic> placemarks = await methodChannel.invokeMethod(
        'placemarkFromCoordinates', parameters);

    return Placemark.fromList(placemarks).toList();
  }

  /// Returns the distance between the supplied coordinates in meters.
  Future<double> distanceBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    final double result =
        await methodChannel.invokeMethod('distanceBetween', <String, double>{
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude
    });

    return result;
  }
}
