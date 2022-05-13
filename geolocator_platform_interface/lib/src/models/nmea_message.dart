import 'package:meta/meta.dart';

@immutable

/// Contains all the NMEA information.
class NmeaMessage {
  /// Constructs a NMEA message instance with the given values.
  const NmeaMessage(this.message, this.timestamp);

  /// The full NMEA-0183 message, as reported by the GNSS chipset.
  final String message;

  /// Date and time of the location fix, as reported by the GNSS chipset.
  /// The value is specified in milliseconds since 0:00 UTC 1 January 1970.
  final DateTime? timestamp;

  /// Converts the supplied [Map] to an instance of the [NmeaMessage] class.
  static NmeaMessage fromMap(Map<dynamic, dynamic> message) {
    final Map<dynamic, dynamic> nmeaMap = message;

    if (!nmeaMap.containsKey('message')) {
      throw ArgumentError.value(nmeaMap, 'nmeaMap',
          'The supplied map doesn\'t contain the mandatory key `message`.');
    }

    if (!nmeaMap.containsKey('timestamp')) {
      throw ArgumentError.value(nmeaMap, 'nmeaMap',
          'The supplied map doesn\'t contain the mandatory key `timestamp`.');
    }

    final timestamp = nmeaMap['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(nmeaMap['timestamp'].toInt(),
            isUtc: true)
        : null;

    return NmeaMessage(
      nmeaMap['message'],
      timestamp,
    );
  }

  /// Converts the [NmeaMessage] instance into a [Map] instance that can be
  /// serialized to JSON.
  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp?.millisecondsSinceEpoch,
      };

  @override
  bool operator ==(Object other) {
    var areEqual = other is NmeaMessage &&
        other.message == message &&
        other.timestamp == timestamp;

    return areEqual;
  }

  @override
  int get hashCode => message.hashCode ^ timestamp.hashCode;
}
