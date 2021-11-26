import 'dart:html' as html;

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'permissions_manager.dart';
import 'utils.dart';

class HtmlPermissionsManager implements PermissionsManager {
  static const _permissionQuery = {'name': 'geolocation'};
  final html.Permissions? _permissions;

  HtmlPermissionsManager() : _permissions = html.window.navigator.permissions;

  @override
  bool get permissionsSupported => _permissions != null;

  @override
  Future<LocationPermission> query(Map permission) async {
    final permissions = _permissions;
    if (permissions == null) {
      return LocationPermission.denied;
    }

    final status = await permissions.query(
      _permissionQuery,
    );

    return status.state != null
        ? toLocationPermission(status.state)
        : LocationPermission.denied;
  }
}
