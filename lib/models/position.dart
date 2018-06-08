class Position {

  Position._({
    this.longitude,
    this.latitude,
    this.accuracy,
    this.altitude,
    this.altitudeAccuracy,
    this.heading,
    this.speed,
    this.speedAccuracy
  });

  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final double altitudeAccuracy;
  final double heading;
  final double speed;
  final double speedAccuracy;

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