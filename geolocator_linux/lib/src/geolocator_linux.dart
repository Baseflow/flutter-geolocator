import 'dart:io';

import 'package:geoclue/geoclue.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'geoclue_x.dart';
import 'geolocator_gnome.dart';

class GeolocatorLinux extends GeolocatorPlatform {
  static Future<void> registerWith() async {
    final String? currentDesktop = Platform.environment['XDG_CURRENT_DESKTOP'];
    final GeoClueManager manager = GeoClueManager();

    if (currentDesktop == null) {
      GeolocatorPlatform.instance = GeolocatorLinux(manager);
      return;
    }

    if (currentDesktop.toUpperCase().contains('GNOME')) {
      GeolocatorPlatform.instance = GeolocatorGnome(manager);
      return;
    }

    GeolocatorPlatform.instance = GeolocatorLinux(manager);
  }

  GeolocatorLinux(this._manager);

  final GeoClueManager _manager;
  PackageInfo? _packageInfo;

  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.unableToDetermine;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    //TODO: Check if GeoClue D-Bus service is running.
    return Future.value(true);
  }

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async {
    var client = await _manager.getClient();
    return client.location?.toPosition();
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return GeoClue.getLocation(
      manager: _manager,
      desktopId: _packageInfo!.appName,
      accuracyLevel: locationSettings?.accuracy.toGeoClueAccuracyLevel(),
      distanceThreshold: locationSettings?.distanceFilter,
      timeThreshold: locationSettings?.timeLimit?.inSeconds,
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
      accuracyLevel: locationSettings?.accuracy.toGeoClueAccuracyLevel(),
      distanceThreshold: locationSettings?.distanceFilter,
      timeThreshold: locationSettings?.timeLimit?.inSeconds,
    ).map((location) => location.toPosition());
  }
}
