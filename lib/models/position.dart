/// Contains detail location information.
class Position {

  Position._({
    this.longitude,
    this.latitude,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy
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
  static Position fromMap(dynamic message) {
    final Map<dynamic, dynamic> map = message;

    return new Position._(
        latitude: map['latitude'],
        longitude: map['longitude'],
        altitude: map.containsKey('altitude') ? map['altitude'] : 0.0,
        accuracy: map.containsKey('accuracy') ? map['accuracy'] : 0.0,
        heading: map.containsKey('heading') ? map['heading'] : 0.0,
        speed: map.containsKey('speed') ? map['speed'] : 0.0,
        speedAccuracy: map.containsKey('speed_accuracy') ? map['speed_accuracy'] : 0.0,
    );
  }
}