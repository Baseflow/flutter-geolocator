import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_platform_interface/src/implementations/method_channel_geolocator.dart';

Position get mockPosition => Position(
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
    speedAccuracy: 0.0,
    isMocked: false);

Stream<Position> createPositionStream(
  Duration interval, {
  int maxCount,
  LocationPermission checkPermission,
  bool isMissingPermissionDefinitions,
  bool isAlreadyRequestingPermissions,
  bool isLocationServiceEnabled,
  bool isAlreadySubscribed = false,
  bool hasPositionUpdateException = false,
}) {
  StreamController<Position> controller;
  var counter = 0;
  Timer timer;

  void tick(_) {
    counter++;

    if (checkPermission == LocationPermission.denied) {
      controller.addError(PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Permission denied',
        details: null,
      ));
    } else if (checkPermission == LocationPermission.deniedForever) {
      controller.addError(PlatformException(
        code: 'PERMISSION_DENIED_FOREVER',
        message: 'Permission denied forever',
        details: null,
      ));
    } else if (isMissingPermissionDefinitions) {
      controller.addError(PlatformException(
        code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
        message: 'Permission definitions are not found.',
        details: null,
      ));
    } else if (isAlreadyRequestingPermissions) {
      controller.addError(PlatformException(
        code: 'PERMISSION_REQUEST_IN_PROGRESS',
        message: 'Permissions already being requested.',
        details: null,
      ));
    } else if (!isLocationServiceEnabled) {
      controller.addError(PlatformException(
        code: 'LOCATION_SERVICES_DISABLED',
        message: 'Location service disabled',
        details: null,
      ));
    } else if (isAlreadySubscribed) {
      controller.addError(PlatformException(
        code: 'LOCATION_SUBSCRIPTION_ACTIVE',
        message: 'Position stream already active',
        details: null,
      ));
    } else if (hasPositionUpdateException) {
      controller.addError(PlatformException(
        code: 'LOCATION_UPDATE_FAILURE',
        message: 'Exception while listening for position updates',
        details: null,
      ));
    } else {
      controller.add(mockPosition);
    }

    if (counter == maxCount) {
      timer.cancel();
      controller.close();
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  controller = StreamController<Position>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var _mockPermission = LocationPermission.denied;
  var _mockIsLocationServiceEnabled = true;
  var _mockIsAlreadyRequestingPermission = false;
  var _mockIsMissingPermissionDefinitions = false;
  var _mockIsAlreadySubscribed = false;
  var _mockHasPositionUpdateException = false;
  var _mockCanOpenAppSettings = false;
  var _mockCanOpenLocationSettings = false;

  group('$MethodChannelGeolocator()', () {
    final log = <MethodCall>[];
    MethodChannelGeolocator methodChannelGeolocator;
    StreamSubscription positionStreamSubscription;

    setUp(() async {
      methodChannelGeolocator = MethodChannelGeolocator();

      // Configure mock implementation for the MethodChannel
      methodChannelGeolocator.methodChannel
          .setMockMethodCallHandler((methodCall) async {
        log.add(methodCall);

        final method = methodCall.method;
        if (method == 'requestPermission') {
          if (_mockIsMissingPermissionDefinitions) {
            throw PlatformException(
              code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
              message: 'Permission definitions are not found.',
              details: null,
            );
          } else if (_mockIsAlreadyRequestingPermission) {
            throw PlatformException(
              code: 'PERMISSION_REQUEST_IN_PROGRESS',
              message: 'Permissions already being requested.',
              details: null,
            );
          }

          return _mockPermission.index;
        }

        if (method == 'getLastKnownPosition') {
          if (_mockPermission == LocationPermission.denied) {
            throw PlatformException(
              code: 'PERMISSION_DENIED',
              message: 'Permission denied',
              details: null,
            );
          } else if (_mockPermission == LocationPermission.deniedForever) {
            throw PlatformException(
              code: 'PERMISSION_DENIED_FOREVER',
              message: 'Permission denied forever',
              details: null,
            );
          } else if (_mockIsMissingPermissionDefinitions) {
            throw PlatformException(
              code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
              message: 'Permission definitions are not found.',
              details: null,
            );
          } else if (_mockIsAlreadyRequestingPermission) {
            throw PlatformException(
              code: 'PERMISSION_REQUEST_IN_PROGRESS',
              message: 'Permissions already being requested.',
              details: null,
            );
          }
          return mockPosition.toJson();
        }

        if (method == 'checkPermission') {
          if (_mockIsMissingPermissionDefinitions) {
            throw PlatformException(
              code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
              message: 'Permission definitions are not found.',
              details: null,
            );
          }

          return _mockPermission.index;
        }

        if (method == 'isLocationServiceEnabled') {
          return _mockIsLocationServiceEnabled;
        }

        if (method == 'openAppSettings') {
          return _mockCanOpenAppSettings;
        }

        if (method == 'openLocationSettings') {
          return _mockCanOpenLocationSettings;
        }

        return null;
      });

      // Configure mock implementation for the EventChannel
      MethodChannel(methodChannelGeolocator.eventChannel.name)
          .setMockMethodCallHandler((methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'listen':
            positionStreamSubscription = createPositionStream(
              Duration(milliseconds: 10),
              maxCount: 3,
              checkPermission: _mockPermission,
              isAlreadyRequestingPermissions:
                  _mockIsAlreadyRequestingPermission,
              isLocationServiceEnabled: _mockIsLocationServiceEnabled,
              isMissingPermissionDefinitions:
                  _mockIsMissingPermissionDefinitions,
              isAlreadySubscribed: _mockIsAlreadySubscribed,
              hasPositionUpdateException: _mockHasPositionUpdateException,
            ).listen(
              (data) {
                ServicesBinding.instance.defaultBinaryMessenger
                    .handlePlatformMessage(
                  methodChannelGeolocator.eventChannel.name,
                  methodChannelGeolocator.eventChannel.codec
                      .encodeSuccessEnvelope(mockPosition.toJson()),
                  (_) {},
                );
              },
              onError: (e) {
                var code = "UNKNOWN_EXCEPTION";
                String message;
                dynamic details;

                if (e is PlatformException) {
                  code = e.code;
                  message = e.message;
                  details = e.details;
                }

                ServicesBinding.instance.defaultBinaryMessenger
                    .handlePlatformMessage(
                  methodChannelGeolocator.eventChannel.name,
                  methodChannelGeolocator.eventChannel.codec
                      .encodeErrorEnvelope(
                    code: code,
                    message: message,
                    details: details,
                  ),
                  (_) {},
                );
              },
            );

            break;
          case 'cancel':
            if (positionStreamSubscription != null) {
              positionStreamSubscription.cancel();
            }
            break;
          default:
            return null;
        }
      });

      log.clear();
    });

    group('checkPermission: When checking for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;

        // Act
        final permission = await methodChannelGeolocator.checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        _mockPermission = LocationPermission.always;

        // Act
        final permission = await methodChannelGeolocator.checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        _mockPermission = LocationPermission.denied;

        // Act
        final permission = await methodChannelGeolocator.checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.denied,
        );
      });

      test('Should receive deniedForEver if permission is denied for ever',
          () async {
        // Arrange
        _mockPermission = LocationPermission.deniedForever;

        // Act
        final permission = await methodChannelGeolocator.checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.deniedForever,
        );
      });

      test('Should receive an exception when permission definitions not found',
          () async {
        // Arrange
        _mockIsMissingPermissionDefinitions = true;

        // Act
        final permissionFuture = methodChannelGeolocator.checkPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<PermissionDefinitionsNotFoundException>().having(
              (e) => e.message,
              'description',
              'Permission definitions are not found.',
            ),
          ),
        );
      });
    });

    group('requestPermission: When requesting for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;

        // Act
        final permission = await methodChannelGeolocator.requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        _mockPermission = LocationPermission.always;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;

        // Act
        final permission = await methodChannelGeolocator.requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        _mockPermission = LocationPermission.denied;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;

        // Act
        final permission = await methodChannelGeolocator.requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.denied,
        );
      });

      test('Should receive deniedForEver if permission is denied for ever',
          () async {
        // Arrange
        _mockPermission = LocationPermission.deniedForever;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;

        // Act
        final permission = await methodChannelGeolocator.requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.deniedForever,
        );
      });

      test('Should receive an exception when already requesting permission',
          () async {
        // Arrange
        _mockIsAlreadyRequestingPermission = true;
        _mockIsMissingPermissionDefinitions = false;

        // Act
        final permissionFuture = methodChannelGeolocator.requestPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<PermissionRequestInProgressException>().having(
              (e) => e.message,
              'description',
              'Permissions already being requested.',
            ),
          ),
        );
      });

      test('Should receive an exception when permission definitions not found',
          () async {
        // Arrange
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = true;

        // Act
        final permissionFuture = methodChannelGeolocator.requestPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<PermissionDefinitionsNotFoundException>().having(
              (e) => e.message,
              'description',
              'Permission definitions are not found.',
            ),
          ),
        );
      });
    });

    group('isLocationServiceEnabled: When checking the location service status',
        () {
      test('Should receive true if location services are enabled', () async {
        // Arrange
        _mockIsLocationServiceEnabled = true;

        // Act
        final isLocationServiceEnabled =
            await methodChannelGeolocator.isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          true,
        );
      });

      test('Should receive false if location services are disabled', () async {
        // Arrange
        _mockIsLocationServiceEnabled = false;

        // Act
        final isLocationServiceEnabled =
            await methodChannelGeolocator.isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          false,
        );
      });
    });

    group('getLastKnowPosition: When requesting the last know position', () {
      test('Should receive a position if permissions are granted', () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;

        final expectedArguments = <String, dynamic>{
          "forceAndroidLocationManager": false,
        };

        // Act
        final position = await methodChannelGeolocator.getLastKnownPosition(
          forceAndroidLocationManager: false,
        );

        // Arrange
        expect(position, mockPosition);
        expect(log, <Matcher>[
          isMethodCall(
            'getLastKnownPosition',
            arguments: expectedArguments,
          ),
        ]);
      });

      test('Should receive an exception if permissions are denied', () async {
        // Arrange
        _mockPermission = LocationPermission.denied;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;

        // Act
        final future = methodChannelGeolocator.getLastKnownPosition(
          forceAndroidLocationManager: false,
        );

        // Assert
        expect(
          future,
          throwsA(
            isA<PermissionDeniedException>().having(
              (e) => e.message,
              'description',
              'Permission denied',
            ),
          ),
        );
      });
    });

    group('getCurrentPosition: When requesting the current position', () {
      test('Should receive a position if permissions are granted', () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;

        final expectedArguments = LocationOptions(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        // Act
        final position = await methodChannelGeolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        // Assert
        expect(position, mockPosition);
        expect(log, <Matcher>[
          isMethodCall(
            'listen',
            arguments: expectedArguments.toJson(),
          ),
          isMethodCall(
            'cancel',
            arguments: expectedArguments.toJson(),
          ),
        ]);
      });

      test('Should receive a position for each call', () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;

        // Act
        final position = await methodChannelGeolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        final secondPosition = await methodChannelGeolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Assert
        expect(position, mockPosition);
        expect(secondPosition, mockPosition);
      });

      test('Should throw a permission denied exception if permission is denied',
          () async {
        // Arrange
        _mockPermission = LocationPermission.denied;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;

        // Act
        final future = methodChannelGeolocator.getCurrentPosition();

        // Assert
        expect(
          future,
          throwsA(
            isA<PermissionDeniedException>().having(
              (e) => e.message,
              'description',
              'Permission denied',
            ),
          ),
        );
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should throw a location service disabled exception if location services are disabled',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = false;

        // Act
        final future = methodChannelGeolocator.getCurrentPosition();

        // Assert
        expect(
          future,
          throwsA(isA<LocationServiceDisabledException>()),
        );
      });

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;
        final expectedArguments = LocationOptions(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        // Act
        final future = methodChannelGeolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: Duration(milliseconds: 5),
        );

        // Assert
        expect(
          future,
          throwsA(isA<TimeoutException>()),
        );

        await Future.delayed(Duration(milliseconds: 10));

        expect(log, <Matcher>[
          isMethodCall(
            'listen',
            arguments: expectedArguments.toJson(),
          ),
          isMethodCall(
            'cancel',
            arguments: expectedArguments.toJson(),
          ),
        ]);
      });
    });

    group('getPositionStream: When requesting a stream of position updates',
        () {
      group('And requesting for position update multiple times', () {
        test('Should return the same stream', () {
          final firstStream = methodChannelGeolocator.getPositionStream();
          final secondStream = methodChannelGeolocator.getPositionStream();

          expect(
            identical(firstStream, secondStream),
            true,
          );
        });
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a stream with position updates if permissions are granted',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;

        // Act
        final positionStream = methodChannelGeolocator.getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Assert
        expect(await streamQueue.next, mockPosition);
        expect(await streamQueue.next, mockPosition);
        expect(await streamQueue.next, mockPosition);

        // Clean up
        await streamQueue.cancel();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a permission denied exception if permission is denied',
          () async {
        // Arrange
        _mockPermission = LocationPermission.denied;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;

        // Act
        final positionStream = methodChannelGeolocator.getPositionStream();

        // Assert
        expect(
          positionStream,
          emitsAnyOf([
            emitsError(
              isA<PermissionDeniedException>().having(
                (source) => source.message,
                'Permission denied',
                'Permission denied',
              ),
            ),
          ]),
        );
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a location service disabled exception if location service is disabled',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = false;

        // Act
        var positionStream = methodChannelGeolocator.getPositionStream();

        // Assert
        expect(
          positionStream,
          emitsInAnyOrder([
            emitsError(
              isA<LocationServiceDisabledException>(),
            ),
          ]),
        );
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a already subscribed exception', () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;
        _mockIsAlreadySubscribed = true;

        // Act
        var positionStream = methodChannelGeolocator.getPositionStream();

        // Assert
        expect(
          positionStream,
          emitsInAnyOrder([
            emitsError(
              isA<AlreadySubscribedException>(),
            ),
          ]),
        );
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a position update exception', () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;
        _mockIsAlreadySubscribed = false;
        _mockHasPositionUpdateException = true;

        // Act
        var positionStream = methodChannelGeolocator.getPositionStream();

        // Assert
        expect(
          positionStream,
          emitsInAnyOrder([
            emitsError(
              isA<PositionUpdateException>(),
            ),
          ]),
        );
      });

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        _mockPermission = LocationPermission.whileInUse;
        _mockIsAlreadyRequestingPermission = false;
        _mockIsMissingPermissionDefinitions = false;
        _mockIsLocationServiceEnabled = true;
        final expectedArguments = LocationOptions(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        // Act
        final positionStream = methodChannelGeolocator.getPositionStream(
            desiredAccuracy: expectedArguments.accuracy,
            timeLimit: Duration(milliseconds: 5));

        // Assert
        expect(
          positionStream,
          emitsInOrder([
            emitsError(isA<TimeoutException>()),
            emitsDone,
          ]),
        );

        await Future.delayed(Duration(milliseconds: 10));

        expect(log, <Matcher>[
          isMethodCall(
            'listen',
            arguments: expectedArguments.toJson(),
          ),
          isMethodCall(
            'cancel',
            arguments: expectedArguments.toJson(),
          ),
        ]);
      });
    });

    group('openAppSettings: When opening the App settings', () {
      test('Should receive true if the page can be opened', () async {
        // Arrange
        _mockCanOpenAppSettings = true;

        // Act
        final hasOpenedAppSettings =
            await methodChannelGeolocator.openAppSettings();

        // Assert
        expect(
          hasOpenedAppSettings,
          true,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        _mockCanOpenAppSettings = false;

        // Act
        final hasOpenedAppSettings =
            await methodChannelGeolocator.openAppSettings();

        // Assert
        expect(
          hasOpenedAppSettings,
          false,
        );
      });
    });

    group('openLocationSettings: When opening the Location settings', () {
      test('Should receive true if the page can be opened', () async {
        // Arrange
        _mockCanOpenLocationSettings = true;

        // Act
        final hasOpenedLocationSettings =
            await methodChannelGeolocator.openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          true,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        _mockCanOpenLocationSettings = false;

        // Act
        final hasOpenedLocationSettings =
            await methodChannelGeolocator.openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          false,
        );
      });
    });
  });
}
