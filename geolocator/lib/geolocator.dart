import 'dart:async';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

//#region   deprecated methods
/// Returns a [Future] indicating if the user allows the App to access
/// the device's location.
@Deprecated('Call Geolocator.checkPermission() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<LocationPermission> checkPermission() =>
    GeolocatorPlatform.instance.checkPermission();

/// Request permission to access the location of the device.
///
/// Returns a [Future] which when completes indicates if the user granted
/// permission to access the device's location.
/// Throws a [PermissionDefinitionsNotFoundException] when the required
/// platform specific configuration is missing (e.g. in the
/// AndroidManifest.xml on Android or the Info.plist on iOS).
/// A [PermissionRequestInProgressException] is thrown if permissions are
/// requested while an earlier request has not yet been completed.
@Deprecated('Call Geolocator.requestPermission() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<LocationPermission> requestPermission() =>
    GeolocatorPlatform.instance.requestPermission();

/// Returns a [Future] containing a [bool] value indicating whether location
/// services are enabled on the device.
@Deprecated('Call Geolocator.isLocationServiceEnabled() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<bool> isLocationServiceEnabled() =>
    GeolocatorPlatform.instance.isLocationServiceEnabled();

/// Returns the last known position stored on the users device.
///
/// On Android you can force the plugin to use the old Android
/// LocationManager implementation over the newer FusedLocationProvider by
/// passing true to the [forceAndroidLocationManager] parameter. On iOS
/// this parameter is ignored.
/// When no position is available, null is returned.
/// Throws a [PermissionDeniedException] when trying to request the device's
/// location when the user denied access.
@Deprecated('Call Geolocator.getLastKnownPosition() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<Position> getLastKnownPosition(
        {bool forceAndroidLocationManager = false}) =>
    GeolocatorPlatform.instance.getLastKnownPosition(
        forceAndroidLocationManager: forceAndroidLocationManager);

/// Returns the current position taking the supplied [desiredAccuracy] into
/// account.
///
/// You can control the precision of the location updates by supplying the
/// [desiredAccuracy] parameter (defaults to "best"). On Android you can
/// force the use of the Android LocationManager instead of the
/// FusedLocationProvider by setting the [forceAndroidLocationManager]
/// parameter to true. The [timeLimit] parameter allows you to specify a
/// timeout interval (by default no time limit is configured).
///
/// Throws a [TimeoutException] when no location is received within the
/// supplied [timeLimit] duration.
/// Throws a [PermissionDeniedException] when trying to request the device's
/// location when the user denied access.
/// Throws a [LocationServiceDisabledException] when the user allowed access,
/// but the location services of the device are disabled.
@Deprecated('Call Geolocator.getCurrentPosition() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<Position> getCurrentPosition({
  LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  bool forceAndroidLocationManager = false,
  Duration timeLimit,
}) =>
    GeolocatorPlatform.instance.getCurrentPosition(
      desiredAccuracy: desiredAccuracy,
      forceAndroidLocationManager: forceAndroidLocationManager,
      timeLimit: timeLimit,
    );

/// Fires whenever the location changes inside the bounds of the
/// [desiredAccuracy].
///
/// This event starts all location sensors on the device and will keep them
/// active until you cancel listening to the stream or when the application
/// is killed.
///
/// ```
/// StreamSubscription<Position> positionStream = getPositionStream()
///     .listen((Position position) {
///       // Handle position changes
///     });
///
/// // When no longer needed cancel the subscription
/// positionStream.cancel();
/// ```
///
/// You can control the precision of the location updates by supplying the
/// [desiredAccuracy] parameter (defaults to "best"). The [distanceFilter]
/// parameter controls the minimum distance the device needs to move before
/// the update is emitted (default value is 0 indicator no filter is used).
/// On Android you can force the use of the Android LocationManager instead
/// of the FusedLocationProvider by setting the [forceAndroidLocationManager]
/// parameter to true. Using the [timeInterval] you can control the amount of
/// time that needs to pass before the next position update is send. The
/// [timeLimit] parameter allows you to specify a timeout interval (by
/// default no time limit is configured).
///
/// Throws a [TimeoutException] when no location is received within the
/// supplied [timeLimit] duration.
/// Throws a [PermissionDeniedException] when trying to request the device's
/// location when the user denied access.
/// Throws a [LocationServiceDisabledException] when the user allowed access,
/// but the location services of the device are disabled.
@Deprecated('Call Geolocator.getPositionStream() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Stream<Position> getPositionStream({
  LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  int distanceFilter = 0,
  bool forceAndroidLocationManager = false,
  int timeInterval = 0,
  Duration timeLimit,
}) =>
    GeolocatorPlatform.instance.getPositionStream(
      desiredAccuracy: desiredAccuracy,
      distanceFilter: distanceFilter,
      forceAndroidLocationManager: forceAndroidLocationManager,
      timeInterval: timeInterval,
      timeLimit: timeLimit,
    );

/// Opens the App settings page.
///
/// Returns [true] if the location settings page could be opened, otherwise
/// [false] is returned.
@Deprecated('Call Geolocator.openAppSettings() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<bool> openAppSettings() => GeolocatorPlatform.instance.openAppSettings();

/// Opens the location settings page.
///
/// Returns [true] if the location settings page could be opened, otherwise
/// [false] is returned.
@Deprecated('Call Geolocator.openLocationSettings() instead.'
    'This  feature was deprecated after 6.0.0+4.')
Future<bool> openLocationSettings() =>
    GeolocatorPlatform.instance.openLocationSettings();

/// Calculates the distance between the supplied coordinates in meters.
///
/// The distance between the coordinates is calculated using the Haversine
/// formula (see https://en.wikipedia.org/wiki/Haversine_formula). The
/// supplied coordinates [startLatitude], [startLongitude], [endLatitude] and
/// [endLongitude] should be supplied in degrees.
@Deprecated('Call Geolocator.distanceBetween() instead.'
    'This  feature was deprecated after 6.0.0+4.')
double distanceBetween(
  double startLatitude,
  double startLongitude,
  double endLatitude,
  double endLongitude,
) =>
    GeolocatorPlatform.instance.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

/// Calculates the initial bearing between two points
///
/// The initial bearing will most of the time be different than the end
/// bearing, see https://www.movable-type.co.uk/scripts/latlong.html#bearing.
/// The supplied coordinates [startLatitude], [startLongitude], [endLatitude]
/// and [endLongitude] should be supplied in degrees.
@Deprecated('Call geolocator.bearingBetween() instead.'
    'This  feature was deprecated after 6.0.0+4.')
double bearingBetween(
  double startLatitude,
  double startLongitude,
  double endLatitude,
  double endLongitude,
) =>
    GeolocatorPlatform.instance.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
//#endregion

/// Wraps CLLocationManager (on iOS) and FusedLocationProviderClient or
/// LocationManager
/// (on Android), providing support to retrieve position information
/// of the device.
///
/// Permissions are automatically handled when retrieving position information.
/// However utility methods for manual permission management are also
/// provided.
class Geolocator {
  /// Returns a [Future] indicating if the user allows the App to access
  /// the device's location.
  static Future<LocationPermission> checkPermission() =>
      GeolocatorPlatform.instance.checkPermission();

  /// Request permission to access the location of the device.
  ///
  /// Returns a [Future] which when completes indicates if the user granted
  /// permission to access the device's location.
  /// Throws a [PermissionDefinitionsNotFoundException] when the required
  /// platform specific configuration is missing (e.g. in the
  /// AndroidManifest.xml on Android or the Info.plist on iOS).
  /// A [PermissionRequestInProgressException] is thrown if permissions are
  /// requested while an earlier request has not yet been completed.
  static Future<LocationPermission> requestPermission() =>
      GeolocatorPlatform.instance.requestPermission();

  /// Returns a [Future] containing a [bool] value indicating whether location
  /// services are enabled on the device.
  static Future<bool> isLocationServiceEnabled() =>
      GeolocatorPlatform.instance.isLocationServiceEnabled();

  /// Returns the last known position stored on the users device.
  ///
  /// On Android you can force the plugin to use the old Android
  /// LocationManager implementation over the newer FusedLocationProvider by
  /// passing true to the [forceAndroidLocationManager] parameter. On iOS
  /// this parameter is ignored.
  /// When no position is available, null is returned.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  static Future<Position> getLastKnownPosition(
          {bool forceAndroidLocationManager = false}) =>
      GeolocatorPlatform.instance.getLastKnownPosition(
          forceAndroidLocationManager: forceAndroidLocationManager);

  /// Returns the current position taking the supplied [desiredAccuracy] into
  /// account.
  ///
  /// You can control the precision of the location updates by supplying the
  /// [desiredAccuracy] parameter (defaults to "best"). On Android you can
  /// force the use of the Android LocationManager instead of the
  /// FusedLocationProvider by setting the [forceAndroidLocationManager]
  /// parameter to true. The [timeLimit] parameter allows you to specify a
  /// timeout interval (by default no time limit is configured).
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  static Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration timeLimit,
  }) =>
      GeolocatorPlatform.instance.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );

  /// Fires whenever the location changes inside the bounds of the
  /// [desiredAccuracy].
  ///
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application
  /// is killed.
  ///
  /// ```
  /// StreamSubscription<Position> positionStream = getPositionStream()
  ///     .listen((Position position) {
  ///       // Handle position changes
  ///     });
  ///
  /// // When no longer needed cancel the subscription
  /// positionStream.cancel();
  /// ```
  ///
  /// You can control the precision of the location updates by supplying the
  /// [desiredAccuracy] parameter (defaults to "best"). The [distanceFilter]
  /// parameter controls the minimum distance the device needs to move before
  /// the update is emitted (default value is 0 indicator no filter is used).
  /// On Android you can force the use of the Android LocationManager instead
  /// of the FusedLocationProvider by setting the [forceAndroidLocationManager]
  /// parameter to true. Using the [intervalDuration] you can control the amount
  /// of time that needs to pass before the next position update is send. The
  /// [timeLimit] parameter allows you to specify a timeout interval (by
  /// default no time limit is configured).
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  static Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    @Deprecated('The timeInterval parameter has been deprecated, use the '
        'intervalDuration parameter instead')
        int timeInterval = 0,
    Duration intervalDuration,
    Duration timeLimit,
  }) =>
      GeolocatorPlatform.instance.getPositionStream(
        desiredAccuracy: desiredAccuracy,
        distanceFilter: distanceFilter,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeInterval: intervalDuration?.inMilliseconds ?? timeInterval,
        timeLimit: timeLimit,
      );

  /// Opens the App settings page.
  ///
  /// Returns [true] if the location settings page could be opened, otherwise
  /// [false] is returned.
  static Future<bool> openAppSettings() =>
      GeolocatorPlatform.instance.openAppSettings();

  /// Opens the location settings page.
  ///
  /// Returns [true] if the location settings page could be opened, otherwise
  /// [false] is returned.
  static Future<bool> openLocationSettings() =>
      GeolocatorPlatform.instance.openLocationSettings();

  /// Calculates the distance between the supplied coordinates in meters.
  ///
  /// The distance between the coordinates is calculated using the Haversine
  /// formula (see https://en.wikipedia.org/wiki/Haversine_formula). The
  /// supplied coordinates [startLatitude], [startLongitude], [endLatitude] and
  /// [endLongitude] should be supplied in degrees.
  static double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  /// Calculates the initial bearing between two points
  ///
  /// The initial bearing will most of the time be different than the end
  /// bearing, see https://www.movable-type.co.uk/scripts/latlong.html#bearing.
  /// The supplied coordinates [startLatitude], [startLongitude], [endLatitude]
  /// and [endLongitude] should be supplied in degrees.
  static double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
}
