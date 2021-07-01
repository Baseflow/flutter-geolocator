/// An exception thrown when users using iOS 13 or below try to execute the
/// 'requestTemporaryFullAccuracy' method.
///
/// Since Approximate location only supports iOS 14 or above, the exception is
/// only thrown when using iOS 13 or below.
class ApproximateLocationNotSupportedException implements Exception {
  /// Constructs the [ApproximateLocationNotSupportedException]
  const ApproximateLocationNotSupportedException(this.message);

  /// A [message] describing more details about the exception
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'The requestTemporaryFullAccuracy method only supports iOS 14'
          ' or above.';
    }
    return message!;
  }
}
