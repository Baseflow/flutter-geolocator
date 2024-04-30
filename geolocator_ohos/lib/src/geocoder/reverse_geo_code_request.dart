class ReverseGeoCodeRequest {
  /// Indicates the language area information.
  ///
  final String? locale;

  /// Latitude for reverse geocoding query.
  ///
  final double latitude;

  /// Longitude for reverse geocoding query.
  ///
  final double longitude;

  /// Indicates the maximum number of addresses returned by reverse geocoding query.
  ///
  final int? maxItems;

  ReverseGeoCodeRequest({
    this.locale,
    required this.latitude,
    required this.longitude,
    this.maxItems,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      if (locale != null) 'locale': locale,
      if (maxItems != null) 'maxItems': maxItems,
    };
  }
}
