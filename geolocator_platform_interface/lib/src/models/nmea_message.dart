
import 'package:meta/meta.dart';


@immutable
///nmea message
class NmeaMessage {

  ///nmea message
  NmeaMessage(this.message, this.timestamp);

  ///message
  final String message;

  ///timestamp
  final DateTime timestamp;

  /// Converts the supplied [Map] to an instance of the [NmeaMessage] class.
  static NmeaMessage fromMap(dynamic message) {
    if (message == null) {
      return null;
    }
    print("using from map...");

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
    var areEqual = o is NmeaMessage &&
        o.message == message &&
        o.timestamp == timestamp;


    return areEqual;
  }

  @override
  int get hashCode =>
      message.hashCode ^
      timestamp.hashCode;

}
