/// Represents whether the app can access the precise location of the device,
/// or only an approximate location.
///
/// This is the value returned by `getLocationAccuracy()`. What it is based on
/// differs per platform:
///
/// * Android: [precise] when the `ACCESS_FINE_LOCATION` permission is
///   granted, and [reduced] when only `ACCESS_COARSE_LOCATION` is granted,
///   for example because the user chose approximate location on Android 12
///   or higher.
/// * iOS 14 and higher: [precise] or [reduced], depending on whether the user
///   allowed precise location.
/// * iOS 13 and lower, and macOS: always [precise].
/// * Windows: [precise] when position updates were last requested with
///   `LocationAccuracy.medium` or better, otherwise [reduced].
/// * Linux: based on the accuracy level that GeoClue makes available.
enum LocationAccuracyStatus {
  /// Only an approximate location of the device is available.
  reduced,

  /// The precise location of the device is available.
  precise,

  /// The accuracy level is not known, for example on Linux when GeoClue
  /// reports no accuracy level at all.
  unknown,
}
