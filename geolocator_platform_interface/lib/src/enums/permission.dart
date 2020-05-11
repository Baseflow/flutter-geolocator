/// Represents all possible permission values used by the [Geolocation] plugin.
class Permission {
  const Permission._(this.value);

  /// The current permission value.
  final int value;

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  static const Permission location = Permission._(0);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  static const Permission locationAlways =
      Permission._(1);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  static const Permission locationWhenInUse =
      Permission._(2);

  /// List with all possible permission values
  static const List<Permission> values = <Permission>[
    location,
    locationAlways,
    locationWhenInUse,
  ];

  static const List<String> _names = <String>[
    'location',
    'locationAlways',
    'locationWhenInUse',
  ];

  @override
  String toString() => 'Permission.${_names[value]}';
}