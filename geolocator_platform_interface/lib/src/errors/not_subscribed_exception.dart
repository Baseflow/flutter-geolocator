/// An exception thrown when trying to update location stream settings without
/// having an active subscription to the location stream.
class NotSubscribedException implements Exception {
  /// Constructs the [NotSubscribedException]
  const NotSubscribedException();

  @override
  String toString() =>
      'The App is not listening to a stream of position updates and thus it is'
      'not possible to update location stream settings. Call '
      'getPositionStream() first.';
}
