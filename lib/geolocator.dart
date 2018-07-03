import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:meta/meta.dart';

import 'models/position.dart';

/// Provides easy access to the platform specific location services (CLLocationManager on iOS and FusedLocationProviderClient on Android)
class Geolocator {
  factory Geolocator() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('flutter.baseflow.com/geolocator/methods');
      final EventChannel eventChannel =
          const EventChannel('flutter.baseflow.com/geolocator/events');
      _instance = new Geolocator.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  @visibleForTesting
  Geolocator.private(this._methodChannel, this._eventChannel);

  static Geolocator _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  Stream<Position> _onPositionChanged;

  /// Returns the current location taking the supplied [desiredAccuracy] into account.
  /// 
  /// When the [desiredAccuracy] is not supplied, it defaults to best.
  Future<Position> getPosition([LocationAccuracy desiredAccuracy = LocationAccuracy.Best]) async {
      var position = await _methodChannel.invokeMethod('getPosition', desiredAccuracy.index);
      return Position.fromMap(position);
  }

  /// Fires whenever the location changes outside the bounds of the [desiredAccuracy].
  ///
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application
  /// is killed.
  ///
  /// ```
  /// StreamSubscription<Position> positionStream = new Geolocator().GetPostionStream().listen(
  ///   (Position position) => {
  ///     // Handle position changes
  ///   });
  ///
  /// // When no longer needed cancel the subscription
  /// positionStream.cancel();
  /// ```
  /// 
  /// When the [desiredAccuracy] is not supplied, it defaults to best.
  Stream<Position> getPositionStream([LocationAccuracy desiredAccuracy = LocationAccuracy.Best]) {
    if (_onPositionChanged == null) {
      _onPositionChanged = _eventChannel.receiveBroadcastStream(desiredAccuracy.index).map<Position>(
          (element) => Position.fromMap(element.cast<String, double>()));
    }

    return _onPositionChanged;
  }
}
