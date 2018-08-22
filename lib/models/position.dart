part of geolocator;

/// Contains detail location information.
class Position {
  Position._({
    this.longitude,
    this.latitude,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  /// The latitude of this position in degrees normalized to the interval -90.0 to +90.0 (both inclusive).
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180 (exclusive) to +180 (inclusive).
  final double longitude;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned value is 0.0.
  final double altitude;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is 0.0.
  final double accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is 0.0.
  final double heading;

  /// The speed at which the devices is traveling in meters per second over ground.
  ///
  /// The speed is not available on all devices. In these cases the value is 0.0.
  final double speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the value is 0.0.
  final double speedAccuracy;

  @override
  String toString() {
    return 'Lat: $latitude, Long: $longitude';
  }

  /// Converts a collection of [Map] objects into a collection of [Position] objects.
  static List<Position> _fromMaps(dynamic message) {
    if (message == null) {
      throw new ArgumentError("The parameter 'message' should not be null.");
    }

    List<Position> list = message.map<Position>(_fromMap).toList();
    return list;
  }

  /// Converts the supplied [Map] to an instance of the [Position] class.
  static Position _fromMap(dynamic message) {
    if (message == null) {
      throw new ArgumentError("The parameter 'message' should not be null.");
    }

    final Map<dynamic, dynamic> positionMap = message;

    if (!positionMap.containsKey('latitude'))
      throw new ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `latitude`.');

    if (!positionMap.containsKey('longitude'))
      throw new ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `longitude`.');

    return new Position._(
        latitude: positionMap['latitude'],
        longitude: positionMap['longitude'],
        altitude: positionMap['altitude'] ?? 0.0,
        accuracy: positionMap['accuracy'] ?? 0.0,
        heading: positionMap['heading'] ?? 0.0,
        speed: positionMap['speed'] ?? 0.0,
        speedAccuracy: positionMap['speed_accuracy'] ?? 0.0);
  }

  @visibleForTesting
  Map<String, double> toMap() {
    return <String, double>{
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'heading': heading,
      'speed': speed,
      'speed_accuracy': speedAccuracy
    };
  }
}
