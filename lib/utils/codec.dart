part of geolocator;

class Codec {
  static String encodeLocationOptions(LocationOptions locationOptions) =>
      json.encode(_locationOptionsMap(locationOptions));

  static Map<String, dynamic> _locationOptionsMap(
      LocationOptions locationOptions) =>
      <String, dynamic>{
        'accuracy': locationOptions.accuracy.value,
        'distanceFilter': locationOptions.distanceFilter,
        'forceAndroidLocationManager':
        locationOptions.forceAndroidLocationManager,
        'timeInterval': locationOptions.timeInterval
      };
}