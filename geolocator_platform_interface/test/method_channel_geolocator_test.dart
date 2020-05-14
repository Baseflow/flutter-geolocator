import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_platform_interface/src/implementations/method_channel_geolocator.dart';
import 'package:location_permissions/location_permissions.dart'
    as permission_lib;
import 'package:mockito/mockito.dart';

class MockPermissionHandler extends Mock
    implements permission_lib.LocationPermissions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final _mockPosition = Position(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000.0,
      accuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  group('$MethodChannelGeolocator()', () {
    final log = <MethodCall>[];
    MethodChannelGeolocator methodChannelGeolocator;
    MockPermissionHandler mockPermissionHandler;

    setUp(() async {
      methodChannelGeolocator = MethodChannelGeolocator();
      mockPermissionHandler = MockPermissionHandler();

      // Inject mock implementation of the permission handler
      methodChannelGeolocator.permissionHandler = mockPermissionHandler;

      // Configure mock implementation for the MethodChannel
      methodChannelGeolocator.methodChannel
          .setMockMethodCallHandler((call) async {
        log.add(call);

        switch (call.method) {
          case 'getLastKnownPosition':
            return _mockPosition.toJson();
          default:
            return null;
        }
      });

      // Configure mock implementation for the EventChannel
      MethodChannel(methodChannelGeolocator.eventChannel.name)
          .setMockMethodCallHandler((methodCall) async {
        switch (methodCall.method) {
          case 'listen':
            await ServicesBinding.instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannelGeolocator.eventChannel.name,
              methodChannelGeolocator.eventChannel.codec
                  .encodeSuccessEnvelope(_mockPosition.toJson()),
              (_) {},
            );
            break;
          case 'cancel':
          default:
            return null;
        }
      });

      log.clear();
    });

    group('When requesting the last know position', () {
      test('I should receive a position if permissions are granted', () async {
        // Arrange
        final expectedArguments = LocationOptions(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        when(mockPermissionHandler.checkPermissionStatus(
                level: permission_lib.LocationPermissionLevel.location))
            .thenAnswer((_) async => permission_lib.PermissionStatus.granted);

        // Act
        final position = await methodChannelGeolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.low,
          permission: Permission.location,
        );

        // Arrange
        expect(position, _mockPosition);
        expect(log, <Matcher>[
          isMethodCall(
            'getLastKnownPosition',
            arguments: expectedArguments.toJson(),
          ),
        ]);
      });

      test('I should receive an exception if permissions are denied', () async {
        // Arrange
        when(mockPermissionHandler.checkPermissionStatus(
                level: permission_lib.LocationPermissionLevel.location))
            .thenAnswer((_) async => permission_lib.PermissionStatus.denied);

        // Act & Assert
        try {
          await methodChannelGeolocator.getLastKnownPosition(
            desiredAccuracy: LocationAccuracy.best,
            permission: Permission.location,
          );
        } on PermissionDeniedException catch (e) {
          expect(e.permission, Permission.location);
        }
      });
    });
  });
}
