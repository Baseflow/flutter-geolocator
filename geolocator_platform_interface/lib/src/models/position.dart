import 'package:meta/meta.dart';

/// Contains detailed location information.
@immutable
class Position {
  /// Constructs an instance with the given values for testing. [Position]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  const Position({
    required this.longitude,
    required this.latitude,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.altitudeAccuracy,
    required this.heading,
    required this.headingAccuracy,
    required this.speed,
    required this.speedAccuracy,
    this.floor,
    this.isMocked = false,
  });

  /// The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  final double longitude;

  /// The time at which this position was determined.
  final DateTime timestamp;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned
  /// value is 0.0.
  final double altitude;

  /// The estimated vertical accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  final double altitudeAccuracy;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  final double accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is
  /// 0.0.
  final double heading;

  /// The estimated heading accuracy of the position in degrees.
  ///
  /// The heading accuracy is not available on all devices. In these cases the
  /// value is 0.0.
  final double headingAccuracy;

  /// The floor specifies the floor of the building on which the device is
  /// located.
  ///
  /// The floor property is only available on iOS and only when the information
  /// is available. In all other cases this value will be null.
  final int? floor;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  ///
  /// The speed is not available on all devices. In these cases the value is
  /// 0.0.
  final double speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  final double speedAccuracy;

  /// Will be true on Android (starting from API lvl 18) when the location came
  /// from the mocked provider.
  ///
  /// Will be true on iOS 15 and higher when flag isSimulatedBySoftware is true (otherwise false).
  ///
  /// When not available the default value is false.
  final bool isMocked;

  @override
  bool operator ==(Object other) {
    var areEqual = other is Position &&
        other.accuracy == accuracy &&
        other.altitude == altitude &&
        other.altitudeAccuracy == altitudeAccuracy &&
        other.heading == heading &&
        other.headingAccuracy == headingAccuracy &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.floor == floor &&
        other.speed == speed &&
        other.speedAccuracy == speedAccuracy &&
        other.timestamp == timestamp &&
        other.isMocked == isMocked;

    return areEqual;
  }

  @override
  int get hashCode =>
      accuracy.hashCode ^
      altitude.hashCode ^
      altitudeAccuracy.hashCode ^
      heading.hashCode ^
      headingAccuracy.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      floor.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      timestamp.hashCode ^
      isMocked.hashCode;

  @override
  String toString() {
    return 'Latitude: $latitude, Longitude: $longitude';
  }

  /// Converts the supplied [Map] to an instance of the [Position] class.
  static Position fromMap(dynamic message) {
    final Map<dynamic, dynamic> positionMap = message;

    if (!positionMap.containsKey('latitude')) {
      throw ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `latitude`.');
    }

    if (!positionMap.containsKey('longitude')) {
      throw ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `longitude`.');
    }

    // Assume that the timestamp is null if the map does not contain one
    dynamic timestampInMap = positionMap['timestamp'];
    final timestamp = timestampInMap == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(
            timestampInMap.toInt(),
            isUtc: true,
          );

    return Position(
      latitude: positionMap['latitude'],
      longitude: positionMap['longitude'],
      timestamp: timestamp,
      altitude: _toDouble(positionMap['altitude']),
      altitudeAccuracy: _toDouble(positionMap['altitude_accuracy']),
      accuracy: _toDouble(positionMap['accuracy']),
      heading: _toDouble(positionMap['heading']),
      headingAccuracy: _toDouble(positionMap['heading_accuracy']),
      floor: positionMap['floor'],
      speed: _toDouble(positionMap['speed']),
      speedAccuracy: _toDouble(positionMap['speed_accuracy']),
      isMocked: positionMap['is_mocked'] ?? false,
    );
  }

  /// Converts the [Position] instance into a [Map] instance that can be
  /// serialized to JSON.
  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'accuracy': accuracy,
        'altitude': altitude,
        'altitude_accuracy': altitudeAccuracy,
        'floor': floor,
        'heading': heading,
        'heading_accuracy': headingAccuracy,
        'speed': speed,
        'speed_accuracy': speedAccuracy,
        'is_mocked': isMocked,
      };

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    return value.toDouble();
  }
}
