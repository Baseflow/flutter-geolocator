library geolocator;

import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:meta/meta.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:vector_math/vector_math.dart';
import 'package:equatable/equatable.dart';

part 'models/geolocation_enums.dart';
part 'models/location_accuracy.dart';
part 'models/location_options.dart';
part 'models/placemark.dart';
part 'models/position.dart';
part 'utils/codec.dart';

/// Provides easy access to the platform specific location services (CLLocationManager on iOS and FusedLocationProviderClient on Android)
class Geolocator {
  /// Constructs a singleton instance of [Geolocator].
  ///
  /// When a second instance is created, the first instance will not be able to listen to the
  /// EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  /// misuse of creating a second instance from a programmer.
  factory Geolocator() {
    if (_singleton == null) {
      const MethodChannel methodChannel =
          MethodChannel('flutter.baseflow.com/geolocator/methods');
      const EventChannel eventChannel =
          EventChannel('flutter.baseflow.com/geolocator/events');

      _singleton = Geolocator.private(
          methodChannel, eventChannel, LocationPermissions());
    }
    return _singleton;
  }

  /// This constructor is only used for testing and shouldn't be accessed by
  /// users of the plugin.
  @visibleForTesting
  Geolocator.private(
    this._methodChannel,
    this._eventChannel,
    this._permissionHandler,
  );

  static Geolocator _singleton;
  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  final LocationPermissions _permissionHandler;
  Stream<Position> _onPositionChanged;

  /// Returns a [Future] containing the current [GeolocationStatus] indicating the availability of location services on the device.
  Future<GeolocationStatus> checkGeolocationPermissionStatus(
      {GeolocationPermission locationPermission =
          GeolocationPermission.location}) async {
    final PermissionStatus permissionStatus = await _permissionHandler
        .checkPermissionStatus(level: toPermissionLevel(locationPermission));

    return fromPermissionStatus(permissionStatus);
  }

  /// Returns a [Future] containing a [bool] value indicating whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled() async {
    final ServiceStatus serviceStatus =
        await _permissionHandler.checkServiceStatus();

    return serviceStatus == ServiceStatus.enabled ? true : false;
  }

  /// On Android devices you can set [forceAndroidLocationManager]
  /// to true to force the plugin to use the [LocationManager] to determine the
  /// position instead of the [FusedLocationProviderClient]. On iOS this is ignored.
  bool forceAndroidLocationManager = false;

  GooglePlayServicesAvailability _googlePlayServicesAvailability;

  Future<bool> _shouldForceAndroidLocationManager() async {
    // By doing this check here, we save the App from always checking if Google Play Services
    // are available (which is not necessary if the developer wants to force the use of the LocationManager).
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
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    GeolocationPermission locationPermissionLevel =
        GeolocationPermission.location,
  }) async {
    final PermissionStatus permission = await _getLocationPermission(
        toPermissionLevel(locationPermissionLevel));

    if (permission == PermissionStatus.granted) {
      final LocationOptions locationOptions = LocationOptions(
          accuracy: desiredAccuracy,
          distanceFilter: 0,
          forceAndroidLocationManager:
              await _shouldForceAndroidLocationManager());
      final Map<dynamic, dynamic> positionMap =
          await _methodChannel.invokeMethod('getCurrentPosition',
              Codec.encodeLocationOptions(locationOptions));

      try {
        return Position.fromMap(positionMap);
      } on ArgumentError {
        return null;
      }
    } else {
      _handleInvalidPermissions(permission);
    }

    return null;
  }

  /// Returns the last known position stored on the users device.
  ///
  /// On Android we look for the location provider matching best with the
  /// supplied [desiredAccuracy]. On iOS this parameter is ignored.
  /// When no position is available, null is returned.
  Future<Position> getLastKnownPosition(
      {LocationAccuracy desiredAccuracy = LocationAccuracy.best,
      GeolocationPermission locationPermissionLevel =
          GeolocationPermission.location}) async {
    final PermissionStatus permission = await _getLocationPermission(
        toPermissionLevel(locationPermissionLevel));

    if (permission == PermissionStatus.granted) {
      final LocationOptions locationOptions = LocationOptions(
          accuracy: desiredAccuracy,
          distanceFilter: 0,
          forceAndroidLocationManager:
              await _shouldForceAndroidLocationManager());
      final Map<dynamic, dynamic> positionMap =
          await _methodChannel.invokeMethod('getLastKnownPosition',
              Codec.encodeLocationOptions(locationOptions));

      try {
        return Position.fromMap(positionMap);
      } on ArgumentError {
        return null;
      }
    } else {
      _handleInvalidPermissions(permission);
    }

    return null;
  }

  /// Fires whenever the location changes outside the bounds of the [desiredAccuracy].
  ///
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application
  /// is killed.
  ///
  /// ```
  /// StreamSubscription<Position> positionStream = new Geolocator().GetPostionStream().listen(
  ///   (Position position) => {
  ///     // Handle position changes
  ///   });
  ///
  /// // When no longer needed cancel the subscription
  /// positionStream.cancel();
  /// ```
  ///
  /// You can customize the behaviour of the location updates by supplying an
  /// instance [LocationOptions] class. When you don't supply any specific
  /// options, default values will be used for each setting.
  Stream<Position> getPositionStream(
      [LocationOptions locationOptions = const LocationOptions(),
      GeolocationPermission locationPermissionLevel =
          GeolocationPermission.location]) async* {
    final PermissionStatus permission = await _getLocationPermission(
        toPermissionLevel(locationPermissionLevel));

    if (permission == PermissionStatus.granted) {
      _onPositionChanged ??= _eventChannel
          .receiveBroadcastStream(Codec.encodeLocationOptions(locationOptions))
          .map<Position>((dynamic element) =>
              Position.fromMap(element.cast<String, dynamic>()));

      yield* _onPositionChanged;
    } else {
      _handleInvalidPermissions(permission);
    }
  }

  Future<PermissionStatus> _getLocationPermission(
      LocationPermissionLevel locationPermissionLevel) async {
    final PermissionStatus permission = await _permissionHandler
        .checkPermissionStatus(level: locationPermissionLevel);

    if (permission != PermissionStatus.granted) {
      final PermissionStatus permissionStatus = await _permissionHandler
          .requestPermissions(permissionLevel: locationPermissionLevel);

      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permission) {
    if (permission == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null);
    }
  }

  /// Returns a list of [Placemark] instances found for the supplied address.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied address could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be returned.
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The `localeIdentifier` should be formatted using the syntax: [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromAddress(String address,
      {String localeIdentifier}) async {
    final Map<String, String> parameters = <String, String>{'address': address};
    if (localeIdentifier != null) {
      parameters['localeIdentifier'] = localeIdentifier;
    }

    final List<dynamic> placemarks =
        await _methodChannel.invokeMethod('placemarkFromAddress', parameters);
    return Placemark.fromMaps(placemarks);
  }

  /// Returns a list of [Placemark] instances found for the supplied coordinates.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied coordinates could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be returned.
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The `localeIdentifier` should be formatted using the syntax: [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String localeIdentifier,
  }) async {
    final Map<String, dynamic> parameters = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude
    };

    if (localeIdentifier != null) {
      parameters['localeIdentifier'] = localeIdentifier;
    }

    final List<dynamic> placemarks = await _methodChannel.invokeMethod(
        'placemarkFromCoordinates', parameters);

    return Placemark.fromMaps(placemarks);
  }

  /// Convenience method to access [placemarkFromCoordinates()] using an
  /// instance of [Position].
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The `localeIdentifier` should be formatted using the syntax: [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromPosition(
    Position position, {
    String localeIdentifier,
  }) =>
      placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: localeIdentifier,
      );

  /// Returns the distance between the supplied coordinates in meters.
  Future<double> distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      _methodChannel.invokeMethod<dynamic>('distanceBetween', <String, double>{
        'startLatitude': startLatitude,
        'startLongitude': startLongitude,
        'endLatitude': endLatitude,
        'endLongitude': endLongitude
      }).then<double>((dynamic result) => result);

  /// Returns the initial bearing between two points
  /// The initial bearing will most of the time be different than the end bearing, see [https://www.movable-type.co.uk/scripts/latlong.html#bearing]
  Future<double> bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var startLongitudeRadians = radians(startLongitude);
    var startLatitudeRadians = radians(startLatitude);
    var endLongitudeRadians = radians(endLongitude);
    var endLatitudeRadians = radians(endLatitude);

    var y = sin(endLongitudeRadians - startLongitudeRadians) *
        cos(endLatitudeRadians);
    var x = cos(startLatitudeRadians) * sin(endLatitudeRadians) -
        sin(startLatitudeRadians) *
            cos(endLatitudeRadians) *
            cos(endLongitudeRadians - startLongitudeRadians);

    return Future.value(degrees(atan2(y, x)));
  }
}
