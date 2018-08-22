part of geolocator;

class Codec {
  static String encodeLocationOptions(LocationOptions locationOptions) =>
      json.encode(_locationOptionsMap(locationOptions));

  static String encodeEnum(dynamic value) {
    return value.toString().split('.').last;
  }

  static Map<String, dynamic> _locationOptionsMap(
          LocationOptions locationOptions) =>
      <String, dynamic>{
        "accuracy": Codec.encodeEnum(locationOptions.accuracy),
        "distanceFilter": locationOptions.distanceFilter
      };
}
