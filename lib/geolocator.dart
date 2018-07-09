import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/placemark.dart';
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
  Future<Position> getPosition(
      [LocationAccuracy desiredAccuracy = LocationAccuracy.best]) async {
    var position =
        await _methodChannel.invokeMethod('getPosition', desiredAccuracy.index);
    return Position.fromMap(position);
  }

  /// Returns a list of [Placemark] instances found for the supplied address.
  /// 
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied address could not be 
  /// resolved into a single [Placemark], multiple [Placemark] instances may be returned.
  Future<List<Placemark>> toPlacemark(String address) async {
    var placemarks = await _methodChannel.invokeMethod('toPlacemark', address);
    return Placemark.fromMaps(placemarks);
  }

  /// Returns a list of [Placemark] instances found for the supplied address.
  /// 
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied address could not be 
  /// resolved into a single [Placemark], multiple [Placemark] instances may be returned.
  Future<List<Placemark>> fromPlacemark(double latitude, double longitude) async {
    var placemarks = await _methodChannel.invokeMethod('fromPlacemark', <String, double> {"latitude": latitude, "longitude": longitude});
    return Placemark.fromMaps(placemarks);
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
  Stream<Position> getPositionStream(
      [LocationAccuracy desiredAccuracy = LocationAccuracy.best]) {
    if (_onPositionChanged == null) {
      _onPositionChanged = _eventChannel
          .receiveBroadcastStream(desiredAccuracy.index)
          .map<Position>(
              (element) => Position.fromMap(element.cast<String, double>()));
    }

    return _onPositionChanged;
  }
}
