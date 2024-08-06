import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

export 'package:geolocator_android/geolocator_android.dart'
    show
        AndroidSettings,
        ForegroundNotificationConfig,
        AndroidResource,
        AndroidPosition;
export 'package:geolocator_apple/geolocator_apple.dart'
    show AppleSettings, ActivityType;
export 'package:geolocator_web/web_settings.dart' show WebSettings;
export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

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
  static Future<Position?> getLastKnownPosition(
          {bool forceAndroidLocationManager = false}) =>
      GeolocatorPlatform.instance.getLastKnownPosition(
          forceLocationManager: forceAndroidLocationManager);

  /// Returns the current position.
  ///
  /// You can control the behavior of the location update by specifying an instance of
  /// the [LocationSettings] class for the [locationSettings] parameter.
  /// Standard settings are:
  /// * `LocationSettings.accuracy`: allows controlling the precision of the position updates by
  /// supplying (defaults to "best");
  /// * `LocationSettings.distanceFilter`: allows controlling the minimum
  /// distance the device needs to move before the update is emitted (default
  /// value is 0 which indicates no filter is used);
  /// * `LocationSettings.timeLimit`: allows for setting a timeout interval. If
  /// between fetching locations the timeout interval is exceeded a
  /// [TimeoutException] will be thrown. By default no time limit is configured.
  ///
  /// If you want to specify platform specific settings you can use the
  /// [AndroidSettings], [AppleSettings] and [WebSettings] classes.
  ///
  /// You can control the precision of the location updates by supplying the
  /// [desiredAccuracy] parameter (defaults to "best").
  /// On Android you can force the use of the Android LocationManager instead of
  /// the FusedLocationProvider by setting the [forceAndroidLocationManager]
  /// parameter to true. The [timeLimit] parameter allows you to specify a
  /// timeout interval (by default no time limit is configured).
  ///
  /// Calling the [getCurrentPosition] method will request the platform to
  /// obtain a location fix. Depending on the availability of different location
  /// services, this can take several seconds. The recommended use would be to
  /// call the [getLastKnownPosition] method to receive a cached position and
  /// update it with the result of the [getCurrentPosition] method.
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  ///
  ///
  /// **Note**: On Android the location *accuracy* is interpreted as
  /// [location *priority*](https://developers.google.com/android/reference/com/google/android/gms/location/Priority#constants).
  /// The interpretation works as follows:
  ///
  /// [LocationAccuracy.lowest] -> [PRIORITY_PASSIVE](https://developers.google.com/android/reference/com/google/android/gms/location/Priority#public-static-final-int-priority_passive):
  /// Ensures that no extra power will be used to derive locations. This
  /// enforces that the request will act as a passive listener that will only
  /// receive "free" locations calculated on behalf of other clients, and no
  /// locations will be calculated on behalf of only this request.
  ///
  /// [LocationAccuracy.low] -> [PRIORITY_LOW_POWER](https://developers.google.com/android/reference/com/google/android/gms/location/Priority#public-static-final-int-priority_low_power):
  /// Requests a tradeoff that favors low power usage at the possible expense of
  /// location accuracy.
  ///
  /// [LocationAccuracy.medium] -> [PRIORITY_BALANCED_POWER_ACCURACY](https://developers.google.com/android/reference/com/google/android/gms/location/Priority#public-static-final-int-priority_balanced_power_accuracy):
  /// Requests a tradeoff that is balanced between location accuracy and power
  /// usage.
  ///
  /// [LocationAccuracy.high]+ -> [PRIORITY_HIGH_ACCURACY](https://developers.google.com/android/reference/com/google/android/gms/location/Priority#public-static-final-int-priority_high_accuracy):
  /// Requests a tradeoff that favors highly accurate locations at the possible
  /// expense of additional power usage.
  static Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
    @Deprecated(
        "use settings parameter with AndroidSettings, AppleSettings, WebSettings, or LocationSettings")
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    @Deprecated(
        "use settings parameter with AndroidSettings, AppleSettings, WebSettings, or LocationSettings")
    bool forceAndroidLocationManager = false,
    @Deprecated(
        "use settings parameter with AndroidSettings, AppleSettings, WebSettings, or LocationSettings")
    Duration? timeLimit,
  }) {
    LocationSettings? settings;

    if (locationSettings != null) {
      settings = locationSettings;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: desiredAccuracy,
        forceLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );
    }

    settings ??= LocationSettings(
      accuracy: desiredAccuracy,
      timeLimit: timeLimit,
    );

    return GeolocatorPlatform.instance
        .getCurrentPosition(locationSettings: settings);
  }

  /// Fires whenever the location changes inside the bounds of the
  /// supplied [LocationSettings.accuracy].
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
  /// You can control the behavior of the stream by specifying an instance of
  /// the [LocationSettings] class for the [locationSettings] parameter.
  /// Standard settings are:
  /// * `LocationSettings.accuracy`: allows controlling the precision of the position updates by
  /// supplying (defaults to "best");
  /// * `LocationSettings.distanceFilter`: allows controlling the minimum
  /// distance the device needs to move before the update is emitted (default
  /// value is 0 which indicates no filter is used);
  /// * `LocationSettings.timeLimit`: allows for setting a timeout interval. If
  /// between fetching locations the timeout interval is exceeded a
  /// [TimeoutException] will be thrown. By default no time limit is configured.
  ///
  /// If you want to specify platform specific settings you can use the
  /// [AndroidSettings], [AppleSettings] and [WebSettings] classes.
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  static Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) =>
      GeolocatorPlatform.instance.getPositionStream(
        locationSettings: locationSettings,
      );

  /// Returns a [Future] containing a [LocationAccuracyStatus]
  /// When the user has given permission for approximate location,
  /// [LocationAccuracyStatus.reduced] will be returned, if the user has
  /// given permission for precise location, [LocationAccuracyStatus.precise]
  /// will be returned
  static Future<LocationAccuracyStatus> getLocationAccuracy() =>
      GeolocatorPlatform.instance.getLocationAccuracy();

  /// Fires whenever the location services are disabled/enabled in the notification
  /// bar or in the device settings. Returns ServiceStatus.enabled when location
  /// services are enabled and returns ServiceStatus.disabled when location
  /// services are disabled
  static Stream<ServiceStatus> getServiceStatusStream() =>
      GeolocatorPlatform.instance.getServiceStatusStream();

  /// Requests temporary precise location when the user only gave permission
  /// for approximate location (iOS 14+ only)
  ///
  /// When using this method, the value of the required property `purposeKey`
  /// should match the <key> value given in the
  /// `NSLocationTemporaryUsageDescription` dictionary in the
  /// Info.plist.
  ///
  /// Throws a [PermissionDefinitionsNotFoundException] when the necessary key
  /// in the Info.plist is not added
  /// Returns [LocationAccuracyStatus.precise] when using iOS 13 or below or
  /// using other platforms.
  static Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) =>
      GeolocatorPlatform.instance.requestTemporaryFullAccuracy(
        purposeKey: purposeKey,
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
