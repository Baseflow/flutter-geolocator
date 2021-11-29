import 'dart:html' as html;

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'permissions_manager.dart';
import 'utils.dart';

/// Implementation of the [GeolocationManager] interface based on the
/// [html.Permissions] class.
class HtmlPermissionsManager implements PermissionsManager {
  static const _permissionQuery = {'name': 'geolocation'};
  final html.Permissions? _permissions;

  /// Creates a new instance of the HtmlPermissionsManager class.
  HtmlPermissionsManager() : _permissions = html.window.navigator.permissions;

  @override
  bool get permissionsSupported => _permissions != null;

  @override
  Future<LocationPermission> query(Map permission) async {
    final html.PermissionStatus result = await _permissions!.query(
      _permissionQuery,
    );

    return toLocationPermission(result.state);
  }
}
