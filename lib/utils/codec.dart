part of geolocator;

/// Provides utility methods for encoding messages that are send on the Flutter message channel.
class Codec {
  /// Converts the supplied [LocationOptions] instance into a [Map] which can be used to serialize to JSON message.
  static Map<String, dynamic> encodeLocationOptions(
          LocationOptions locationOptions) =>
      <String, dynamic>{
        'accuracy': locationOptions.accuracy.value,
        'distanceFilter': locationOptions.distanceFilter,
        'forceAndroidLocationManager':
            locationOptions.forceAndroidLocationManager,
        'timeInterval': locationOptions.timeInterval
      };
}
