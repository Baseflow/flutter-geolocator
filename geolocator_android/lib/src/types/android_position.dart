import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

/// Contains additional location information only available on Android platforms.
@immutable
class AndroidPosition extends Position {
  /// Constructs an instance with the given values for testing. [AndroidPosition]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  const AndroidPosition({
      required this.satelliteCount,
      required this.satellitesUsedInFix,
      required longitude,
      required latitude,
      required timestamp,
      required accuracy,
      required altitude,
      required altitudeAccuracy,
      required heading,
      required headingAccuracy,
      required speed,
      required speedAccuracy,
      int? floor,
      isMocked = false})
      : super(
            longitude: longitude,
            latitude: latitude,
            timestamp: timestamp,
            accuracy: accuracy,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0);

  /// If available it returns the number of GNSS satellites.
  ///
  /// If the number of satellites is not available it returns the default value: 0.0.
  final double satelliteCount;

  /// If available it returns the number of GNSS satellites used in fix.
  ///
  /// If the number of satellites used in fix is not available it returns the default value: 0.0.
  final double satellitesUsedInFix;

  @override
  bool operator ==(Object other) {
    var areEqual = other is AndroidPosition &&
        other.satelliteCount == satelliteCount &&
        other.satellitesUsedInFix == satellitesUsedInFix;
    return areEqual;
  }

  @override
  String toString() {
    return 'Latitude: $latitude, Longitude: $longitude, Satellite count: $satelliteCount, Satellites used in fix: $satellitesUsedInFix';
  }

  @override
  int get hashCode => satelliteCount.hashCode ^ satellitesUsedInFix.hashCode;

  /// Converts the supplied [Map] to an instance of the [AndroidPosition] class.
  static AndroidPosition fromMap(dynamic message) {
    final Map<dynamic, dynamic> positionMap = message;

    return AndroidPosition(
      satelliteCount: positionMap['gnss_satellite_count'] ?? 0.0,
      satellitesUsedInFix: positionMap['gnss_satellites_used_in_fix'] ?? 0.0,
      latitude: positionMap['latitude'],
      longitude: positionMap['longitude'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          positionMap['timestamp'].toInt(),
          isUtc: true),
      altitude: positionMap['altitude'] ?? 0.0,
      altitudeAccuracy: positionMap['altitude_accuracy'] ?? 0.0,
      accuracy: positionMap['accuracy'] ?? 0.0,
      heading: positionMap['heading'] ?? 0.0,
      headingAccuracy: positionMap['heading_accuracy'] ?? 0.0,
      floor: positionMap['floor'],
      speed: positionMap['speed'] ?? 0.0,
      speedAccuracy: positionMap['speed_accuracy'] ?? 0.0,
      isMocked: positionMap['is_mocked'] ?? false,
    );
  }

  /// Converts the [AndroidPosition] instance into a [Map] instance that can be
  /// serialized to JSON.
  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'gnss_satellite_count': satelliteCount,
        'gnss_satellites_used_in_fix': satellitesUsedInFix,
      });
  }
}
