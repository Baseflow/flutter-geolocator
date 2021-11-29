import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// The interface that implementions need to implement when they want to query
/// geolocation permissions for the web platform.
abstract class PermissionsManager {
  /// Returns `true` when permissions requests are supported; otherwise `false`
  /// is returned.
  ///
  /// When permissions are not supported (this means the client browser doesn't
  /// support the [Permission API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API))
  /// the [query] method will always return `LocationPermission.denied`.
  bool get permissionsSupported;

  /// Queries the current permission for accessing the location information on
  /// the current device.
  ///
  /// When permissions are not supported (this means the client browser doesn't
  /// support the [Permission API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API))
  /// the [query] method will always return `LocationPermission.denied`.
  Future<LocationPermission> query(Map permission);
}
