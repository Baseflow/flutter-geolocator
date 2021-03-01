import 'dart:html' as html;

import 'package:geolocator_platform_interface/src/models/position.dart';

import 'geolocation_manager.dart';
import 'utils.dart';

class HtmlGeolocationManager implements GeolocationManager {
  final html.Geolocation _geolocation;

  HtmlGeolocationManager(this._geolocation) : assert(_geolocation != null);

  @override
  Future<Position> getCurrentPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  }) async {
    final geoPosition = await _geolocation.getCurrentPosition(
      enableHighAccuracy: enableHighAccuracy,
      timeout: timeout,
    );

    return toPosition(geoPosition);
  }

  @override
  Stream<Position> watchPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  }) {
    return _geolocation
        .watchPosition(
          enableHighAccuracy: enableHighAccuracy,
          timeout: timeout,
        )
        .map((geoPosition) => toPosition(geoPosition));
  }
}
