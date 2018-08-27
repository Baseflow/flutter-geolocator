part of geolocator;

enum GooglePlayServicesAvailability {
  /// Google Play services are installed on the device and ready to be used.
  success,

  /// Google Play services is missing on this device.
  serviceMissing,

  /// Google Play service is currently being updated on this device.
  serviceUpdating,

  /// The installed version of Google Play services is out of date.
  serviceVersionUpdateRequired,

  /// The installed version of Google Play services has been disabled on this device.
  serviceDisabled,

  /// The version of the Google Play services installed on this device is not authentic.
  serviceInvalid,

  /// Google Play services are not available on this platform.
  notAvailableOnPlatform,

  /// Unable to determine if Google Play services are installed.
  unknown,
}
