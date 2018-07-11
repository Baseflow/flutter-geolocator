import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/location_options.dart';
import 'package:geolocator/utils/codec.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/position.dart';
import 'package:test/test.dart';

void main() {
  MockMethodChannel _methodChannel;
  MockEventChannel _eventChannel;
  Geolocator _geolocator;

  const Map<String, double> _mockPosition = const <String, double>{
    'latitude': 52.561270,
    'longitude': 5.639382,
    'altitude': 3000.0,
    'accuracy': 0.0,
    'heading': 0.0,
    'speed': 0.0,
    'speed_accuracy': 0.0
  };

  const List<Map<String, double>> _mockPositions = const [
    <String, double>{
      'latitude': 52.561270,
      'longitude': 5.639382,
      'altitude': 3000.0,
      'accuracy': 0.0,
      'heading': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0
    },
    <String, double>{
      'latitude': 52.560919,
      'longitude': 5.639771,
      'altitude': 3000.0,
      'accuracy': 0.0,
      'heading': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0
    },
    <String, double>{
      'latitude': 52.562143,
      'longitude': 5.641147,
      'altitude': 3000.0,
      'accuracy': 0.0,
      'heading': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0
    },
    <String, double>{
      'latitude': 52.562454,
      'longitude': 5.640372,
      'altitude': 3000.0,
      'accuracy': 0.0,
      'heading': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0
    },
    <String, double>{
      'latitude': 52.561242,
      'longitude': 5.639010,
      'altitude': 3000.0,
      'accuracy': 0.0,
      'heading': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0
    }
  ];

  setUp(() {
    _methodChannel = new MockMethodChannel();
    _eventChannel = new MockEventChannel();
    _geolocator = new Geolocator.private(_methodChannel, _eventChannel);
  });

  test('Retrieve the current position', () async {
    var codedOptions = Codec.encodeLocationOptions(LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0));
    when(_methodChannel.invokeMethod(
            'getPosition', codedOptions))
        .thenAnswer((_) async => _mockPosition);

    Position position = await _geolocator.getPosition(LocationAccuracy.best);

    expect(position.latitude, _mockPosition['latitude']);
    expect(position.longitude, _mockPosition['longitude']);
    expect(position.altitude, _mockPosition['altitude']);
    expect(position.accuracy, _mockPosition['accuracy']);
    expect(position.heading, _mockPosition['heading']);
    expect(position.speed, _mockPosition['speed']);
    expect(position.speedAccuracy, _mockPosition['speed_accuracy']);
  });

  group('Postion state changes', () {
    StreamController<Map<String, double>> _controller;
    var _codedOptions = Codec.encodeLocationOptions(
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0));

    setUp(() {
      
      _controller = new StreamController<Map<String, double>>();
      when(_eventChannel.receiveBroadcastStream(_codedOptions))
          .thenReturn(_controller.stream);
    });

    tearDown(() {
      _controller.close();
    });

    test('The receiveBroadcastStream should only be called once', () {
      _geolocator.getPositionStream();
      _geolocator.getPositionStream();
      _geolocator.getPositionStream();

      verify(_eventChannel.receiveBroadcastStream(_codedOptions))
          .called(1);
    });

    test('Receive position changes', () async {
      final StreamQueue<Position> queue = new StreamQueue<Position>(
          _geolocator.getPositionStream(LocationOptions(
              accuracy: LocationAccuracy.best, distanceFilter: 0)));

      _controller.add(_mockPositions[0]);
      expect((await queue.next).toMap(), _mockPositions[0]);

      _controller.add(_mockPositions[1]);
      expect((await queue.next).toMap(), _mockPositions[1]);

      _controller.add(_mockPositions[2]);
      expect((await queue.next).toMap(), _mockPositions[2]);

      _controller.add(_mockPositions[3]);
      expect((await queue.next).toMap(), _mockPositions[3]);

      _controller.add(_mockPositions[4]);
      expect((await queue.next).toMap(), _mockPositions[4]);
    });
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}

class MockEventChannel extends Mock implements EventChannel {}
