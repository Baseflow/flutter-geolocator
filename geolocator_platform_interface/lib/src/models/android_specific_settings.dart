import 'package:geolocator_platform_interface/src/models/platform_specific_settings.dart';

/// Represents different Android specific settings with which you can set a value
/// other then the default value of the setting.
class AndroidSpecificSettings extends PlatformSpecificSettings {
  /// Initializes a new [AndroidSpecificSettings] instance with default values.
  ///
  /// The following default values are used:
  /// - forceLocationManager: false
  AndroidSpecificSettings({
    this.forceLocationManager = false,
  });

  /// Forces the location manager to use the Android Location Manager instead of
  /// the FusedLocationClient.
  final bool forceLocationManager;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'forceLocationManager': forceLocationManager,
      });
  }
}
