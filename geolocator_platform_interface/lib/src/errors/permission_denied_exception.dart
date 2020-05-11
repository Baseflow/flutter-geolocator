import '../enums/permission.dart';

/// An exception thrown when trying to access the  device's location 
/// information while access is denied.
class PermissionDeniedException implements Exception {
  /// Constructs the [PermissionDeniedException]
  const PermissionDeniedException(this.permission);

  /// The [Permission] that has been requested but has been denied.
  final Permission permission;

  @override
  String toString() {
    return 'Access to $permission has been requested but denied by the user.';
  }
}
