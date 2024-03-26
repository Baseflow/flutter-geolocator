/// An exception thrown when the required platform specific permission
/// definitions could not be found (e.g. in the AndroidManifest.xml file on
/// Android or in the Info.plist file on iOS).
class PermissionDefinitionsNotFoundException implements Exception {
  /// Constructs the [PermissionDefinitionsNotFoundException]
  const PermissionDefinitionsNotFoundException(this.message);

  /// A [message] describing more details on the denied permission.
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'Permission definitions are not found. Please make sure you have '
          'added the necessary definitions to the configuration file (e.g. '
          'the AndroidManifest.xml on Android or the Info.plist on iOS).';
    }
    return message!;
  }
}
