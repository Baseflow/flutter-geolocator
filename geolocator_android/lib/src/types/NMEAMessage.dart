/// Represents an NMEA message received from the platform.
/// If the NMEA message represents a GPGGA sequence then the message
/// will be parsed and the GPGGA fields will be populate as well.
class NMEAMessage {

  /// Initializes a new [NMEAMessage] instance with default values.
  const NMEAMessage({
    required this.nmeaMessage,
    this.time,
    this.latitude,
    this.longitude,
    this.quality,
    this.numberOfSatellites,
    this.altitude,
    this.heightAboveEllipsoid,
  });

  /// The raw NMEA Message
  final String nmeaMessage;

  /// UTC time if the NMEA Message was GPGGA Sequence
  /// GPGGA formatting can be found here: http://aprs.gids.nl/nmea/#gga
  final String? time;

  /// Latitude if the NMEA Message was GPGGA Sequence
  /// GPGGA formatting can be found here: http://aprs.gids.nl/nmea/#gga
  final String? latitude;

  /// Longitude if the NMEA Message was GPGGA Sequence
  /// GPGGA formatting can be found here: http://aprs.gids.nl/nmea/#gga
  final String? longitude;

  /// Quality if the NMEA Message was GPGGA Sequence
  /// Valid values can be found here: http://aprs.gids.nl/nmea/#gga
  final int? quality;

  /// Number of Satellites if the NMEA Message was GPGGA Sequence
  final int? numberOfSatellites;

  /// Altitude above mean sea level in meters if the NMEA Message was GPGGA Sequence
  final double? altitude;

  /// Height of geoid above QGS84 ellipsoid
  /// if the NMEA Message was GPGGA Sequence
  final double? heightAboveEllipsoid;

  @override
  bool operator ==(Object other) {
    var areEqual = other is NMEAMessage &&
        other.nmeaMessage == nmeaMessage &&
        other.time == time &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.quality == quality &&
        other.numberOfSatellites == numberOfSatellites &&
        other.altitude == altitude &&
        other.heightAboveEllipsoid == heightAboveEllipsoid;

    return areEqual;
  }

  @override
  int get hashCode =>
      nmeaMessage.hashCode ^
      time.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      quality.hashCode ^
      numberOfSatellites.hashCode ^
      altitude.hashCode ^
      heightAboveEllipsoid.hashCode;

  @override
  String toString() {
    return 'NMEA Message: $nmeaMessage';
  }

  /// Converts the supplied [Map] to an instance of the [NMEAMessage] class.
  static NMEAMessage fromMap(dynamic message) {
    final Map<dynamic, dynamic> nmeaMap = message;

    if (!nmeaMap.containsKey('nmeaMessage')) {
      throw ArgumentError.value(nmeaMap, 'nmeaMap',
          'The supplied map doesn\'t contain the mandatory key `nmeaMessage`.');
    }

    return NMEAMessage(
      nmeaMessage: nmeaMap['nmeaMessage'],
      time: nmeaMap['time'],
      latitude: nmeaMap['latitude'],
      longitude: nmeaMap['longitude'],
      quality: nmeaMap['quality'],
      numberOfSatellites: nmeaMap['numberOfSatellites'],
      altitude: nmeaMap['altitude'],
      heightAboveEllipsoid: nmeaMap['heightAboveEllipsoid'],
    );
  }

  /// Converts the [NMEAMessage] instance into a [Map] instance that can be
  /// serialized to JSON.
  Map<String, dynamic> toJson() => {
    'nmeaMessage': nmeaMessage,
    'time': time,
    'latitude': latitude,
    'longitude': longitude,
    'quality': quality,
    'numberOfSatellites': numberOfSatellites,
    'altitude': altitude,
    'heightAboveEllipsoid': heightAboveEllipsoid,
  };
}
