library placemark;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:geolocator/src/models/position.dart';
import 'package:geolocator/src/models/serializers.dart';

part 'placemark.g.dart';

/// Contains detailed placemark information.
abstract class Placemark implements Built<Placemark, PlacemarkBuilder> {
  factory Placemark([void updates(PlacemarkBuilder b)]) = _$Placemark;

  factory Placemark.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith(serializer, json);

  Placemark._();

  /// The name of the placemark.
  String get name;

  /// The abbreviated country name, according to the two letter (alpha-2)
  /// [ISO standard](https://www.iso.org/iso-3166-country-codes.html).
  String get isoCountryCode;

  /// The name of the country associated with the placemark.
  String get country;

  /// The postal code associated with the placemark.
  String get postalCode;

  /// The name of the state or province associated with the placemark.
  String get administrativeArea;

  /// Additional administrative area information for the placemark.
  String get subAdministrativeArea;

  /// The name of the city associated with the placemark.
  String get locality;

  /// Additional city-level information for the placemark.
  String get subLocality;

  /// The street address associated with the placemark.
  String get thoroughfare;

  /// Additional street address information for the placemark.
  String get subThoroughfare;

  /// The geo-coordinates associated with the placemark.
  Position get position;

  static BuiltList<Placemark> fromList(List<Map<String, dynamic>> values) {
    return serializers.deserialize(values,
        specifiedType:
            const FullType(BuiltList, <FullType>[FullType(Placemark)]));
  }

  @memoized
  Map<String, dynamic> get json => serializers.serializeWith(serializer, this);

  static Serializer<Placemark> get serializer => _$placemarkSerializer;
}
