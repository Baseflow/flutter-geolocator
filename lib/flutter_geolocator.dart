import 'dart:async';

import 'package:flutter/services.dart';
import 'models/position.dart';

class FlutterGeolocator {
  static const MethodChannel _methodChannel =
      const MethodChannel('flutter.baseflow.com/geolocator/methods');

  static const EventChannel _eventChannel =
      const EventChannel('flutter.baseflow.com/geolocator/events');

  Stream<Position> _onPositionChanged;
  
  static Future<Position> get getPosition  => _methodChannel
      .invokeMethod('getPosition')
      .then((result) => Position.fromMap(result));

  Stream<Position> get onPositionChanged {
    if(_onPositionChanged == null) {
      _onPositionChanged = _eventChannel
          .receiveBroadcastStream()
          .map<Position>(
              (element) => Position.fromMap(element.cast<String, double>()));
    }

    return _onPositionChanged;
  }
}
