/// An exception thrown when subscribing to receive positions while another
/// subscription is already active.
class AlreadySubscribedException implements Exception {
  /// Constructs the [AlreadySubscribedException]
  const AlreadySubscribedException();

  @override
  String toString() =>
      'The App is already listening to a stream of position updates. It is not '
      'possible to listen to more then one stream at the same time.';
}
