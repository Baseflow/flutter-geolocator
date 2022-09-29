import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_linux/src/geolocator_linux_method_channel.dart';

void main() {
  MethodChannelGeolocatorLinux platform = MethodChannelGeolocatorLinux();
  const MethodChannel channel = MethodChannel('geolocator_linux');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.openGnomeLocationSettings(), true);
  });
}
