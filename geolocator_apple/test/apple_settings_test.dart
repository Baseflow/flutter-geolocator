import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_apple/geolocator_apple.dart';

import 'event_channel_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppleSettings activity type serialization', () {
    // These values are the native channel contract, not Core Location's enum.
    const nativeValues = {
      ActivityType.automotiveNavigation: 0,
      ActivityType.fitness: 1,
      ActivityType.otherNavigation: 2,
      ActivityType.airborne: 3,
      ActivityType.other: 4,
      ActivityType.maritime: 5,
    };

    for (final entry in nativeValues.entries) {
      test('preserves the native value for ${entry.key}', () {
        final settings = AppleSettings(activityType: entry.key);

        expect(settings.toJson()['activityType'], entry.value);
      });
    }

    test('keeps the default activity type unchanged', () {
      expect(AppleSettings().toJson()['activityType'], 4);
    });
  });

  test('passes maritime settings to the native position stream', () async {
    final position = Position(
      latitude: 52,
      longitude: 5,
      timestamp: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      accuracy: 5,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    final channel = EventChannelMock(
      channelName: 'flutter.baseflow.com/geolocator_updates_apple',
      stream: Stream.value(position.toJson()),
    );
    final settings = AppleSettings(activityType: ActivityType.maritime);

    final result = await GeolocatorApple()
        .getPositionStream(locationSettings: settings)
        .first;

    expect(result, position);
    final listenCall =
        channel.log.singleWhere((call) => call.method == 'listen');
    expect(listenCall.arguments, settings.toJson());
    expect(listenCall.arguments['activityType'], 5);
  });
}
