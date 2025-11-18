// ignore_for_file: use_super_parameters

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
    super.floor,
    isMocked = false,
  }) : super(
          longitude: longitude,
          latitude: latitude,
          timestamp: timestamp,
          accuracy: accuracy,
          altitude: altitude,
          altitudeAccuracy: altitudeAccuracy,
          heading: heading,
          headingAccuracy: headingAccuracy,
          speed: speed,
          speedAccuracy: speedAccuracy,
          isMocked: isMocked,
        );

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
        super == other &&
        other.satelliteCount == satelliteCount &&
        other.satellitesUsedInFix == satellitesUsedInFix;
    return areEqual;
  }

  @override
  int get hashCode =>
      satelliteCount.hashCode ^ satellitesUsedInFix.hashCode ^ super.hashCode;

  /// Converts the supplied [Map] to an instance of the [AndroidPosition] class.
  static AndroidPosition fromMap(dynamic message) {
    final Map<dynamic, dynamic> positionMap = message;
    // Call the Position fromMap method so future changes to the Position class are automatically picked up.
    final position = Position.fromMap(positionMap);

    return AndroidPosition(
      satelliteCount: positionMap['gnss_satellite_count'] ?? 0.0,
      satellitesUsedInFix: positionMap['gnss_satellites_used_in_fix'] ?? 0.0,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
      accuracy: position.accuracy,
      altitude: position.altitude,
      altitudeAccuracy: position.altitudeAccuracy,
      heading: position.heading,
      headingAccuracy: position.headingAccuracy,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
      floor: position.floor,
      isMocked: position.isMocked,
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
