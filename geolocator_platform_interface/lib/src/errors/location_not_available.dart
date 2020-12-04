/// An exception thrown when if geolocator could not get a location fix
/// for a number of reasons
class LocationNotAvailableException implements Exception {
  /// Constructs the [LocationNotAvailableException]
  const LocationNotAvailableException();

  @override
  String toString() =>
      'Geolocator could not get a location fix. Maybe the location settings '
      'are not correct in relation to the desired accuracy?';
}
