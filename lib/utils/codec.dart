part of geolocator;

class Codec {
  static GooglePlayServicesAvailability decodePlayServicesAvailability(
      dynamic value) {
    final dynamic availability = json.decode(value.toString());

    return GooglePlayServicesAvailability.values.firstWhere(
        (GooglePlayServicesAvailability e) =>
            e.toString().split('.').last == availability);
  }

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
