import 'dart:async';
import 'dart:math';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vector_math/vector_math.dart';

import 'enums/enums.dart';
import 'implementations/method_channel_geolocator.dart';
import 'models/models.dart';

/// The interface that implementations of geolocator  must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `geolocator` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [GeolocatorPlatform] methods.
abstract class GeolocatorPlatform extends PlatformInterface {
  /// Constructs a GeolocatorPlatform.
  GeolocatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static GeolocatorPlatform _instance = MethodChannelGeolocator();

  /// The default instance of [GeolocatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelGeolocator].
  static GeolocatorPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own
  /// platform-specific class that extends [GeolocatorPlatform] when they
  /// register themselves.
  static set instance(GeolocatorPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Returns a [Future] indicating if the user allows the App to access
  /// the device's location.
  ///
  /// Note: on the web platform not all browsers implement the [Permission API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API)
  /// if this is the case the `LocationPermission.unableToDetermine` is returned
  /// as the plugin cannot determine the if permissions are granted or denied.
  Future<LocationPermission> checkPermission() {
    throw UnimplementedError(
      'checkPermission() has not been implemented.',
    );
  }

  /// Request permission to access the location of the device.
  ///
  /// Returns a [Future] which when completes indicates if the user granted
  /// permission to access the device's location.
  /// Throws a [PermissionDefinitionsNotFoundException] when the required
  /// platform specific configuration is missing (e.g. in the
  /// AndroidManifest.xml on Android or the Info.plist on iOS).
  /// A [PermissionRequestInProgressException] is thrown if permissions are
  /// requested while an earlier request has not yet been completed.
  Future<LocationPermission> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  /// Returns a [Future] containing a [bool] value indicating whether location
  /// services are enabled on the device.
  Future<bool> isLocationServiceEnabled() {
    throw UnimplementedError(
      'isLocationServiceEnabled() has not been implemented.',
    );
  }

  /// Returns the last known position stored on the users device.
  ///
  /// On Android you can force the plugin to use the old Android
  /// LocationManager implementation over the newer FusedLocationProvider by
  /// passing true to the [forceLocationManager] parameter. On iOS
  /// this parameter is ignored.
  /// When no position is available, null is returned.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) {
    throw UnimplementedError(
      'getLastKnownPosition() has not been implemented.',
    );
  }

  /// Returns the current position taking the supplied [desiredAccuracy] into
  /// account.
  ///
  /// Calling the `getCurrentPosition` method will request the platform to
  /// obtain a location fix, depending on the availability of different location
  /// services this can take several seconds. The recommended use would be to
  /// call the `getLastKnownPosition` method to receive a cached position and
  /// update it with the result of the `getCurrentPosition` method.
  ///
  /// On Android you can force the use of the Android LocationManager instead of
  /// the FusedLocationProvider by setting the [forceLocationManager]
  /// parameter of [LocationSettings] to true. The [timeLimit] parameter of
  /// [LocationSettings] allows you to specify a timeout interval (by default no
  /// time limit is configured).
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) {
    throw UnimplementedError('getCurrentPosition() has not been implemented.');
  }

  /// Fires when the location Service is manually disabled or enabled.
  ///
  /// An instance of [LocationServiceStatus] will be emitted each time the
  /// location service is enabled or disabled.
  /// Throws an [UnimplementedError] on the web as the concept of location
  /// service doesn't exist on the web platform.
  Stream<ServiceStatus> getServiceStatusStream() {
    throw UnimplementedError(
        'getServiceStatusStream() has not been implemented.');
  }

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
  /// of the FusedLocationProvider by setting the [forceLocationManager]
  /// parameter of [LocationSettings] to true. Using the [timeInterval]
  /// of [LocationSettings] you can control the amount of time that needs to
  /// pass before the next position update is send.
  ///
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    throw UnimplementedError('getPositionStream() has not been implemented.');
  }

  /// Asks the user for Temporary Precise location access (iOS 14 or above).
  ///
  /// Returns [LocationAccuracyStatus.precise] if the user already gave
  /// permission to use Precise Accuracy. If the user uses iOS 13 or below,
  /// [LocationAccuracyStatus.precise] will also be returned. On other platforms
  /// an PlatformException will be thrown.
  ///
  /// The `required` property [purposeKey] should correspond with the [key]
  /// value set in the [NSLocationTemporaryUsageDescriptionDictionary]
  /// dictionary, which should be added to the `Info.plist` as stated in the
  /// [documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary).
  ///
  /// Throws a [PermissionDefinitionsNotFoundException] when the key
  /// `NSLocationTemporaryUsageDescriptionDictionary` has not been set in the
  /// `Infop.list`.
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) async {
    throw UnimplementedError(
        'requestTemporaryFullAccuracy() has not been implemented');
  }

  /// Returns a [Future] containing a [LocationAccuracyStatus].
  ///
  /// When on iOS the user has given permission for approximate location,
  /// [LocationAccuracyStatus.reduced] will be returned, if the user gave
  /// permission for precise/full accuracy location, [LocationAccuracyStatus.precise]
  /// will be returned.
  /// When executing the method on platforms that don't support location
  /// accuracy features [LocationAccuracyStatus.unknown] should be returned.
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    throw UnimplementedError('getLocationAccuracy() has not been implemented.');
  }

  /// Opens the App settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise
  /// [false] is returned.
  Future<bool> openAppSettings() async {
    throw UnimplementedError('openAppSettings() has not been implemented.');
  }

  /// Opens the location settings page.
  ///
  /// Returns [true] if the location settings page could be opened, otherwise
  /// [false] is returned.
  Future<bool> openLocationSettings() async {
    throw UnimplementedError(
        'openLocationSettings() has not been implemented.');
  }

  /// Calculates the distance between the supplied coordinates in meters.
  ///
  /// The distance between the coordinates is calculated using the Haversine
  /// formula (see https://en.wikipedia.org/wiki/Haversine_formula). The
  /// supplied coordinates [startLatitude], [startLongitude], [endLatitude] and
  /// [endLongitude] should be supplied in degrees.
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static _toRadians(double degree) {
    return degree * pi / 180;
  }

  /// Calculates the initial bearing between two points
  ///
  /// The initial bearing will most of the time be different than the end
  /// bearing, see https://www.movable-type.co.uk/scripts/latlong.html#bearing.
  /// The supplied coordinates [startLatitude], [startLongitude], [endLatitude]
  /// and [endLongitude] should be supplied in degrees.
  double bearingBetween(
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

    return degrees(atan2(y, x));
  }
}
