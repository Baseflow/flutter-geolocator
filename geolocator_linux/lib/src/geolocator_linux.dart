import 'package:geoclue/geoclue.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'geoclue_x.dart';
import 'geolocator_gnome.dart';

class GeolocatorLinux extends GeolocatorPlatform {
  static Future<void> registerWith() async {
    // TODO: Platform.environment['XDG_CURRENT_DESKTOP'];
    GeolocatorPlatform.instance = GeolocatorGnome(GeoClueManager());
  }

  GeolocatorLinux(this._manager);

  final GeoClueManager _manager;
  PackageInfo? _packageInfo;

  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.unableToDetermine;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return GeoClue.getLocation(
      manager: _manager,
      desktopId: _packageInfo!.appName,
    ).then((location) => location.toPosition());
  }

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() {
    return _manager.connect().then((_) {
      return _manager.availableAccuracyLevel.toStatus();
    });
  }

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) async* {
    _packageInfo ??= await PackageInfo.fromPlatform();
    yield* GeoClue.getLocationUpdates(
      manager: _manager,
      desktopId: _packageInfo!.appName,
    ).map((location) => location.toPosition());
  }
}
