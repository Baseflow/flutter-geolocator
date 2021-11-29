import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// The interface that implementations need to implement to provide geolocation
/// features for the web platform.
abstract class GeolocationManager {
  /// Returns the current position.
  ///
  /// Setting [enableHighAccuracy] to `true` will return the most accurate
  /// possible position fix. This can result in slower response times and higher
  /// battery consumption.
  ///
  /// Throws a [TimeoutException] when no position is received within the
  /// supplied [timeout] duration.
  Future<Position> getCurrentPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  });

  /// Returns a position stream providing continuous position updates.
  ///
  /// Setting [enableHighAccuracy] to `true` will return the most accurate
  /// possible location fix. This can result in slower response times and higher
  /// battery consumption.
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeout] duration.
  Stream<Position> watchPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  });
}
