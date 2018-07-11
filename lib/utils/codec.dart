import 'dart:convert';

import 'package:geolocator/models/location_options.dart';

class Codec {
  static String encodeLocationOptions(LocationOptions locationOptions) =>
      json.encode(_locationOptionsMap(locationOptions));

  static String encodeEnum(dynamic value) {
    return value.toString().split('.').last;
  }

  static Map<String, dynamic> _locationOptionsMap(
          LocationOptions locationOptions) =>
      {
        "accuracy": Codec.encodeEnum(locationOptions.accuracy),
        "distanceFilter": locationOptions.distanceFilter
      };
}
