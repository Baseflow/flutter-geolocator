import 'dart:async';
import 'dart:js_interop';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:web/web.dart' as web;

import 'geolocation_manager.dart';
import 'utils.dart';

/// Implementation of the [GeolocationManager] interface based on the
/// [html.Geolocation] class.
class HtmlGeolocationManager implements GeolocationManager {
  final web.Geolocation _geolocation;

  /// Creates a new instance of the [HtmlGeolocationManager] class.
  HtmlGeolocationManager() : _geolocation = web.window.navigator.geolocation;

  @override
  Future<Position> getCurrentPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
    Duration? maximumAge,
  }) async {
    Completer<Position> completer = Completer();
    try {
      _geolocation.getCurrentPosition(
        (web.GeolocationPosition position) {
          completer.complete(toPosition(position));
        }.toJS,
        (web.GeolocationPositionError error) {
          completer.completeError(convertPositionError(error));
        }.toJS,
        web.PositionOptions(
          enableHighAccuracy: enableHighAccuracy ?? false,
          timeout:
              timeout?.inMicroseconds ?? const Duration(days: 1).inMilliseconds,
          maximumAge: maximumAge?.inMilliseconds ?? 0,
        ),
      );
    } catch (e) {
      completer.completeError(const PositionUpdateException(
          "Something went wrong while getting current position"));
    }

    return completer.future;
  }

  @override
  Stream<Position> watchPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
    Duration? maximumAge,
  }) {
    int? watchId;
    StreamController<Position> controller = StreamController<Position>(
        sync: true,
        onCancel: () {
          assert(watchId != null);
          _geolocation.clearWatch(watchId!);
        });

    controller.onListen = () {
      assert(watchId == null);
      watchId = _geolocation.watchPosition(
        (web.GeolocationPosition position) {
          controller.add(toPosition(position));
        }.toJS,
        (web.GeolocationPositionError error) {
          controller.addError(convertPositionError(error));
        }.toJS,
        web.PositionOptions(
          enableHighAccuracy: enableHighAccuracy ?? false,
          timeout:
              timeout?.inMicroseconds ?? const Duration(days: 1).inMilliseconds,
          maximumAge: maximumAge?.inMilliseconds ?? 0,
        ),
      );
    };

    return controller.stream;
  }
}
