import '../enums/enums.dart'; 
import '../extensions/extensions.dart';

/// Represents different options to configure the quality and frequency
/// of location updates.
class LocationOptions {
  /// Initializes a new [LocationOptions] instance with default values.
  ///
  /// The following default values are used:
  /// - accuracy: best
  /// - distanceFilter: 0
  /// - timeInterval: 0
  const LocationOptions(
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

  /// Serializes the [LocationOptions] to a map message.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'accuracy': accuracy.toShortString(),
        'distanceFilter': distanceFilter,
        'timeInterval': timeInterval
      };
}
