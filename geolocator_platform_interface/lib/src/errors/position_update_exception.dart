/// An exception thrown when something went wrong while listening for position
/// updates.
class PositionUpdateException implements Exception {
  /// Constructs the [PositionUpdateException]
  const PositionUpdateException(this.message);

  /// A [message] describing more details on the update exception
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'Something went wrong while listening for position updates.';
    }

    return message!;
  }
}
