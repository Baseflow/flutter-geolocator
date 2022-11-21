/// An exception thrown when something went wrong while listening for position
/// updates.
class NmeaUpdateException implements Exception {
  /// Constructs the [NmeaUpdateException]
  const NmeaUpdateException(this.message);

  /// A [message] describing more details on the update exception
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'Something went wrong while listening for nmea updates.';
    }

    return message!;
  }
}
