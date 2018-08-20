part of geolocator;

/// Contains detailed placemark information.
class Placemark {
  Placemark._(
      {this.name,
      this.isoCountryCode,
      this.country,
      this.postalCode,
      this.administrativeArea,
      this.subAdministratieArea,
      this.locality,
      this.subLocality,
      this.thoroughfare,
      this.subThoroughfare,
      this.position});

  /// The name of the placemark.
  final String name;

  /// The abbreviated country name, according to the two letter (alpha-2) [ISO standard](https://www.iso.org/iso-3166-country-codes.html).
  final String isoCountryCode;

  /// The name of the country associated with the placemark.
  final String country;

  /// The postal code associated with the placemark.
  final String postalCode;

  /// The name of the state or province associated with the placemark.
  final String administrativeArea;

  /// Additional administrative area information for the placemark.
  final String subAdministratieArea;

  /// The name of the city associated with the placemark.
  final String locality;

  /// Additional city-level information for the placemark.
  final String subLocality;

  /// The street address associated with the placemark.
  final String thoroughfare;

  /// Additional street address information for the placemark.
  final String subThoroughfare;

  /// The geocoordinates associated with the placemark.
  final Position position;

  /// Converts a list of [Map] instances to a list of [Placemark] instances.
  static List<Placemark> _fromMaps(dynamic message) {
    if (message == null) {
      throw new ArgumentError("The parameter 'message' should not be null.");
    }

    List<Placemark> list = message.map<Placemark>(_fromMap).toList();
    return list;
  }

  /// Converts the supplied [Map] to an instance of the [Placemark] class.
  static Placemark _fromMap(dynamic message) {
    if (message == null) {
      throw new ArgumentError("The parameter 'message' should not be null.");
    }

    final Map<dynamic, dynamic> placemarkMap = message;

    return new Placemark._(
      name: placemarkMap['name'] ?? "",
      isoCountryCode: placemarkMap['isoCountryCode'] ?? "",
      country: placemarkMap["country"] ?? "",
      postalCode: placemarkMap["postalCode"] ?? "",
      administrativeArea: placemarkMap["administrativeArea"] ?? "",
      subAdministratieArea: placemarkMap["subAdministrativeArea"] ?? "",
      locality: placemarkMap["locality"] ?? "",
      subLocality: placemarkMap["subLocality"] ?? "",
      thoroughfare: placemarkMap["thoroughfare"] ?? "",
      subThoroughfare: placemarkMap["subThoroughfare"] ?? "",
      position: Position._fromMap(placemarkMap['location']),
    );
  }
}
