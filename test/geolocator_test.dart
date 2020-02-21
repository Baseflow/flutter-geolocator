import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:mockito/mockito.dart';
import 'src/factories/placemark_factory.dart';
import 'src/factories/position_factory.dart';

class MockEventChannel extends Mock implements EventChannel {}

class MockPermissionHandler extends Mock implements LocationPermissions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockPermissionHandler mockPermissionHandler;
  MockEventChannel mockEventChannel;
  MethodChannel mockMethodChannel;
  final List<MethodCall> log = <MethodCall>[];
  Geolocator geolocator;

  setUp(() async {
    log.clear();

    mockEventChannel = MockEventChannel();
    mockMethodChannel =
        MethodChannel('flutter.baseflow.com/geolocator/methods');
    mockPermissionHandler = MockPermissionHandler();

    geolocator = Geolocator.private(
        mockMethodChannel, mockEventChannel, mockPermissionHandler);
  });

  tearDown(() {
    mockMethodChannel.setMockMethodCallHandler(null);
  });

  var initMockMethodChannel = (String method, dynamic result) {
    // Mock the Geolocator method channel, simulating the Android/ iOS side
    // of the plugin library.
    mockMethodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);

      if (methodCall.method == method) {
        return result;
      } else {
        return null;
      }
    });
  };

  test(
      'When calling the constructor a second time we should retrieve the same instance (test singleton pattern)',
      () {
    final firstInstance = Geolocator();
    final secondInstance = Geolocator();

    expect(identical(firstInstance, secondInstance), true);
  });

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
    StreamController<Map<String, dynamic>> controller;
    var codedOptions = Codec.encodeLocationOptions(
      LocationOptions(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );

    setUp(() {
      controller = StreamController<Map<String, dynamic>>();
      when(mockEventChannel.receiveBroadcastStream(codedOptions))
          .thenAnswer((_) => controller.stream);
    });

    tearDown(() {
      controller.close();
    });

    /*
    test('the receiveBroadcast method should be called only once.', () async {
      when(mockPermissionHandler.requestPermissions(
              permissionLevel: LocationPermissionLevel.location))
          .thenAnswer((_) => Future.value(PermissionStatus.granted));

      await geolocator.getPositionStream();
      await geolocator.getPositionStream();

      await expectLater(1, verify(mockEventChannel.receiveBroadcastStream(codedOptions)).callCount);
    });
    */

    test(
        'I should receive a stream with position updates if permissions are granted',
        () {
      when(mockPermissionHandler.requestPermissions(
              permissionLevel: LocationPermissionLevel.location))
          .thenAnswer((_) async => PermissionStatus.granted);

      final Position mockPosition = PositionFactory.createMockPosition();
      final Stream<Position> positionStream = geolocator.getPositionStream();

      expectLater(positionStream, emits(mockPosition));

      controller.add(mockPosition.toJson());
    });

    test('I should receive an exception if permissions are denied', () async {
      const expectedErrorCode = 'PERMISSION_DENIED';
      const expectedErrorMessage = 'Access to location data denied';

      when(mockPermissionHandler.requestPermissions(
        permissionLevel: LocationPermissionLevel.location,
      )).thenAnswer((_) async => PermissionStatus.denied);

      var positionStream = geolocator.getPositionStream();
      try {
        await for (var position in positionStream) {
          fail("Did not expect $position");
        }
      } on PlatformException catch (e) {
        expect(e.code, expectedErrorCode);
        expect(e.message, expectedErrorMessage);
      }

      controller.add(PositionFactory.createMockPosition().toJson());
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
    group('and not specifying a locale', () {
      test('I should receive a placemark containing the coordinates', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel(
            'placemarkFromAddress', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromAddress(address);

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('the localeIdentifier parameter should not be send to the platform',
          () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel(
            'placemarkFromAddress', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromAddress(address);

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromAddress',
            arguments: <String, String>{'address': address},
          ),
        ]);
      });
    });

    group('and specifying a locale', () {
      test('I should receive a placemark containing the coordinates', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel(
            'placemarkFromAddress', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks = await geolocator
            .placemarkFromAddress(address, localeIdentifier: 'nl-NL');

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('the localeIdentifier parameter should be send to the platform',
          () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final address = 'Gronausestraat, Enschede';

        initMockMethodChannel(
            'placemarkFromAddress', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromAddress(address,
            localeIdentifier: 'nl-NL');

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromAddress',
            arguments: <String, String>{
              'address': address,
              'localeIdentifier': 'nl-NL'
            },
          ),
        ]);
      });
    });
  });

  group('When requesting placemark based on Coordinates', () {
    group('and not specifying a locale', () {
      test('I should receive a placemark containing the address', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final latitude = 52.561270;
        final longitude = 5.639382;

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromCoordinates(latitude, longitude);

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('the localeIdentifier parameter should not be send to the platform',
          () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final latitude = 52.561270;
        final longitude = 5.639382;

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromCoordinates(latitude, longitude);

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromCoordinates',
            arguments: <String, dynamic>{
              'latitude': latitude,
              'longitude': longitude,
            },
          ),
        ]);
      });
    });

    group('and specifying a locale', () {
      test('I should receive a placemark containing the address', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final latitude = 52.561270;
        final longitude = 5.639382;

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromCoordinates(latitude, longitude,
                localeIdentifier: 'nl-NL');

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('the localeIdentifier parameter should be send to the platform',
          () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final latitude = 52.561270;
        final longitude = 5.639382;

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromCoordinates(latitude, longitude,
            localeIdentifier: 'nl-NL');

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromCoordinates',
            arguments: <String, dynamic>{
              'latitude': latitude,
              'longitude': longitude,
              'localeIdentifier': 'nl-NL',
            },
          ),
        ]);
      });
    });
  });

  group('When requesting a placemark based on a Position', () {
    group('and not specifying a locale', () {
      test('I should receive a placemark containing the address', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final position = Position(latitude: 52.561270, longitude: 5.639382);

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromPosition(position);

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('the localeIdentifier parameter should not be send to the platform',
          () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final position = Position(latitude: 52.561270, longitude: 5.639382);

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromPosition(position);

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromCoordinates',
            arguments: <String, dynamic>{
              'latitude': position.latitude,
              'longitude': position.longitude,
            },
          ),
        ]);
      });
    });

    group('and specifying a locale', () {
      test('I should receive a placemark containing the address', () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final position = Position(latitude: 52.561270, longitude: 5.639382);

        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        final List<Placemark> placemarks =
            await geolocator.placemarkFromPosition(
          position,
          localeIdentifier: 'nl-NL',
        );

        expect(placemarks.length, 1);
        expect(placemarks.first, expectedPlacemark);
      });

      test('the localeIdentifier parameter should be send to the platform',
          () async {
        final expectedPlacemark = PlacemarkFactory.createMockPlacemark();
        final position = Position(latitude: 52.561270, longitude: 5.639382);
        initMockMethodChannel(
            'placemarkFromCoordinates', [expectedPlacemark.toJson()]);

        await geolocator.placemarkFromPosition(
          position,
          localeIdentifier: 'nl-NL',
        );

        expect(log, <Matcher>[
          isMethodCall(
            'placemarkFromCoordinates',
            arguments: <String, dynamic>{
              'latitude': position.latitude,
              'longitude': position.longitude,
              'localeIdentifier': 'nl-NL',
            },
          ),
        ]);
      });
    });
  });

  group('When requesting the distance between two points', () {
    test(
        'the "distanceBetween" message should be send to the platform containing the point details',
        () async {
      final startLatitude = 52.0;
      final startLongitude = 5.6;
      final endLatitude = 53.0;
      final endLongitude = 5.7;

      initMockMethodChannel('distanceBetween', 10.00);

      final double distance = await geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(distance, 10.00);
      expect(log, <Matcher>[
        isMethodCall(
          'distanceBetween',
          arguments: <String, double>{
            'startLatitude': startLatitude,
            'startLongitude': startLongitude,
            'endLatitude': endLatitude,
            'endLongitude': endLongitude,
          },
        ),
      ]);
    });
  });

  group('When requesting the bearing between', () {
    test('the same points the bearing should be 0', () async {
      final latitude = 56.0;
      final longitude = 5.6;

      final bearing = await geolocator.bearingBetween(
        latitude,
        longitude,
        latitude,
        longitude,
      );

      expect(bearing, 0.0);
    });

    test('the North pole to the Sounth pole bearing should be 180', () async {
      final startLatitude = 90.0;
      final startLongitude = 0.0;
      final endLatitude = -90.0;
      final endLongitude = 0.0;

      final bearing = await geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, 180.0);
    });

    test('the South pole to the North pole bearing should be 0', () async {
      final startLatitude = -90.0;
      final startLongitude = 0.0;
      final endLatitude = 90.0;
      final endLongitude = 0.0;

      final bearing = await geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, 0.0);
    });

    test('the West to the East bearing should be 90', () async {
      final startLatitude = 0.0;
      final startLongitude = 180.0;
      final endLatitude = 0.0;
      final endLongitude = -180.0;

      final bearing = await geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, 90.0);
    });

    test('the East to the West bearing should be -90', () async {
      final startLatitude = 0.0;
      final startLongitude = -180.0;
      final endLatitude = 0.0;
      final endLongitude = 180.0;

      final bearing = await geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, -90.0);
    });
  });
}
