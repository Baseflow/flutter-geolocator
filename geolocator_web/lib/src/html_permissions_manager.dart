import 'dart:html' as html;

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'permissions_manager.dart';
import 'utils.dart';

// ignore_for_file: public_member_api_docs
class HtmlPermissionsManager implements PermissionsManager {
  static const _permissionQuery = {'name': 'geolocation'};
  final html.Permissions? _permissions;

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
