import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  group('hashCode tests:', () {
    test('hashCode should be the same for two instances with the same values',
        () {
      // Arrange
      final firstNmeaMessage =
          NmeaMessage("message", DateTime.fromMicrosecondsSinceEpoch(500));
      final secondNmeaMessage =
          NmeaMessage("message", DateTime.fromMicrosecondsSinceEpoch(500));

      // Act & Assert
      expect(
        firstNmeaMessage.hashCode,
        secondNmeaMessage.hashCode,
      );
    });

    test('hashCode should not match when the message property is different',
        () {
      // Arrange
      final firstNmeaMessage = NmeaMessage(
        "first",
        DateTime.fromMillisecondsSinceEpoch(0),
      );
      final secondNmeaMessage = NmeaMessage(
        "second",
        DateTime.fromMillisecondsSinceEpoch(0),
      );

      // Act & Assert
      expect(
        firstNmeaMessage.hashCode != secondNmeaMessage.hashCode,
        true,
      );
    });

    test('hashCode should not match when the timestamp property is different',
        () {
      // Arrange
      final firstNmeaMessage = NmeaMessage(
        "message",
        DateTime.fromMillisecondsSinceEpoch(0),
      );
      final secondNmeaMessage = NmeaMessage(
        "message",
        DateTime.fromMillisecondsSinceEpoch(1),
      );

      // Act & Assert
      expect(
        firstNmeaMessage.hashCode != secondNmeaMessage.hashCode,
        true,
      );
    });
  });

  group('fromMap tests:', () {
    test('fromMap should return null when message is null', () {
      // Act
      final actual = NmeaMessage.fromMap(null);

      // Assert
      expect(actual, null);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'fromMap should throw argument error when map does not contain message',
        () {
      // Arrange
      final map = <String, int>{
        'timestamp': 0,
      };

      // Act & Assert
      expect(() => NmeaMessage.fromMap(map), throwsArgumentError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'fromMap should throw argument error when map does not contain timestamp',
        () {
      // Arrange
      final map = <String, String>{
        'message': "nmeaMessage",
      };

      // Act & Assert
      expect(() => NmeaMessage.fromMap(map), throwsArgumentError);
    });
  });
}
