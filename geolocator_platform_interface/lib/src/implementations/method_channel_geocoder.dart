import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../geocoder_platform_interface.dart';
import '../models/models.dart';

/// An implementation of [GeocoderPlatform] that uses method channels.
class MethodChannelGeocoder extends GeocoderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel = MethodChannel('flutter.baseflow.com/geocoder');

  @override
  Future<List<Placemark>> placemarkFromAddress(
    String address, {
    String localeIdentifier,
  }) async {
    final parameters = <String, String>{
      'address': address,
    };

    if (localeIdentifier != null) {
      parameters['localeIdentifier'] = localeIdentifier;
    }

    final placemarks = await methodChannel.invokeMethod(
      'placemarkFromAddress',
      parameters,
    );

    return Placemark.fromMaps(placemarks);
  }

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String localeIdentifier,
  }) async {
    final parameters = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };

    if (localeIdentifier != null) {
      parameters['localeIdentifier'] = localeIdentifier;
    }

    final placemarks = await methodChannel.invokeMethod(
        'placemarkFromCoordinates', parameters);

    return Placemark.fromMaps(placemarks);
  }
}
