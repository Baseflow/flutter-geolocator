import 'dart:html' as html;

import 'package:geolocator_platform_interface/src/enums/location_permission.dart';

import 'permissions_manager.dart';
import 'utils.dart';

class HtmlPermissionsManager implements PermissionsManager {
  static const _permissionQuery = {'name': 'geolocation'};
  final html.Permissions _permissions;

  HtmlPermissionsManager(this._permissions) : assert(_permissions != null);

  @override
  Future<LocationPermission> query(Map permission) async {
    final html.PermissionStatus result = await _permissions.query(
      _permissionQuery,
    );
    return toLocationPermission(result.state);
  }
}