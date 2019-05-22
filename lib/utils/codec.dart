part of geolocator;

class Codec {
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
