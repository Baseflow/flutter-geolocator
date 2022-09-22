import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_android/geolocator_android.dart';

import 'event_channel_mock.dart';
import 'method_channel_mock.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$GeolocatorAndroid()', () {
    final log = <MethodCall>[];

    tearDown(log.clear);

    group('checkPermission: When checking for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'checkPermission',
            result: LocationPermission.whileInUse.index);

        // Act
        final permission = await GeolocatorAndroid().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'checkPermission',
            result: LocationPermission.always.index);

        // Act
        final permission = await GeolocatorAndroid().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'checkPermission',
            result: LocationPermission.denied.index);

        // Act
        final permission = await GeolocatorAndroid().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.denied,
        );
      });

      test('Should receive deniedForEver if permission is denied for ever',
          () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'checkPermission',
            result: LocationPermission.deniedForever.index);

        // Act
        final permission = await GeolocatorAndroid().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.deniedForever,
        );
      });

      test('Should receive an exception when permission definitions not found',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'checkPermission',
          result: PlatformException(
            code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
            message: 'Permission definitions are not found.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = GeolocatorAndroid().checkPermission();

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

    group(
        'requestTemporaryFullAccuracy: When requesting temporary full'
        'accuracy.', () {
      test(
          'Should receive reduced accuracy if Location Accuracy is pinned to'
          ' reduced', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'requestTemporaryFullAccuracy',
            result: 0);

        final expectedArguments = <String, dynamic>{
          'purposeKey': 'purposeKeyValue',
        };

        // Act
        final accuracy = await GeolocatorAndroid().requestTemporaryFullAccuracy(
          purposeKey: 'purposeKeyValue',
        );

        // Assert
        expect(accuracy, LocationAccuracyStatus.reduced);

        expect(methodChannel.log, <Matcher>[
          isMethodCall(
            'requestTemporaryFullAccuracy',
            arguments: expectedArguments,
          ),
        ]);
      });

      test(
          'Should receive reduced accuracy if Location Accuracy is already set'
          ' to precise location accuracy', () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'requestTemporaryFullAccuracy',
            result: 1);

        // Act
        final accuracy = await GeolocatorAndroid()
            .requestTemporaryFullAccuracy(purposeKey: 'purposeKey');

        // Assert
        expect(accuracy, LocationAccuracyStatus.precise);
      });

      test('Should receive an exception when permission definitions not found',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'requestTemporaryFullAccuracy',
          result: PlatformException(
            code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
            message: 'Permission definitions are not found.',
            details: null,
          ),
        );

        // Act
        final future = GeolocatorAndroid()
            .requestTemporaryFullAccuracy(purposeKey: 'purposeKey');

        // Assert
        expect(
          future,
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

    group('getLocationAccuracy: When requesting the Location Accuracy Status',
        () {
      test('Should receive reduced accuracy if Location Accuracy is reduced',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getLocationAccuracy',
          result: 0,
        );

        // Act
        final locationAccuracy =
            await GeolocatorAndroid().getLocationAccuracy();

        // Assert
        expect(locationAccuracy, LocationAccuracyStatus.reduced);
      });

      test('Should receive reduced accuracy if Location Accuracy is reduced',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getLocationAccuracy',
          result: 1,
        );

        // Act
        final locationAccuracy =
            await GeolocatorAndroid().getLocationAccuracy();

        // Assert
        expect(locationAccuracy, LocationAccuracyStatus.precise);
      });
    });

    group('requestPermission: When requesting for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'requestPermission',
            result: LocationPermission.whileInUse.index);

        // Act
        final permission = await GeolocatorAndroid().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'requestPermission',
            result: LocationPermission.always.index);

        // Act
        final permission = await GeolocatorAndroid().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'requestPermission',
            result: LocationPermission.denied.index);

        // Act
        final permission = await GeolocatorAndroid().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.denied,
        );
      });

      test('Should receive deniedForever if permission is denied for ever',
          () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'requestPermission',
            result: LocationPermission.deniedForever.index);

        // Act
        final permission = await GeolocatorAndroid().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.deniedForever,
        );
      });

      test('Should receive an exception when already requesting permission',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'requestPermission',
          result: PlatformException(
            code: "PERMISSION_REQUEST_IN_PROGRESS",
            message: "Permissions already being requested.",
            details: null,
          ),
        );

        // Act
        final permissionFuture = GeolocatorAndroid().requestPermission();

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
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'requestPermission',
          result: PlatformException(
            code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
            message: 'Permission definitions are not found.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = GeolocatorAndroid().requestPermission();

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

      test('Should receive an exception when android activity is missing',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'requestPermission',
          result: PlatformException(
            code: 'ACTIVITY_MISSING',
            message: 'Activity is missing.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = GeolocatorAndroid().requestPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<ActivityMissingException>().having(
              (e) => e.message,
              'description',
              'Activity is missing.',
            ),
          ),
        );
      });
    });

    group('isLocationServiceEnabled: When checking the location service status',
        () {
      test('Should receive true if location services are enabled', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'isLocationServiceEnabled',
          result: true,
        );

        // Act
        final isLocationServiceEnabled =
            await GeolocatorAndroid().isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          true,
        );
      });

      test('Should receive false if location services are disabled', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'isLocationServiceEnabled',
          result: false,
        );

        // Act
        final isLocationServiceEnabled =
            await GeolocatorAndroid().isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          false,
        );
      });
    });

    group('getLastKnownPosition: When requesting the last know position', () {
      test('Should receive a position if permissions are granted', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getLastKnownPosition',
          result: mockPosition.toJson(),
        );

        final expectedArguments = <String, dynamic>{
          "forceLocationManager": false,
        };

        // Act
        final position = await GeolocatorAndroid().getLastKnownPosition(
          forceLocationManager: false,
        );

        // Arrange
        expect(position, mockPosition);
        expect(methodChannel.log, <Matcher>[
          isMethodCall(
            'getLastKnownPosition',
            arguments: expectedArguments,
          ),
        ]);
      });

      test('Should receive an exception if permissions are denied', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getLastKnownPosition',
          result: PlatformException(
            code: "PERMISSION_DENIED",
            message: "Permission denied",
            details: null,
          ),
        );

        // Act
        final future = GeolocatorAndroid().getLastKnownPosition(
          forceLocationManager: false,
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
        final channel = MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_android',
            method: 'getCurrentPosition',
            result: mockPosition.toJson());
        const expectedArguments =
            LocationSettings(accuracy: LocationAccuracy.low);

        // Act
        final position = await GeolocatorAndroid().getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.low));

        // Assert
        expect(position, mockPosition);
        expect(channel.log, <Matcher>[
          isMethodCall(
            'getCurrentPosition',
            arguments: expectedArguments.toJson(),
          ),
        ]);
      });

      test('Should receive a position for each call', () async {
        // Arrange
        final channel = MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getCurrentPosition',
          result: mockPosition.toJson(),
        );
        const expectedFirstArguments = LocationSettings(
          accuracy: LocationAccuracy.low,
        );
        const expectedSecondArguments = LocationSettings(
          accuracy: LocationAccuracy.high,
        );

        // Act
        final plugin = GeolocatorAndroid();
        final firstPosition = await plugin.getCurrentPosition(
            locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ));
        final secondPosition = await plugin.getCurrentPosition(
            locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ));

        // Assert
        expect(firstPosition, mockPosition);
        expect(secondPosition, mockPosition);
        expect(channel.log, <Matcher>[
          isMethodCall(
            'getCurrentPosition',
            arguments: expectedFirstArguments.toJson(),
          ),
          isMethodCall(
            'getCurrentPosition',
            arguments: expectedSecondArguments.toJson(),
          ),
        ]);
      });

      test('Should throw a permission denied exception if permission is denied',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getCurrentPosition',
          result: PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Permission denied',
            details: null,
          ),
        );

        // Act
        final future = GeolocatorAndroid().getCurrentPosition();

        // Assert
        expect(
          future,
          throwsA(
            isA<PermissionDeniedException>().having(
              (e) => e.message,
              'message',
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
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'getCurrentPosition',
          result: PlatformException(
            code: 'LOCATION_SERVICES_DISABLED',
            message: '',
            details: null,
          ),
        );

        // Act
        final future = GeolocatorAndroid().getCurrentPosition();

        // Assert
        expect(
          future,
          throwsA(isA<LocationServiceDisabledException>()),
        );
      });

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          delay: const Duration(milliseconds: 10),
          method: 'getCurrentPosition',
          result: mockPosition.toJson(),
        );

        try {
          await GeolocatorAndroid().getCurrentPosition(
            locationSettings: const LocationSettings(
              timeLimit: Duration(milliseconds: 5),
            ),
          );

          fail('Expected a TimeoutException and should not reach here.');
        } on TimeoutException catch (e) {
          expect(e, isA<TimeoutException>());
        }
      });
    });

    group('getPositionStream: When requesting a stream of position updates',
        () {
      group('And requesting for position update multiple times', () {
        test('Should return the same stream', () {
          final plugin = GeolocatorAndroid();
          final firstStream = plugin.getPositionStream();
          final secondStream = plugin.getPositionStream();

          expect(
            identical(firstStream, secondStream),
            true,
          );
        });

        test('Should return a new stream when all subscriptions are cancelled',
            () {
          final plugin = GeolocatorAndroid();

          // Get two position streams
          final firstStream = plugin.getPositionStream();
          final secondStream = plugin.getPositionStream();

          // Streams are the same object
          expect(firstStream == secondStream, true);

          // Add multiple subscriptions
          StreamSubscription<Position>? firstSubscription =
              firstStream.listen((event) {});
          StreamSubscription<Position>? secondSubscription =
              secondStream.listen((event) {});

          // Cancel first subscription
          firstSubscription.cancel();
          firstSubscription = null;

          // Stream is still the same as the first one
          final cachedStream = plugin.getPositionStream();
          expect(firstStream == cachedStream, true);

          // Cancel second subscription
          secondSubscription.cancel();
          secondSubscription = null;

          // After all listeners have been removed, the next stream
          // retrieved is a new one.
          final thirdStream = plugin.getPositionStream();
          expect(firstStream != thirdStream, true);
        });
      });

      test('PositionStream can be listened to and can be canceled', () {
        // Arrange
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        var stream = GeolocatorAndroid().getPositionStream(
            locationSettings: AndroidSettings(useMSLAltitude: false));
        StreamSubscription<Position>? streamSubscription =
            stream.listen((event) {});

        streamSubscription.pause();
        expect(streamSubscription.isPaused, true);
        streamSubscription.resume();
        expect(streamSubscription.isPaused, false);
        streamSubscription.cancel();
        streamSubscription = null;
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should correctly handle done event', () async {
        // Arrange
        final completer = Completer();
        completer.future.timeout(const Duration(milliseconds: 50),
            onTimeout: () =>
                fail('getPositionStream should trigger done and not timeout.'));
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        GeolocatorAndroid().getPositionStream().listen(
              (event) {},
              onDone: completer.complete,
            );

        await streamController.close();

        //Assert
        await completer.future;
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a stream with position updates if permissions are granted',
          () async {
        // Arrange
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream(
            locationSettings: AndroidSettings(useMSLAltitude: false));
        final streamQueue = StreamQueue(positionStream);

        // Emit test events
        streamController.add(mockPosition.toJson());
        streamController.add(mockPosition.toJson());
        streamController.add(mockPosition.toJson());

        // Assert
        expect(await streamQueue.next, mockPosition);
        expect(await streamQueue.next, mockPosition);
        expect(await streamQueue.next, mockPosition);

        // Clean up
        await streamQueue.cancel();
        await streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should continue listening to the stream when exception is thrown ',
          () async {
        // Arrange
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test events
        streamController.add(mockPosition.toJson());
        streamController.addError(PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Permission denied',
            details: null));
        streamController.add(mockPosition.toJson());

        // Assert
        expect(await streamQueue.next, mockPosition);
        expect(
            streamQueue.next,
            throwsA(
              isA<PermissionDeniedException>().having(
                (e) => e.message,
                'message',
                'Permission denied',
              ),
            ));
        expect(await streamQueue.next, mockPosition);

        // Clean up
        await streamQueue.cancel();
        await streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a permission denied exception if permission is denied',
          () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Permission denied',
            details: null));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<PermissionDeniedException>().having(
                (e) => e.message,
                'message',
                'Permission denied',
              ),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a location service disabled exception if location service is disabled',
          () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
            code: 'LOCATION_SERVICES_DISABLED',
            message: 'Location services disabled',
            details: null));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<LocationServiceDisabledException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a already subscribed exception', () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
            code: 'PERMISSION_REQUEST_IN_PROGRESS',
            message: 'A permission request is already in progress',
            details: null));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<PermissionRequestInProgressException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a already subscribed exception', () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
            code: 'LOCATION_SUBSCRIPTION_ACTIVE',
            message: 'Already subscribed to receive a position stream',
            details: null));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<AlreadySubscribedException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a position update exception', () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
            code: 'LOCATION_UPDATE_FAILURE',
            message: 'A permission request is already in progress',
            details: null));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<PositionUpdateException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        final streamController = StreamController<Map<String, dynamic>>();
        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );
        const expectedArguments = LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        // Act
        final positionStream = GeolocatorAndroid().getPositionStream(
          locationSettings: LocationSettings(
            accuracy: expectedArguments.accuracy,
            timeLimit: const Duration(milliseconds: 5),
          ),
        );
        final streamQueue = StreamQueue(positionStream);

        streamController.add(mockPosition.toJson());

        await Future.delayed(const Duration(milliseconds: 5));

        // Assert
        expect(await streamQueue.next, mockPosition);
        expect(streamQueue.next, throwsA(isA<TimeoutException>()));
      });

      test('Should cleanup the previous stream on timeout exception', () async {
        // Arrange
        final streamController = StreamController<Map<String, dynamic>>();
        final retryController = StreamController<Map<String, dynamic>>();
        late Stream<Position> retryStream;

        EventChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_updates_android',
          stream: streamController.stream,
        );
        const locationSettings = LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(milliseconds: 5),
        );

        final geolocator = GeolocatorAndroid();

        // Act
        final positionStream = geolocator.getPositionStream(
          locationSettings: locationSettings,
        );

        final subscription = positionStream.listen((event) {});

        // Listen for position changes again on timeout
        subscription.onError((err) {
          EventChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_updates_android',
            stream: retryController.stream,
          );
          retryStream = geolocator.getPositionStream(
            locationSettings: locationSettings,
          );
        });

        await Future.delayed(const Duration(milliseconds: 5));

        final streamQueue = StreamQueue(retryStream);
        retryController.add(mockPosition.toJson());

        // Assert

        // If previous stream is not properly cleaned up this will have no elements
        expect(await streamQueue.next, mockPosition);
      });
    });

    group(
        // ignore: lines_longer_than_80_chars
        'getServiceStream: When requesting a stream of location service status updates',
        () {
      group('And requesting for location service status updates multiple times',
          () {
        test('Should return the same stream', () {
          final plugin = GeolocatorAndroid();
          final firstStream = plugin.getServiceStatusStream();
          final secondstream = plugin.getServiceStatusStream();

          expect(
            identical(firstStream, secondstream),
            true,
          );
        });
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a stream with location service updates if permissions are granted',
          () async {
        // Arrange
        final streamController = StreamController<int>.broadcast();
        EventChannelMock(
            channelName:
                'flutter.baseflow.com/geolocator_service_updates_android',
            stream: streamController.stream);

        // Act
        final locationServiceStream =
            GeolocatorAndroid().getServiceStatusStream();
        final streamQueue = StreamQueue(locationServiceStream);

        // Emit test events
        streamController.add(0); // disabled value in native enum
        streamController.add(1); // enabled value in native enum

        //Assert
        expect(await streamQueue.next, ServiceStatus.disabled);
        expect(await streamQueue.next, ServiceStatus.enabled);

        // Clean up
        await streamQueue.cancel();
        await streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive an exception if android activity is missing',
          () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName:
              'flutter.baseflow.com/geolocator_service_updates_android',
          stream: streamController.stream,
        );

        // Act
        final positionStream = GeolocatorAndroid().getServiceStatusStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
            code: 'ACTIVITY_MISSING',
            message: 'Activity missing',
            details: null));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<ActivityMissingException>().having(
                (e) => e.message,
                'message',
                'Activity missing',
              ),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });
    });

    group('openAppSettings: When opening the App settings', () {
      test('Should receive true if the page can be opened', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'openAppSettings',
          result: true,
        );

        // Act
        final hasOpenedAppSettings =
            await GeolocatorAndroid().openAppSettings();

        // Assert
        expect(
          hasOpenedAppSettings,
          true,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'openAppSettings',
          result: false,
        );

        // Act
        final hasOpenedAppSettings =
            await GeolocatorAndroid().openAppSettings();

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
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'openLocationSettings',
          result: true,
        );

        // Act
        final hasOpenedLocationSettings =
            await GeolocatorAndroid().openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          true,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'openLocationSettings',
          result: false,
        );

        // Act
        final hasOpenedLocationSettings =
            await GeolocatorAndroid().openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          false,
        );
      });
    });

    group('jsonSerialization: When serializing to json', () {
      test('Should produce valid map with all the settings when calling toJson',
          () async {
        // Arrange
        final settings = AndroidSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
            forceLocationManager: false,
            intervalDuration: const Duration(seconds: 1),
            timeLimit: const Duration(seconds: 1),
            useMSLAltitude: false,
            foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationText: 'text',
                notificationTitle: 'title',
                enableWakeLock: false,
                enableWifiLock: false,
                notificationIcon:
                    AndroidResource(name: 'name', defType: 'defType')));

        // Act
        final jsonMap = settings.toJson();

        // Assert
        expect(
          jsonMap['accuracy'],
          settings.accuracy.index,
        );
        expect(
          jsonMap['distanceFilter'],
          settings.distanceFilter,
        );
        expect(
          jsonMap['forceLocationManager'],
          settings.forceLocationManager,
        );
        expect(
          jsonMap['timeInterval'],
          settings.intervalDuration!.inMilliseconds,
        );
        expect(
          jsonMap['useMSLAltitude'],
          settings.useMSLAltitude,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          method: 'openLocationSettings',
          result: false,
        );

        // Act
        final hasOpenedLocationSettings =
            await GeolocatorAndroid().openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          false,
        );
      });
    });
  });
}
