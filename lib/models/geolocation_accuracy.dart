/// Defines the accuracy used to determine the location data.
/// 
/// The accuracy is measured in meters (distance) and differs per platform.
enum GeolocationAccuracy {
  /// Location is accurate within a distance of 3000m on iOS and 500m on Android
  Lowest,
  /// Location is accurate within a distance of 1000m on iOS and 500m on Android
  Low,
  /// Location is accurate within a distance of 100m on iOS and between 100m and 500m on Android
  Medium,
  /// Location is accurate within a distance of 10m on iOS and between 0m and 100m on Android
  High,
  /// Location is accurate within a distance of ~0m on iOS and between 0m and 100m on Android
  Best
}