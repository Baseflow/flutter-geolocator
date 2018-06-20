import 'package:meta/meta.dart';

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

  /// Gets or sets the location latitude.
  final double latitude;

  /// Gets or sets the location longitude.
  final double longitude;

  /// Gets or sets the altitude of the device.
  ///
  /// The altitude is not available on all devices. In these cases the value is 0.0.
  final double altitude;

  /// Gets or sets the accuracy of the device.
  ///
  /// The accuracy is not available on all devices. In these cases the value is 0.0.
  final double accuracy;

  /// Gets or sets the heading of the device.
  ///
  /// The heading is not available on all devices. In these cases the value is 0.0.
  final double heading;

  /// Gets or sets the speed at which the device is travelling
  ///
  /// The speed is not available on all devices. In these cases the value is 0.0.
  final double speed;

  /// Gets or sets the accuracy at which the traveling speed of the device was determined.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the value is 0.0.
  final double speedAccuracy;

  /// Converts the supplied [Map] to an instance of the [Position] class.
  static Position fromMap(Map<String, double> positionMap) {
    if (!positionMap.containsKey('latitude'))
      throw new ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `latitude`.');

    if (!positionMap.containsKey('longitude'))
      throw new ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `longitude`.');

    return new Position._(
      latitude: positionMap['latitude'],
      longitude: positionMap['longitude'],
      altitude:
          positionMap.containsKey('altitude') ? positionMap['altitude'] : 0.0,
      accuracy:
          positionMap.containsKey('accuracy') ? positionMap['accuracy'] : 0.0,
      heading:
          positionMap.containsKey('heading') ? positionMap['heading'] : 0.0,
      speed: positionMap.containsKey('speed') ? positionMap['speed'] : 0.0,
      speedAccuracy: positionMap.containsKey('speed_accuracy')
          ? positionMap['speed_accuracy']
          : 0.0,
    );
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
