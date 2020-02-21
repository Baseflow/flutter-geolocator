part of geolocator;

/// Contains detailed location information.
class Position extends Equatable {
  /// Constructs an instance with the given values for testing. [Position]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  Position({
    this.longitude,
    this.latitude,
    this.timestamp,
    this.mocked,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  Position._({
    this.longitude,
    this.latitude,
    this.timestamp,
    this.mocked,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  @override
  List<Object> get props => [
        longitude,
        latitude,
        timestamp,
        mocked,
        accuracy,
        altitude,
        heading,
        speed,
        speedAccuracy,
      ];

  /// The latitude of this position in degrees normalized to the interval -90.0 to +90.0 (both inclusive).
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180 (exclusive) to +180 (inclusive).
  final double longitude;

  /// The time at which this position was determined.
  final DateTime timestamp;

  ///Indicate if position was created from a mock provider.
  ///
  /// The mock information is not available on all devices. In these cases the returned value is false.
  final bool mocked;

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
  bool operator ==(o) {
    var areEqual = o is Position &&
        o.accuracy == accuracy &&
        o.altitude == altitude &&
        o.heading == heading &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.speed == speed &&
        o.speedAccuracy == speedAccuracy &&
        o.timestamp == timestamp;

    return areEqual;
  }

  @override
  int get hashCode =>
      accuracy.hashCode ^
      altitude.hashCode ^
      heading.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      timestamp.hashCode;

  @override
  String toString() {
    return 'Lat: $latitude, Long: $longitude';
  }

  /// Converts a collection of [Map] objects into a collection of [Position] objects.
  static List<Position> fromMaps(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final List<Position> list = message.map<Position>(fromMap).toList();
    return list;
  }

  /// Converts the supplied [Map] to an instance of the [Position] class.
  static Position fromMap(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final Map<dynamic, dynamic> positionMap = message;

    if (!positionMap.containsKey('latitude')) {
      throw ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `latitude`.');
    }

    if (!positionMap.containsKey('longitude')) {
      throw ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `longitude`.');
    }

    final DateTime timestamp = positionMap['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(positionMap['timestamp'].toInt(),
            isUtc: true)
        : null;

    return Position._(
        latitude: positionMap['latitude'],
        longitude: positionMap['longitude'],
        timestamp: timestamp,
        mocked: positionMap['mocked'] ?? false,
        altitude: positionMap['altitude'] ?? 0.0,
        accuracy: positionMap['accuracy'] ?? 0.0,
        heading: positionMap['heading'] ?? 0.0,
        speed: positionMap['speed'] ?? 0.0,
        speedAccuracy: positionMap['speed_accuracy'] ?? 0.0);
  }

  /// Converts the [Position] instance into a [Map] instance that can be serialized to JSON.
  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'timestamp': timestamp?.millisecondsSinceEpoch,
        'mocked': mocked,
        'accuracy': accuracy,
        'altitude': altitude,
        'heading': heading,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
      };
}
