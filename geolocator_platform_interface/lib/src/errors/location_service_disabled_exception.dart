/// An exception thrown when trying to access the  device's location
/// information while the location service on the device is disabled.
class LocationServiceDisabledException implements Exception {
  /// Constructs the [LocationServiceDisabledException]
  const LocationServiceDisabledException();

  @override
  String toString() => 'The location service on the device is disabled.';
}
