/// An exception thrown when executing functionality which requires an Android
/// while no activity is provided.
///
/// This exception is thrown on Android only and might occur hen running a
/// certain function from the background that requires a UI element (e.g.
/// requesting permissions or enabling the location services).
class ActivityMissingException implements Exception {
  /// Constructs the [ActivityMissingException]
  const ActivityMissingException(this.message);

  /// A [message] describing more details on the missing activity.
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'Activity is missing. This might happen when running a certain '
          'function from the background that requires a UI element (e.g. '
          'requesting permissions or enabling the location services).';
    }
    return message!;
  }
}
