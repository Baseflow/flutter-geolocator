import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:mockito/mockito.dart';
import 'src/factories/position_factory.dart';

class MockPermissionHandler extends Mock implements LocationPermissions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  Geolocator geolocator;
  MockPermissionHandler mockPermissionHandler;

  setUp(() async {
    log.clear();
    mockPermissionHandler = MockPermissionHandler();
    geolocator = Geolocator.private(mockPermissionHandler);
  });

  group('Tests for geolocation (or position) related methods', () {
    var initMockMethodChannel = (String method, dynamic result) {
      // Mock the Geolocator method channel, simulating the Android/ iOS side
      // of the plugin library.
      Geolocator.methodChannel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);

        if (methodCall.method == method) {
          return result;
        } else {
          return null;
        }
      });
    };

    test('Retrieve the current position with permissions', () async {
      initMockMethodChannel(
          'getCurrentPosition', PositionFactory.createMockPosition());

      final expectedArguments =
          LocationOptions(forceAndroidLocationManager: true);
      final expectedPosition = PositionFactory.createMockPosition();

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      final Position position = await geolocator.getCurrentPosition(
          locationPermissionLevel: GeolocationPermission.location);

      expect(position.latitude, expectedPosition['latitude']);
      expect(position.longitude, expectedPosition['longitude']);
      expect(position.altitude, expectedPosition['altitude']);
      expect(position.accuracy, expectedPosition['accuracy']);
      expect(position.heading, expectedPosition['heading']);
      expect(position.speed, expectedPosition['speed']);
      expect(position.speedAccuracy, expectedPosition['speed_accuracy']);
      expect(log, <Matcher>[
        isMethodCall(
          'getCurrentPosition',
          arguments: Codec.encodeLocationOptions(expectedArguments),
        ),
      ]);
    });

    test('Retrieve the current position without permissions', () async {
      initMockMethodChannel(
          'getCurrentPosition', PositionFactory.createMockPosition());

      const expectedErrorCode = 'PERMISSION_DENIED';
      const expectedErrorMessage = 'Access to location data denied';

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.denied);

      try {
        await geolocator.getCurrentPosition(
            locationPermissionLevel: GeolocationPermission.location);
      } on PlatformException catch (e) {
        expect(e.code, expectedErrorCode);
        expect(e.message, expectedErrorMessage);
      }
    });

    test('Retrieve invalid position', () async {
      initMockMethodChannel('getCurrentPosition', null);

      final expectedArguments =
          LocationOptions(forceAndroidLocationManager: true);

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      var position = await geolocator.getCurrentPosition(
          locationPermissionLevel: GeolocationPermission.location);

      expect(position, null);
      expect(log, <Matcher>[
        isMethodCall(
          'getCurrentPosition',
          arguments: Codec.encodeLocationOptions(expectedArguments),
        ),
      ]);
    });
  });
}
