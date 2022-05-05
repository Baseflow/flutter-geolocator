import 'package:geoclue/geoclue.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:gsettings/gsettings.dart';

import 'geolocator_linux.dart';

class GeolocatorGnome extends GeolocatorLinux {
  GeolocatorGnome(GeoClueManager manager, {GSettings? settings})
      : _settings = settings ?? GSettings('org.gnome.system.location'),
        super(manager);

  final GSettings _settings;

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return _settings.keysChanged
        .asBroadcastStream()
        .where((keys) => keys.contains('enabled'))
        .asyncMap((_) => isLocationServiceEnabled())
        .map((v) => v ? ServiceStatus.enabled : ServiceStatus.disabled);
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return _settings.get('enabled').then((value) => value.toNative());
  }
}
