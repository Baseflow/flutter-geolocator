import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_geolocator/flutter_geolocator.dart';
import 'package:flutter_geolocator/models/position.dart';
import 'package:test/test.dart';

void main() {
  MockMethodChannel _methodChannel;
  MockEventChannel _eventChannel;
  FlutterGeolocator _geolocator;

  const Map<String, double> _mockPosition = const <String, double> {
    'latitude' : 52.561270, 
    'longitude' : 5.639382,
    'altitude' : 3000.0,
    'accuracy' : 0.0,
    'heading' : 0.0,
    'speed' : 0.0,
    'speed_accuracy' : 0.0
  };

  setUp(() {
    _methodChannel = new MockMethodChannel();
    _eventChannel = new MockEventChannel();
    _geolocator = new FlutterGeolocator.private(_methodChannel, _eventChannel);
  });

  test('position', () async {
    when(_methodChannel.invokeMethod('getPosition'))
      .thenReturn(new Future<Map<String, double>>.value(_mockPosition));
    
    Position position = await _geolocator.getPosition;

    expect(position.latitude, _mockPosition['latitude']);
    expect(position.longitude, _mockPosition['longitude']);
    expect(position.altitude, _mockPosition['altitude']);
    expect(position.accuracy, _mockPosition['accuracy']);
    expect(position.heading, _mockPosition['heading']);
    expect(position.speed, _mockPosition['speed']);
    expect(position.speedAccuracy, _mockPosition['speed_accuracy']);
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
class MockEventChannel extends Mock implements EventChannel {}
