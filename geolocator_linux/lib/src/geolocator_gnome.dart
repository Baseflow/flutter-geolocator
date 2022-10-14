import 'package:geoclue/geoclue.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:gsettings/gsettings.dart';
import 'package:dbus/dbus.dart';

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
  Future<bool> isLocationServiceEnabled() async {
    return _settings.get('enabled').then((value) => value.toNative());
  }

  @override
  Future<bool> openLocationSettings(
      {String dbusRemoteName = 'Settings',
      DBusRemoteObject? dBusRemoteSettingsInject}) async {
    final DBusClient session;
    try {
      session = DBusClient.session();
    } on Exception {
      return false;
    }

    try {
      final DBusRemoteObject dBusRemoteSettings = dBusRemoteSettingsInject ??
          DBusRemoteObject(
            session,
            name: 'org.gnome.$dbusRemoteName',
            path: DBusObjectPath('/org/gnome/$dbusRemoteName'),
          );

      await dBusRemoteSettings.callMethod(
        'org.gtk.Actions',
        'Activate',
        [
          const DBusString('launch-panel'),
          DBusArray.variant([
            DBusStruct([const DBusString('location'), DBusArray.variant([])]),
          ]),
          DBusDict.stringVariant({}),
        ],
        replySignature: DBusSignature.empty,
      );
      return true;
    } on DBusServiceUnknownException {
      if (dbusRemoteName == 'ControlCenter') return false;
      return await openLocationSettings(
          dbusRemoteName: 'ControlCenter',
          dBusRemoteSettingsInject: dBusRemoteSettingsInject);
    } on Exception {
      return false;
    } finally {
      await session.close();
    }
  }
}
