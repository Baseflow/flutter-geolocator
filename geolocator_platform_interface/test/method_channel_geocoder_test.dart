import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_platform_interface/geocoder_platform_interface.dart';
import 'package:geolocator_platform_interface/src/implementations/method_channel_geocoder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final _mockPosition = Position(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000.0,
      accuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  final _mockPlacemark = Placemark(
      administrativeArea: 'Overijssel',
      country: 'Netherlands',
      isoCountryCode: 'NL',
      locality: 'Enschede',
      name: 'Gronausestraat',
      position: _mockPosition,
      postalCode: '',
      subAdministrativeArea: 'Enschede',
      subLocality: 'Enschmarke',
      subThoroughfare: '',
      thoroughfare: 'Gronausestraat');

  group('$MethodChannelGeocoder()', () {
    final log = <MethodCall>[];
    MethodChannelGeocoder methodChannelGeocoder;

    setUp(() async {
      methodChannelGeocoder = MethodChannelGeocoder();

      methodChannelGeocoder.methodChannel
          .setMockMethodCallHandler((call) async {
        log.add(call);

        switch (call.method) {
          case 'placemarkFromAddress':
            return [_mockPlacemark.toJson()];
          case 'placemarkFromCoordinates':
            return [_mockPlacemark.toJson()];
          default:
            return null;
        }
      });

      log.clear();
    });

    group('When requesting placemark based on Address', () {
      group('and not specifying a locale', () {
        test('I should receive a placemark containing the coordinates',
            () async {
          // Arrange
          final address = 'Gronausestraat, Enschede';

          // Act
          final placemarks =
              await methodChannelGeocoder.placemarkFromAddress(address);

          // Assert
          expect(placemarks.length, 1);
          expect(placemarks.first, _mockPlacemark);
        });

        test(
            'the localeIdentifier parameter should not be send to the platform',
            () async {
          // Arrange
          final address = 'Gronausestraat, Enschede';

          // Act
          await methodChannelGeocoder.placemarkFromAddress(address);

          // Assert
          expect(log, <Matcher>[
            isMethodCall(
              'placemarkFromAddress',
              arguments: <String, String>{'address': address},
            ),
          ]);
        });
      });

      group('and specifying a locale', () {
        test('I should receive a placemark containing the address', () async {
          // Arrange
          final latitude = 52.561270;
          final longitude = 5.639382;

          // Act
          final placemarks =
              await methodChannelGeocoder.placemarkFromCoordinates(
            latitude,
            longitude,
            localeIdentifier: 'nl-NL',
          );

          expect(placemarks.length, 1);
          expect(placemarks.first, _mockPlacemark);
        });

        test('the localeIdentifier parameter should be send to the platform',
            () async {
          // Assert
          final latitude = 52.561270;
          final longitude = 5.639382;

          // Act
          await methodChannelGeocoder.placemarkFromCoordinates(
            latitude,
            longitude,
            localeIdentifier: 'nl-NL',
          );

          // Assert
          expect(log, <Matcher>[
            isMethodCall(
              'placemarkFromCoordinates',
              arguments: <String, dynamic>{
                'latitude': latitude,
                'longitude': longitude,
                'localeIdentifier': 'nl-NL',
              },
            ),
          ]);
        });
      });
    });

    group('When requesting a placemark based on a Position', () {
      group('and not specifying a locale', () {
        test('I should receive a placemark containing the address', () async {
          // Arrange
          final position = Position(latitude: 52.561270, longitude: 5.639382);

          // Act
          final placemarks =
              await methodChannelGeocoder.placemarkFromPosition(position);

          expect(placemarks.length, 1);
          expect(placemarks.first, _mockPlacemark);
        });

        test(
            'the localeIdentifier parameter should not be send to the platform',
            () async {
          // Arrange
          final position = Position(latitude: 52.561270, longitude: 5.639382);

          // Act
          await methodChannelGeocoder.placemarkFromPosition(position);

          // Assert
          expect(log, <Matcher>[
            isMethodCall(
              'placemarkFromCoordinates',
              arguments: <String, dynamic>{
                'latitude': position.latitude,
                'longitude': position.longitude,
              },
            ),
          ]);
        });
      });

      group('and specifying a locale', () {
        test('I should receive a placemark containing the address', () async {
          // Arrange
          final position = Position(latitude: 52.561270, longitude: 5.639382);

          // Act
          final placemarks = await methodChannelGeocoder.placemarkFromPosition(
            position,
            localeIdentifier: 'nl-NL',
          );

          // Assert
          expect(placemarks.length, 1);
          expect(placemarks.first, _mockPlacemark);
        });

        test('the localeIdentifier parameter should be send to the platform',
            () async {
          // Arrange
          final position = Position(latitude: 52.561270, longitude: 5.639382);

          // Act
          await methodChannelGeocoder.placemarkFromPosition(
            position,
            localeIdentifier: 'nl-NL',
          );

          // Assert
          expect(log, <Matcher>[
            isMethodCall(
              'placemarkFromCoordinates',
              arguments: <String, dynamic>{
                'latitude': position.latitude,
                'longitude': position.longitude,
                'localeIdentifier': 'nl-NL',
              },
            ),
          ]);
        });
      });
    });
  });
}
