import '../enums/location_accuracy.dart';

/// Represents the abstract [PlatformSpecificSettings] class with which you can
/// configure platform specific settings.
class PlatformSpecificSettings {
  /// Initializes a new [PlatformSpecificSettings] instance with default values.
  ///
  /// The following default values are used:
  /// - accuracy: best
  /// - distanceFilter: 0
  /// - forceAndroidLocationManager: false
  /// - timeInterval: 0
  const PlatformSpecificSettings(
      {this.accuracy = LocationAccuracy.best,
      this.distanceFilter = 0,
      this.timeInterval = 0});

  /// Defines the desired accuracy that should be used to determine the
  /// location data.
  ///
  /// The default value for this field is [LocationAccuracy.best].
  final LocationAccuracy accuracy;

  /// The minimum distance (measured in meters) a device must move
  /// horizontally before an update event is generated.
  ///
  /// Supply 0 when you want to be notified of all movements. The default is 0.
  final int distanceFilter;

  /// The desired interval for active location updates, in milliseconds
  /// (Android only).
  ///
  /// On iOS this value is ignored since position updates based on time
  /// intervals are not supported.
  final int timeInterval;

  /// Serializes the [PlatformSpecificSettings] to a map message
  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy.index,
      'distanceFilter': distanceFilter,
      'timeInterval': timeInterval,
    };
  }
}
