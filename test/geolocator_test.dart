import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:mockito/mockito.dart';
import 'src/factories/placemark_factory.dart';
import 'src/factories/position_factory.dart';

class MockPermissionHandler extends Mock implements LocationPermissions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel _methodChannel =
      MethodChannel('flutter.baseflow.com/geolocator/methods');

  final List<MethodCall> log = <MethodCall>[];

  Geolocator geolocator;
  MockPermissionHandler mockPermissionHandler;

  setUp(() async {
    log.clear();
    mockPermissionHandler = MockPermissionHandler();
    geolocator = Geolocator.private(mockPermissionHandler);
  });

  tearDown(() {
    _methodChannel.setMockMethodCallHandler(null);
  });

  var initMockMethodChannel = (String method, dynamic result) {
    // Mock the Geolocator method channel, simulating the Android/ iOS side
    // of the plugin library.
    _methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);

      if (methodCall.method == method) {
        return result;
      } else {
        return null;
      }
    });
  };

  group('When checking for permission status', () {
    test(
        'I should receive a GeolocationStatus value indicating the current permission state',
        () async {
      final GeolocationStatus expectedPermissionStatus =
          GeolocationStatus.unknown;

      when(mockPermissionHandler.checkPermissionStatus(
        level: LocationPermissionLevel.location,
      )).thenAnswer((_) async => PermissionStatus.unknown);

      final actualPermissionStatus =
          await geolocator.checkGeolocationPermissionStatus(
              locationPermission: GeolocationPermission.location);

      expect(actualPermissionStatus, expectedPermissionStatus);
    });
  });

  group('When checking if location services are enabled', () {
    test('I should recieve true if location services are enabled', () async {
      final bool expected = true;

      when(mockPermissionHandler.checkServiceStatus(
        level: LocationPermissionLevel.location,
      )).thenAnswer((_) async => ServiceStatus.enabled);

      final bool isEnabled = await geolocator.isLocationServiceEnabled();

      expect(isEnabled, expected);
    });

    test('I should recieve false if location services are disabled', () async {
      final bool expected = false;

      when(mockPermissionHandler.checkServiceStatus(
        level: LocationPermissionLevel.location,
      )).thenAnswer((_) async => ServiceStatus.disabled);

      final bool isEnabled = await geolocator.isLocationServiceEnabled();

      expect(isEnabled, expected);
    });
  });

  group('When requesting a stream of position updates', () {
    const String eventChannelName = 'flutter.baseflow.com/geolocator/events';
    const MethodChannel eventChannel = MethodChannel(eventChannelName);

    Position mockPosition;

    setUp(() {
      mockPosition = PositionFactory.createMockPosition();

      eventChannel.setMockMethodCallHandler((MethodCall methodCall) async {
        await defaultBinaryMessenger.handlePlatformMessage(
            eventChannelName,
            const StandardMethodCodec()
                .encodeSuccessEnvelope(mockPosition.toJson()),
            (ByteData data) {});
      });
    });

    test(
        'I should receive a stream with position updates if permissions are granted',
        () async {
      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      final Position position = await geolocator.getPositionStream().first;

      expect(position, mockPosition);
    });

    test('I should receive an exception if permissions are denied', () async {
      const expectedErrorCode = 'PERMISSION_DENIED';
      const expectedErrorMessage = 'Access to location data denied';

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.denied);

      try {
        await geolocator.getPositionStream();
      } on PlatformException catch (e) {
        expect(e.code, expectedErrorCode);
        expect(e.message, expectedErrorMessage);
      }
    });
  });

  group('When requesting the current position', () {
    test('I should receive a position if permissions are granted', () async {
      final expectedPosition = PositionFactory.createMockPosition();
      final expectedArguments =
          LocationOptions(forceAndroidLocationManager: true);

      initMockMethodChannel('getCurrentPosition', expectedPosition.toJson());

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      final Position position = await geolocator.getCurrentPosition(
          locationPermissionLevel: GeolocationPermission.location);

      expect(position, expectedPosition);
      expect(log, <Matcher>[
        isMethodCall(
          'getCurrentPosition',
          arguments: Codec.encodeLocationOptions(expectedArguments),
        ),
      ]);
    });

    test('I should receive an exception if permissions are denied', () async {
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

    test('I should receive null if I am supplying invalid parameters',
        () async {
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

  group('When requesting the last know position', () {
    test('I should receive a position if permissions are granted', () async {
      final expectedPosition = PositionFactory.createMockPosition();
      final expectedArguments =
          LocationOptions(forceAndroidLocationManager: true);

      initMockMethodChannel('getLastKnownPosition', expectedPosition.toJson());

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      final Position position = await geolocator.getLastKnownPosition(
          locationPermissionLevel: GeolocationPermission.location);

      expect(position, expectedPosition);
      expect(log, <Matcher>[
        isMethodCall(
          'getLastKnownPosition',
          arguments: Codec.encodeLocationOptions(expectedArguments),
        ),
      ]);
    });

    test('I should receive an exception if permissions are denied', () async {
      const expectedErrorCode = 'PERMISSION_DENIED';
      const expectedErrorMessage = 'Access to location data denied';

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.denied);

      try {
        await geolocator.getLastKnownPosition(
            locationPermissionLevel: GeolocationPermission.location);
      } on PlatformException catch (e) {
        expect(e.code, expectedErrorCode);
        expect(e.message, expectedErrorMessage);
      }
    });

    test('I should receive null if supplying invalid parameters', () async {
      initMockMethodChannel('getLastKnownPosition', null);

      final expectedArguments =
          LocationOptions(forceAndroidLocationManager: true);

      when(mockPermissionHandler.checkPermissionStatus(
              level: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      var position = await geolocator.getLastKnownPosition(
          locationPermissionLevel: GeolocationPermission.location);

      expect(position, null);
      expect(log, <Matcher>[
        isMethodCall(
          'getLastKnownPosition',
          arguments: Codec.encodeLocationOptions(expectedArguments),
        ),
      ]);
    });
  });

  group('When requesting placemark based on Address', () {
    group('And not specifying a locale', () {
      test('I should receive a placemark containing the coordinates', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel('placemarkFromAddress', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromAddress(address);

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('The localeIdentifier parameter should not be send to the platform', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel('placemarkFromAddress', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromAddress(address);

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromAddress',
            arguments: <String, String>{'address': address},
          ),
        ]);
      });
    });

    group('And specifying a locale', () {
      test('I should receive a placemark containing the coordinates', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel('placemarkFromAddress', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromAddress(address, localeIdentifier: 'nl-NL');

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('The localeIdentifier parameter should be send to the platform', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel('placemarkFromAddress', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromAddress(address, localeIdentifier: 'nl-NL');
        
        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromAddress',
            arguments: <String, String>{'address': address, 'localeIdentifier': 'nl-NL'},
          ),
        ]);
      });
    });
  });
}
