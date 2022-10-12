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
      {DBusRemoteObject? controlCenterInject}) async {
    try {
      final session = DBusClient.session();

      final controlCenter = controlCenterInject ??
          DBusRemoteObject(
            session,
            name: 'org.gnome.ControlCenter',
            path: DBusObjectPath('/org/gnome/ControlCenter'),
          );

      await controlCenter.callMethod(
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

      await session.close();
      return true;
    } on Exception {
      return false;
    }
  }
}
