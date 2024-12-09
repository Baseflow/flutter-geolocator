/// An exception thrown when the GPS signal is lost.
class LocationSignalLostException implements Exception {
  /// Constructs the [LocationSignalLostException]
  const LocationSignalLostException();

  @override
  String toString() => 'The location service on the device is unable to '
      'retrieve a location. Possibly because the GPS signal is lost.';
}
