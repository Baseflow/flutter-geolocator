import '../enums/location_accuracy.dart';

/// Represents the abstract [LocationSettings] class with which you can
/// configure platform specific settings.
class LocationSettings {
  /// Initializes a new [LocationSettings] instance with default values.
  ///
  /// The following default values are used:
  /// - accuracy: best
  /// - distanceFilter: 0
  /// - timeLimit: 0
  const LocationSettings({
    this.accuracy = LocationAccuracy.best,
    this.distanceFilter = 0,
    this.timeLimit,
  });

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

  /// The [timeLimit] parameter allows you to specify a timeout interval (by
  /// default no time limit is configured).
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  final Duration? timeLimit;

  /// Serializes the [PlatformSpecificSettings] to a map message
  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy.index,
      'distanceFilter': distanceFilter,
    };
  }
}
