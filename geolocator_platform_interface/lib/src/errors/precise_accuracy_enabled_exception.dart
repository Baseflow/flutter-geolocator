/// An exception thrown when the user already enabled Precise Location fetching.
///
/// This exception is thrown only when using iOS 14 or above.
class PreciseAccuracyEnabledException implements Exception {
  /// Constructs the [PreciseAccuracyEnabledException]
  const PreciseAccuracyEnabledException(this.message);

  /// A [message] describing more details about the exception.
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'The user already enabled Precise location fetching, when using '
          'the \'requestTemporaryFullAccuracy\', make sure to check whether the'
          'user has already given permission to use Precise Accuracy.';
    }

    return message!;
  }
}
