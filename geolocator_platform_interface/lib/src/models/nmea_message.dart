import 'package:meta/meta.dart';

@immutable

/// Contains all the NMEA information.
class NmeaMessage {
  /// Constructs a NMEA message instance with the given values.
  NmeaMessage(this.message, this.timestamp);

  /// The full NMEA-0183 message, as reported by the GNSS chipset.
  final String message;

  /// Date and time of the location fix, as reported by the GNSS chipset.
  /// The value is specified in milliseconds since 0:00 UTC 1 January 1970.
  final DateTime? timestamp;

  /// Converts the supplied [Map] to an instance of the [NmeaMessage] class.
  static NmeaMessage fromMap(dynamic message) {
    final Map<dynamic, dynamic> nmeaMessageMap = message;

    if (!nmeaMessageMap.containsKey('message')) {
      throw ArgumentError.value(nmeaMessageMap, 'nmeaMessageMap',
          'The supplied map doesn\'t contain the mandatory key `message`.');
    }

    if (!nmeaMessageMap.containsKey('timestamp')) {
      throw ArgumentError.value(nmeaMessageMap, 'nmeaMessageMap',
          'The supplied map doesn\'t contain the mandatory key `timestamp`.');
    }

    final timestamp = nmeaMessageMap['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            nmeaMessageMap['timestamp'].toInt(),
            isUtc: true)
        : null;

    return NmeaMessage(
      nmeaMessageMap['message'],
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
  bool operator ==(dynamic o) {
    var areEqual =
        o is NmeaMessage && o.message == message && o.timestamp == timestamp;

    return areEqual;
  }

  @override
  int get hashCode => message.hashCode ^ timestamp.hashCode;
}
