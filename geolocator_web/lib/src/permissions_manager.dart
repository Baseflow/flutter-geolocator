import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

// ignore_for_file: public_member_api_docs
abstract class PermissionsManager {
  bool get permissionsSupported;

  Future<LocationPermission> query(Map permission);
}
