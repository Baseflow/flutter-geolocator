import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'models/position.dart';

/// Provides easy access to the platform specific location services (CLLocationManager on iOS and FusedLocationProviderClient on Android)
class FlutterGeolocator {
  factory FlutterGeolocator() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('flutter.baseflow.com/geolocator/methods');
      final EventChannel eventChannel =
          const EventChannel('flutter.baseflow.com/geolocator/events');
      _instance = new FlutterGeolocator.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  @visibleForTesting
  FlutterGeolocator.private(this._methodChannel, this._eventChannel);

  static FlutterGeolocator _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  Stream<Position> _onPositionChanged;
  
  /// Returns the current location.
  Future<Position> get getPosition  => _methodChannel
      .invokeMethod('getPosition')
      .then((result) => Position.fromMap(result));

  /// Fires whenever the location changes.
  /// 
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application 
  /// is killed. 
  /// 
  /// ```
  /// StreamSubscription<Position> positionStream = new FlutterGeolocator().onPositionChanged.listen(
  ///   (Position position) => {
  ///     // Handle position changes
  ///   });
  /// 
  /// // When no longer needed cancel the subscription
  /// positionStream.cancel();
  /// ```
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
