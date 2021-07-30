import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'activity_type.dart';

/// Represents different iOS specific settings with which you can set a value
/// other then the default value of the setting.
class IosSpecificSettings extends PlatformSpecificSettings {
  /// Initializes a new [IosSpecificSettings] instance with default values.
  ///
  /// The following default values are used:
  /// - pauseLocationUpdatesAutomatically: false
  /// - activityType: ActivityType.other
  IosSpecificSettings({
    this.pauseLocationUpdatesAutomatically = false,
    this.activityType = ActivityType.other,
    LocationAccuracy accuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    int timeInterval = 0,
  }) : super(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
            timeInterval: timeInterval);

  /// Allows the location manager to pause updates to improve battery life
  /// on the target device without sacrificing location data.
  /// When this property is set to `true`, the location manager pauses updates
  /// (and powers down the appropriate hardware) at times when the
  /// location data is unlikely to change.
  final bool pauseLocationUpdatesAutomatically;

  /// The location manager uses the information in this property as a cue
  /// to determine when location updates may be automatically paused.
  final ActivityType activityType;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'pauseLocationUpdatesAutomatically': pauseLocationUpdatesAutomatically,
        'this.activityType': activityType.index,
      });
  }
}
