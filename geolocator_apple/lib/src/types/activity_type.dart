/// Represents the possible iOS activity types.
enum ActivityType {
  /// The location manager is being used specifically during vehicular
  /// navigation to track location changes to the automobile.
  automotiveNavigation,

  /// The location manager is being used to track fitness activities such as
  /// walking, running, cycling, and so on.
  fitness,

  /// The location manager is being used to track movements for other types of
  /// vehicular navigation that are not automobile related.
  otherNavigation,

  /// The location manager is being used specifically during
  /// airborne activities.
  airborne,

  /// The location manager is being used for an unknown activity.
  other,

  /// Positioning for vessels on water, including while anchored.
  ///
  /// Requires an iOS 27 or macOS 27 SDK and iOS 27 or macOS 27 at runtime.
  /// Falls back to [otherNavigation] on older SDKs or operating systems.
  maritime,
}
