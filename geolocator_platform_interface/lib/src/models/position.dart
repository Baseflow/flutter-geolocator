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
    this.verticalSpeed = 0.0,
    this.verticalSpeedAccuracy = 0.0,
    this.hasAccuracy = false,
    this.hasAltitude = false,
    this.hasAltitudeAccuracy = false,
    this.hasHeading = false,
    this.hasHeadingAccuracy = false,
    this.hasSpeed = false,
    this.hasSpeedAccuracy = false,
    this.hasVerticalSpeed = false,
    this.hasVerticalSpeedAccuracy = false,
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

  /// The course over ground (direction of travel) in degrees.
  ///
  /// This reports the direction in which the device is *moving* across the
  /// ground, in degrees clockwise relative to true north (0.0 to 360.0). It is
  /// derived from the platform's GPS-based value: `Location.getBearing()` on
  /// Android and `CLLocation.course` on iOS.
  ///
  /// This is distinct from compass heading: it does *not* report the direction
  /// the device is physically pointing (the magnetometer/compass reading). A
  /// stationary device has no meaningful course over ground.
  ///
  /// The field is named `heading` for backward compatibility; despite the name
  /// it carries the course-over-ground value described above.
  ///
  /// The course is not available on all devices, and may be unavailable while
  /// the device is not moving. In these cases the value is 0.0.
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

  /// The vertical speed at which the device is traveling in meters per second.
  ///
  /// A positive value indicates ascending motion and a negative value indicates
  /// descending motion.
  ///
  /// The vertical speed is not available on all devices. In these cases the
  /// value is 0.0.
  final double verticalSpeed;

  /// The estimated vertical speed accuracy of this position, in meters per second.
  ///
  /// The verticalSpeedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  final double verticalSpeedAccuracy;

  /// Will be true on Android (starting from API lvl 18) when the location came
  /// from the mocked provider.
  ///
  /// Will be true on iOS 15 and higher when flag isSimulatedBySoftware is true (otherwise false).
  ///
  /// When not available the default value is false.
  final bool isMocked;

  /// Whether the platform actually reported [accuracy].
  ///
  /// When this is `false`, [accuracy] carries no measurement: the platform
  /// could not determine it and `0.0` is a placeholder, not zero metres of
  /// error. Filtering on `accuracy` without checking this treats an unmeasured
  /// position as a perfectly accurate one.
  ///
  /// On Android this mirrors `Location.hasAccuracy()`.
  final bool hasAccuracy;

  /// Whether the platform actually reported [altitude].
  ///
  /// When `false`, [altitude] is `0.0` as a placeholder. Mirrors
  /// `Location.hasAltitude()` on Android.
  final bool hasAltitude;

  /// Whether the platform actually reported [altitudeAccuracy].
  ///
  /// When `false`, [altitudeAccuracy] is `0.0` as a placeholder. Mirrors
  /// `Location.hasVerticalAccuracy()` on Android (API 26+).
  final bool hasAltitudeAccuracy;

  /// Whether the platform actually reported [heading].
  ///
  /// When `false`, [heading] is `0.0` as a placeholder — which is also a valid
  /// course of due north, so the two are otherwise indistinguishable. Mirrors
  /// `Location.hasBearing()` on Android.
  final bool hasHeading;

  /// Whether the platform actually reported [headingAccuracy].
  ///
  /// When `false`, [headingAccuracy] is `0.0` as a placeholder. Mirrors
  /// `Location.hasBearingAccuracy()` on Android (API 26+).
  final bool hasHeadingAccuracy;

  /// Whether the platform actually reported [speed].
  ///
  /// When `false`, [speed] is `0.0` as a placeholder, which is also a valid
  /// stationary reading. Mirrors `Location.hasSpeed()` on Android.
  final bool hasSpeed;

  /// Whether the platform actually reported [speedAccuracy].
  ///
  /// When `false`, [speedAccuracy] is `0.0` as a placeholder. Mirrors
  /// `Location.hasSpeedAccuracy()` on Android (API 26+).
  final bool hasSpeedAccuracy;

  /// Whether the platform actually reported [verticalSpeed].
  ///
  /// When `false`, [verticalSpeed] is `0.0` as a placeholder, which is also a valid
  /// level-flight reading.
  final bool hasVerticalSpeed;

  /// Whether the platform actually reported [verticalSpeedAccuracy].
  ///
  /// When `false`, [verticalSpeedAccuracy] is `0.0` as a placeholder.
  final bool hasVerticalSpeedAccuracy;

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
        other.isMocked == isMocked &&
        other.verticalSpeed == verticalSpeed &&
        other.verticalSpeedAccuracy == verticalSpeedAccuracy &&
        other.hasAccuracy == hasAccuracy &&
        other.hasAltitude == hasAltitude &&
        other.hasAltitudeAccuracy == hasAltitudeAccuracy &&
        other.hasHeading == hasHeading &&
        other.hasHeadingAccuracy == hasHeadingAccuracy &&
        other.hasSpeed == hasSpeed &&
        other.hasSpeedAccuracy == hasSpeedAccuracy &&
        other.hasVerticalSpeed == hasVerticalSpeed &&
        other.hasVerticalSpeedAccuracy == hasVerticalSpeedAccuracy;

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
      isMocked.hashCode ^
      verticalSpeed.hashCode ^
      verticalSpeedAccuracy.hashCode ^
      hasAccuracy.hashCode ^
      hasAltitude.hashCode ^
      hasAltitudeAccuracy.hashCode ^
      hasHeading.hashCode ^
      hasHeadingAccuracy.hashCode ^
      hasSpeed.hashCode ^
      hasSpeedAccuracy.hashCode ^
      hasVerticalSpeed.hashCode ^
      hasVerticalSpeedAccuracy.hashCode;

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
      verticalSpeed: _toDouble(positionMap['vertical_speed']),
      verticalSpeedAccuracy: _toDouble(positionMap['vertical_speed_accuracy']),
      // A platform that could not measure a value omits its key — see
      // `LocationMapper.toHashMap` on Android, which guards every optional
      // field with the platform's own predicate. `_toDouble` substitutes 0.0
      // for the missing value; these flags record that nothing measured it.
      //
      // `toJson` always writes the numeric keys, so on a round trip key
      // presence alone would report a measurement that never happened. The
      // explicit `has_*` key therefore wins when it is present.
      hasAccuracy: _presence(positionMap, 'has_accuracy', 'accuracy'),
      hasAltitude: _presence(positionMap, 'has_altitude', 'altitude'),
      hasAltitudeAccuracy:
          _presence(positionMap, 'has_altitude_accuracy', 'altitude_accuracy'),
      hasHeading: _presence(positionMap, 'has_heading', 'heading'),
      hasHeadingAccuracy:
          _presence(positionMap, 'has_heading_accuracy', 'heading_accuracy'),
      hasSpeed: _presence(positionMap, 'has_speed', 'speed'),
      hasSpeedAccuracy:
          _presence(positionMap, 'has_speed_accuracy', 'speed_accuracy'),
      hasVerticalSpeed:
          _presence(positionMap, 'has_vertical_speed', 'vertical_speed'),
      hasVerticalSpeedAccuracy: _presence(positionMap,
          'has_vertical_speed_accuracy', 'vertical_speed_accuracy'),
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
        'vertical_speed': verticalSpeed,
        'vertical_speed_accuracy': verticalSpeedAccuracy,
        'has_accuracy': hasAccuracy,
        'has_altitude': hasAltitude,
        'has_altitude_accuracy': hasAltitudeAccuracy,
        'has_heading': hasHeading,
        'has_heading_accuracy': hasHeadingAccuracy,
        'has_speed': hasSpeed,
        'has_speed_accuracy': hasSpeedAccuracy,
        'has_vertical_speed': hasVerticalSpeed,
        'has_vertical_speed_accuracy': hasVerticalSpeedAccuracy,
      };

  /// Whether [map] carries a measurement for a field.
  ///
  /// Prefers the explicit `has_*` key when the map carries one (a `toJson`
  /// round trip), and otherwise falls back to the presence of the value key
  /// itself (a platform-channel message, where an unmeasured field is omitted).
  static bool _presence(
      Map<dynamic, dynamic> map, String flagKey, String valueKey) {
    final flag = map[flagKey];
    if (flag is bool) {
      return flag;
    }
    return map.containsKey(valueKey) && map[valueKey] != null;
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    return value.toDouble();
  }
}
