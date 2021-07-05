/// Represent the possible location accuracy values.
enum LocationAccuracy {
  /// Location is accurate within a distance of 3000m on iOS and 500m on Android
  lowest,

  /// Location is accurate within a distance of 1000m on iOS and 500m on Android
  low,

  /// Location is accurate within a distance of 100m on iOS and between 100m and
  /// 500m on Android
  medium,

  /// Location is accurate within a distance of 10m on iOS and between 0m and
  /// 100m on Android
  high,

  /// Location is accurate within a distance of ~0m on iOS and between 0m and
  /// 100m on Android
  best,

  /// Location accuracy is optimized for navigation on iOS and matches the
  /// [LocationAccuracy.best] on Android
  bestForNavigation,

  /// Location accuracy is reduced for iOS 14+ devices, matches the
  /// [LocationAccuracy.lowest] on iOS 13 and below and all other platforms.
  reduced,
}
