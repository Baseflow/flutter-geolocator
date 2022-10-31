import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'activity_type.dart';

/// Represents different iOS specific settings with which you can set a value
/// other then the default value of the setting.
class AppleSettings extends LocationSettings {
  /// Initializes a new [AppleSettings] instance with default values.
  ///
  /// The following default values are used:
  /// - pauseLocationUpdatesAutomatically: false
  /// - activityType: ActivityType.other
  AppleSettings({
    this.pauseLocationUpdatesAutomatically = false,
    this.activityType = ActivityType.other,
    LocationAccuracy accuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    Duration? timeLimit,
    this.showBackgroundLocationIndicator = false,
    this.allowBackgroundLocationUpdates = true,
  }) : super(
          accuracy: accuracy,
          distanceFilter: distanceFilter,
          timeLimit: timeLimit,
        );

  /// Allows the location manager to pause updates to improve battery life
  /// on the target device without sacrificing location data.
  /// When this property is set to `true`, the location manager pauses updates
  /// (and powers down the appropriate hardware) at times when the
  /// location data is unlikely to change.
  final bool pauseLocationUpdatesAutomatically;

  /// The location manager uses the information in this property as a cue
  /// to determine when location updates may be automatically paused.
  final ActivityType activityType;

  /// Flag to ask the Apple OS to show the background location indicator (iOS only)
  /// if app starts up and background and requests the users location.
  ///
  /// For this setting to work and for the location to be retrieved the user must
  /// have granted "always" permissions for location retrieval.
  final bool showBackgroundLocationIndicator;

  /// Flag to allow the app to receive location updates in the background (iOS only)
  ///
  /// For this setting to work Info.plist should contain the following keys:
  /// - UIBackgroundModes and the value should contain "location"
  /// - NSLocationAlwaysUsageDescription
  final bool allowBackgroundLocationUpdates;

  /// Returns a JSON representation of this class.
  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'pauseLocationUpdatesAutomatically': pauseLocationUpdatesAutomatically,
        'this.activityType': activityType.index,
        'showBackgroundLocationIndicator': showBackgroundLocationIndicator,
        'allowBackgroundLocationUpdates': allowBackgroundLocationUpdates,
      });
  }
}
