/// Represent the current Location Accuracy Status on iOS 14.0 and higher.
enum LocationAccuracyStatus {
  /// A approximate location will be returned (Approximate location).
  reduced,

  /// The precise location of the device will be returned.
  precise,

  /// When an Android device is used, an 'unknown' status is returned, since
  /// Android does not support Approximate Location yet.
  unknown,
}
