import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'geolocator_linux_native.dart';

class MethodChannelGeolocatorLinux extends GeolocatorLinuxNative {
  @visibleForTesting
  final methodChannel = const MethodChannel('geolocator_linux');

  @override
  Future<bool?> openGnomeLocationSettings() async {
    return await methodChannel.invokeMethod<bool>('openGnomeLocationPanel');
  }
}
