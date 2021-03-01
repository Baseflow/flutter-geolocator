import 'dart:html';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

abstract class PermissionsManager {
  Future<LocationPermission> query(
    Map permission
  );
}

