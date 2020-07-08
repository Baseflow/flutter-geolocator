import 'dart:async';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Returns a [Future] indicating if the user allows the App to access
/// the device's location.
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
Future<LocationPermission> requestPermission() =>
    GeolocatorPlatform.instance.requestPermission();

/// Returns a [Future] containing a [bool] value indicating whether location
/// services are enabled on the device.
Future<bool> isLocationServiceEnabled() =>
    GeolocatorPlatform.instance.isLocationServiceEnabled();

/// Returns the last known position stored on the users device.
///
/// On Android we look for the location provider matching best with the
/// supplied [desiredAccuracy]. On iOS this parameter is ignored.
/// When no position is available, null is returned.
/// Throws a [PermissionDeniedException] when trying to request the device's
/// location when the user denied access.
Future<Position> getLastKnownLocation({LocationAccuracy desiredAccuracy}) =>
    GeolocatorPlatform
      .instance
      .getLastKnownPosition(desiredAccuracy: desiredAccuracy);
      
/// Returns the current position taking the supplied [desiredAccuracy] into
/// account.
///
/// When the [desiredAccuracy] is not supplied, it defaults to best. 
/// Throws a [TimeoutException] when no location is received within the 
/// supplied [timeLimit] duration.
/// Throws a [PermissionDeniedException] when trying to request the device's
/// location when the user denied access.
Future<Position> getCurrentPosition({
  LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  Duration timeLimit,
}) =>
    GeolocatorPlatform.instance.getCurrentPosition(
      desiredAccuracy: desiredAccuracy, 
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
/// StreamSubscription<Position> positionStream = Geolocator()
///     .GetPostionStream()
///     .listen((Position position) => {
///       // Handle position changes
///     });
///
/// // When no longer needed cancel the subscription
/// positionStream.cancel();
/// ```
///
/// You can customize the behaviour of the location updates by supplying an
/// instance [LocationOptions] class. When you don't supply any specific
/// options, default values will be used for each setting.
/// 
/// Throws a [TimeoutException] when no location is received within the 
/// supplied [timeLimit] duration.
/// Throws a [PermissionDeniedException] when trying to request the device's
/// location when the user denied access.
Stream<Position> getPositionStream({
  LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  int distanceFilter = 0,
  int timeInterval = 0,
  Duration timeLimit,
}) =>
    GeolocatorPlatform.instance.getPositionStream(
      desiredAccuracy: desiredAccuracy,
      distanceFilter: distanceFilter,
      timeInterval: timeInterval,
      timeLimit: timeLimit,
    );