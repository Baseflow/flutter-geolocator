import 'dart:io';

import 'package:geoclue/geoclue.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'geoclue_x.dart';
import 'geolocator_gnome.dart';
import 'geolocator_linux_method_channel.dart';
import 'geolocator_linux_native.dart';

class FactoryToGeolocatorLinuxRegister {
  GeoClueManager makeManager() => GeoClueManager();
  Map<String, String> getPlatformEnvironment() => Platform.environment;
  const FactoryToGeolocatorLinuxRegister();
}

class GeolocatorLinux extends GeolocatorPlatform {
  static Future<void> registerWith(
      [FactoryToGeolocatorLinuxRegister factoryToGeolocatorLinuxRegister =
          const FactoryToGeolocatorLinuxRegister()]) async {
    final GeoClueManager manager =
        factoryToGeolocatorLinuxRegister.makeManager();
    final Map<String, String> environment =
        factoryToGeolocatorLinuxRegister.getPlatformEnvironment();

    final String? currentDesktop = environment['XDG_CURRENT_DESKTOP'];
    if ((currentDesktop != null &&
            currentDesktop.toUpperCase().contains('GNOME')) ||
        (environment.containsKey('GNOME_SHELL_SESSION_MODE') &&
            environment['GNOME_SHELL_SESSION_MODE']!.isNotEmpty)) {
      GeolocatorPlatform.instance = GeolocatorGnome(manager);
    } else {
      GeolocatorPlatform.instance = GeolocatorLinux(manager);
    }
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

  static GeolocatorLinuxNative instanceNative = MethodChannelGeolocatorLinux();
}
