import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

abstract class PermissionsManager {
  bool get permissionsSupported;

  Future<LocationPermission> query(Map permission);
}
