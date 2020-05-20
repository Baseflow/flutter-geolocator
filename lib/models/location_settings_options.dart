part of geolocator;

/// Represents different options to configure the location settings request.
/// Check SettingsClient for more info.
class LocationSettingsOptions {
  const LocationSettingsOptions({
    this.priority = LocationPriority.balanced,
    this.timeInterval = 5000,
    this.fastestTimeInterval = 1000,
  });

  final LocationPriority priority;

  final int timeInterval;

  final int fastestTimeInterval;
}
