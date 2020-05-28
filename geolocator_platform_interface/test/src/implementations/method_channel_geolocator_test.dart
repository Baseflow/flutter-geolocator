import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
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
    speedAccuracy: 0.0);

Stream<Position> createPositionStream(
  Duration interval, {
  int maxCount,
  bool hasPermission,
  bool isLocationServiceEnabled,
}) {
  StreamController<Position> controller;
  var counter = 0;
  Timer timer;

  void tick(_) {
    counter++;

    if (!hasPermission) {
      controller.addError(PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Permission denied',
        details: null,
      ));
    } else if (!isLocationServiceEnabled) {
      controller.addError(PlatformException(
        code: 'LOCATION_SERVICE_DISABLED',
        message: 'Location service disabled',
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

  var _mockHasPermission = true;
  var _mockIsLocationServiceEnabled = true;

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

        switch (methodCall.method) {
          case 'getLastKnownPosition':
            if (!_mockHasPermission) {
              throw PlatformException(
                code: 'PERMISSION_DENIED',
                message: 'Permission denied',
                details: null,
              );
            }
            return mockPosition.toJson();
          case 'hasPermission':
            return _mockHasPermission;
          case 'isLocationServiceEnabled':
            return _mockIsLocationServiceEnabled;
          default:
            return null;
        }
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
              hasPermission: _mockHasPermission,
              isLocationServiceEnabled: _mockIsLocationServiceEnabled,
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

    group('hasPermission: When checking for permission', () {
      test('Should receive true if permission is granted', () async {
        // Arrange
        _mockHasPermission = true;

        // Act
        final hasPermission = await methodChannelGeolocator.hasPermission();

        // Assert
        expect(
          hasPermission,
          true,
        );
      });

      test('Should receive false if permission is denied', () async {
        // Arrange
        _mockHasPermission = false;

        // Act
        final hasPermission = await methodChannelGeolocator.hasPermission();

        // Assert
        expect(
          hasPermission,
          false,
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
        _mockHasPermission = true;
        final expectedArguments = LocationOptions(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        // Act
        final position = await methodChannelGeolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        // Arrange
        expect(position, mockPosition);
        expect(log, <Matcher>[
          isMethodCall(
            'getLastKnownPosition',
            arguments: expectedArguments.toJson(),
          ),
        ]);
      });

      test('Should receive an exception if permissions are denied', () async {
        // Arrange
        _mockHasPermission = false;

        // Act
        final future = methodChannelGeolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best,
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
        _mockHasPermission = true;
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

      test('Should throw a permission denied exception if permission is denied',
          () async {
        // Arrange
        _mockHasPermission = false;
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
        _mockHasPermission = true;
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
        _mockHasPermission = true;
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
      
      group('And requesting for position update multiple times', (){
        test('Should return the same stream', () {
          final firstStream = methodChannelGeolocator.getPositionStream();
          final secondStream = methodChannelGeolocator.getPositionStream();

          expect(identical(firstStream, secondStream), true,);
        });
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a stream with position updates if permissions are granted',
          () async {
        // Arrange
        _mockHasPermission = true;
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
        _mockHasPermission = false;
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
        _mockHasPermission = true;
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

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        _mockHasPermission = true;
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
        fakeAsync((a) {
          expect(
            positionStream,
            emitsInOrder([
              emitsError(isA<TimeoutException>()),
              emitsDone,
            ]),
          );

          a.elapse(Duration(milliseconds: 10));

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
    });
  });
}
