part of geolocator;

/// Represent the possible location accuracy values.
class LocationAccuracy {
  const LocationAccuracy._(this.value);

  /// The current location accuracy value.
  final int value;

  /// Location is accurate within a distance of 3000m on iOS and 500m on Android
  static const LocationAccuracy lowest = LocationAccuracy._(0);

  /// Location is accurate within a distance of 1000m on iOS and 500m on Android
  static const LocationAccuracy low = LocationAccuracy._(1);

  /// Location is accurate within a distance of 100m on iOS and between 100m and
  /// 500m on Android
  static const LocationAccuracy medium = LocationAccuracy._(2);

  /// Location is accurate within a distance of 10m on iOS and between 0m and
  /// 100m on Android
  static const LocationAccuracy high = LocationAccuracy._(3);

  /// Location is accurate within a distance of ~0m on iOS and between 0m and
  /// 100m on Android
  static const LocationAccuracy best = LocationAccuracy._(4);

  /// Location accuracy is optimized for navigation on iOS and matches the
  /// [LocationAccuracy.best] on Android
  static const LocationAccuracy bestForNavigation = LocationAccuracy._(5);

  /// List of all possible location accuracy values.
  static const List<LocationAccuracy> values = <LocationAccuracy>[
    lowest,
    low,
    medium,
    high,
    best,
    bestForNavigation,
  ];

  static const List<String> _names = <String>[
    'lowest',
    'low',
    'medium',
    'high',
    'best',
    'bestForNavigation',
  ];

  @override
  String toString() => 'LocationAccuracy.${_names[value]}';
}
