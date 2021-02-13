/// An exception thrown when requesting location permissions while an earlier
/// request has not yet been completed.
class PermissionRequestInProgressException implements Exception {
  /// Constructs the [PermissionRequestInProgressException]
  const PermissionRequestInProgressException(this.message);

  /// A [message] describing more details on the denied permission.
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'A request for location permissions is already running, please '
          'wait for it to complete before doing another request.';
    }
    return message!;
  }
}
