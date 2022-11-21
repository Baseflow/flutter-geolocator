/// An exception thrown when subscribing to receive positions while another
/// subscription is already active.
class NmeaAlreadySubscribedException implements Exception {
  /// Constructs the [NmeaAlreadySubscribedException]
  const NmeaAlreadySubscribedException();

  @override
  String toString() =>
      'The App is already listening to a stream of nmea updates. It is not '
      'possible to listen to more then one stream at the same time.';
}
