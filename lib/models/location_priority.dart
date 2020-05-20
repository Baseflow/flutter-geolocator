part of geolocator;

/// Represent the possible location service priority values.
class LocationPriority {
  const LocationPriority._(this.value);

  /// The current location service priority value.
  final int value;

  static const LocationPriority noPower = LocationPriority._(105);

  static const LocationPriority lowPower = LocationPriority._(104);

  static const LocationPriority balanced = LocationPriority._(102);

  static const LocationPriority high = LocationPriority._(100);

  /// List of all possible location priority values.
  static const List<LocationPriority> values = <LocationPriority>[
    noPower,
    lowPower,
    balanced,
    high,
  ];

  static const List<String> _names = <String>[
    'noPower',
    'lowPower',
    'balanced',
    'high',
  ];

  @override
  String toString() => 'LocationPriority.${_names[value]}';
}
