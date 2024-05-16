import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'permissions_manager.dart';
import 'utils.dart';

/// Implementation of the [GeolocationManager] interface based on the
/// [html.Permissions] class.
class HtmlPermissionsManager implements PermissionsManager {
  static const _permissionQuery = {'name': 'geolocation'};
  final web.Permissions? _permissions;

  /// Creates a new instance of the HtmlPermissionsManager class.
  HtmlPermissionsManager() : _permissions = web.window.navigator.permissions;

  @override
  bool get permissionsSupported => _permissions != null;

  @override
  Future<LocationPermission> query(Map permission) async {
    if (!permissionsSupported) {
      return LocationPermission.unableToDetermine;
    }

    // navigator.permissions.query({ name: "geolocation" })
    final web.PermissionStatus? status =
        await _permissions?.query(_permissionQuery.jsify() as JSObject).toDart;

    return status != null
        ? toLocationPermission(status.state)
        : LocationPermission.denied;
  }
}
