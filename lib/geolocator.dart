library geolocator;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'models/location_accuracy.dart';
part 'models/location_options.dart';
part 'models/placemark.dart';
part 'models/position.dart';
part 'utils/codec.dart';

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

  /// Returns the current position taking the supplied [desiredAccuracy] into account.
  ///
  /// When the [desiredAccuracy] is not supplied, it defaults to best.
  Future<Position> getCurrentPosition(
      [LocationAccuracy desiredAccuracy = LocationAccuracy.best]) async {
    var locationOptions =
        LocationOptions(accuracy: desiredAccuracy, distanceFilter: 0);
    var position = await _methodChannel.invokeMethod(
        'getCurrentPosition', Codec.encodeLocationOptions(locationOptions));
    return Position._fromMap(position);
  }

  /// Returns the last known position stored on the users device. 
  /// 
  /// On Android we look for the location provider matching best with the
  /// supplied [desiredAccuracy]. On iOS this parameter is ignored.
  /// When no position is available, null is returned.
  Future<Position> getLastKnownPosition(
    [LocationAccuracy desiredAccuracy = LocationAccuracy.best]) async {
    var locationOptions =
        LocationOptions(accuracy: desiredAccuracy, distanceFilter: 0);
    var position = await _methodChannel.invokeMethod(
        'getCurrentPosition', Codec.encodeLocationOptions(locationOptions));
    return Position?._fromMap(position);
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
  /// You can customize the behaviour of the location updates by supplying an
  /// instance [LocationOptions] class. When you don't supply any specific
  /// options, default values will be used for each setting.
  Stream<Position> getPositionStream(
      [LocationOptions locationOptions = const LocationOptions()]) {
    if (_onPositionChanged == null) {
      _onPositionChanged = _eventChannel
          .receiveBroadcastStream(Codec.encodeLocationOptions(locationOptions))
          .map<Position>(
              (element) => Position._fromMap(element.cast<String, double>()));
    }

    return _onPositionChanged;
  }

  /// Returns a list of [Placemark] instances found for the supplied address.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied address could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be returned.
  Future<List<Placemark>> placemarkFromAddress(String address) async {
    var placemarks = await _methodChannel.invokeMethod('placemarkFromAddress', address);
    return Placemark._fromMaps(placemarks);
  }

  /// Returns a list of [Placemark] instances found for the supplied coordinates.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied coordinates could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be returned.
  Future<List<Placemark>> placemarkFromCoordinates(
      double latitude, double longitude) async {
    var placemarks = await _methodChannel.invokeMethod('placemarkFromCoordinates',
        <String, double>{"latitude": latitude, "longitude": longitude});
    return Placemark._fromMaps(placemarks);
  }

  /// Returns the distance between the supplied coordinates in meters.
  Future<double> distanceBetween(double startLatitude, double startLongitude,
          double endLatitude, double endLongitude) =>
      _methodChannel.invokeMethod('distanceBetween', <String, double>{
        "startLatitude": startLatitude,
        "startLongitude": startLongitude,
        "endLatitude": endLatitude,
        "endLongitude": endLongitude
      }).then<double>((dynamic result) => result);
}
