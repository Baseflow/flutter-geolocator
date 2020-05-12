import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
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
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns a [Future] containing the current [PermissionStatus] indicating
  /// if access to the device's location is allowed.
  Future<PermissionStatus> checkPermissions(
      {Permission locationPermission = Permission.location}) {
    throw UnimplementedError(
      'checkPermissions() has not been implementated.',
    );
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
  /// On Android we look for the location provider matching best with the
  /// supplied [desiredAccuracy]. On iOS this parameter is ignored.
  /// When no position is available, null is returned.
  Future<Position> getLastKnownPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Permission permission = Permission.location,
  }) {
    throw UnimplementedError(
      'getLastKnownPosition() has not been implemented.',
    );
  }

  /// Returns the current position taking the supplied [desiredAccuracy] into
  /// account.
  ///
  /// When the [desiredAccuracy] is not supplied, it defaults to best.
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Permission permission = Permission.location,
    Duration timeLimit,
  }) {
    throw UnimplementedError('getCurrentPosition() has not been implemented.');
  }

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
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    int timeInterval = 0,
    Permission permission = Permission.location,
    Duration timeLimit,
  }) {
    throw UnimplementedError('getPositionStream() has not been implemented.');
  }
}
