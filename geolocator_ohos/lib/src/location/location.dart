part of '../geolocator_ohos.dart';

class LocationImplements extends GeolocatorPlatform {
  /// The event channel used to receive [Position] updates from the native
  /// platform.
  static const _eventChannel =
      EventChannel('flutter.baseflow.com/geolocator_updates_ohos');

  /// The event channel used to receive [LocationServiceStatus] updates from the
  /// native platform.
  static const _serviceStatusEventChannel =
      EventChannel('flutter.baseflow.com/geolocator_service_updates_ohos');

  /// On Android devices you can set [forcedLocationManager]
  /// to true to force the plugin to use the [LocationManager] to determine the
  /// position instead of the [FusedLocationProviderClient]. On iOS this is
  /// ignored.
  bool forcedLocationManager = false;

  Stream<Position>? _positionStream;
  Stream<ServiceStatus>? _serviceStatusStream;

  @override
  Future<LocationPermission> checkPermission(
      {List<String> permissions =
          GeolocatorOhos.approximatelyPermission}) async {
    try {
      // ignore: omit_local_variable_types
      final int permission = await GeolocatorOhos._methodChannel
          .invokeMethod('checkPermission', permissions);

      return permission.toLocationPermission();
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Future<LocationPermission> requestPermission(
      {List<String> permissions =
          GeolocatorOhos.approximatelyPermission}) async {
    try {
      // ignore: omit_local_variable_types
      final int permission = await GeolocatorOhos._methodChannel
          .invokeMethod('requestPermission', permissions);

      return permission.toLocationPermission();
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async => GeolocatorOhos._methodChannel
      .invokeMethod<bool>('isLocationServiceEnabled')
      .then((value) => value ?? false);

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async {
    try {
      final parameters = <String, dynamic>{
        'forceLocationManager': forceLocationManager,
      };

      final positionString = await GeolocatorOhos._methodChannel
          .invokeMethod('getLastKnownPosition', parameters);

      return positionString != null
          ? PositionOhos.fromString(positionString)
          : null;
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    final int accuracy =
        await GeolocatorOhos._methodChannel.invokeMethod('getLocationAccuracy');
    return LocationAccuracyStatus.values[accuracy];
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
    String? requestId,
  }) async {
    assert(
      locationSettings == null ||
          locationSettings is CurrentLocationSettingsOhos,
      'locationSettings should be CurrentLocationSettingsOhos',
    );

    try {
      final Duration? timeLimit = locationSettings?.timeLimit;

      Future<dynamic> positionFuture =
          GeolocatorOhos._methodChannel.invokeMethod(
        'getCurrentPosition',
        locationSettings?.toString(),
      );

      if (timeLimit != null) {
        positionFuture = positionFuture.timeout(timeLimit);
      }

      return PositionOhos.fromString(await positionFuture);
    } on TimeoutException {
      final parameters = <String, dynamic>{
        'requestId': requestId,
      };
      GeolocatorOhos._methodChannel.invokeMethod(
        'cancelGetCurrentPosition',
        parameters,
      );
      rethrow;
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    if (_serviceStatusStream != null) {
      return _serviceStatusStream!;
    }
    var serviceStatusStream =
        _serviceStatusEventChannel.receiveBroadcastStream();

    _serviceStatusStream = serviceStatusStream
        .map((dynamic element) => ServiceStatus.values[element as int])
        .handleError((error) {
      _serviceStatusStream = null;
      if (error is PlatformException) {
        error = _handlePlatformException(error);
      }
      throw error;
    });

    return _serviceStatusStream!;
  }

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    if (_positionStream != null) {
      return _positionStream!;
    }

    assert(
      locationSettings == null || locationSettings is LocationSettingsOhos,
      'locationSettings should be a LocationSettingsOhos',
    );

    var originalStream = _eventChannel.receiveBroadcastStream(
      locationSettings?.toString(),
    );

    var positionStream = _wrapStream(originalStream);

    var timeLimit = locationSettings?.timeLimit;

    if (timeLimit != null) {
      positionStream = positionStream.timeout(
        timeLimit,
        onTimeout: (s) {
          _positionStream = null;
          s.addError(TimeoutException(
            'Time limit reached while waiting for position update.',
            timeLimit,
          ));
          s.close();
        },
      );
    }

    _positionStream = positionStream
        .map<Position>((dynamic element) => PositionOhos.fromString(element))
        .handleError(
      (error) {
        if (error is PlatformException) {
          error = _handlePlatformException(error);
        }
        throw error;
      },
    );
    return _positionStream!;
  }

  Stream<dynamic> _wrapStream(Stream<dynamic> incoming) {
    return incoming.asBroadcastStream(onCancel: (subscription) {
      subscription.cancel();
      _positionStream = null;
    });
  }

  @override
  Future<bool> openAppSettings() async => GeolocatorOhos._methodChannel
      .invokeMethod<bool>('openAppSettings')
      .then((value) => value ?? false);

  @override
  Future<bool> openLocationSettings() async => GeolocatorOhos._methodChannel
      .invokeMethod<bool>('openLocationSettings')
      .then((value) => value ?? false);

  Exception _handlePlatformException(PlatformException exception) {
    switch (exception.code) {
      case 'ACTIVITY_MISSING':
        return ActivityMissingException(exception.message);
      case 'LOCATION_SERVICES_DISABLED':
        return const LocationServiceDisabledException();
      case 'LOCATION_SUBSCRIPTION_ACTIVE':
        return const AlreadySubscribedException();
      case 'PERMISSION_DEFINITIONS_NOT_FOUND':
        return PermissionDefinitionsNotFoundException(exception.message);
      case 'PERMISSION_DENIED':
        return PermissionDeniedException(exception.message);
      case 'PERMISSION_REQUEST_IN_PROGRESS':
        return PermissionRequestInProgressException(exception.message);
      case 'LOCATION_UPDATE_FAILURE':
        return PositionUpdateException(exception.message);
      default:
        return exception;
    }
  }
}
