import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

class LocationAccuracy {
  const LocationAccuracy._(this.value);

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

  /// Location is accuracy is optimized for navigation on iOS and matches the
  /// [LocationAccuracy.best] on Android
  static const LocationAccuracy bestForNavigation = LocationAccuracy._(5);

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

  static Serializer<LocationAccuracy> get serializer => _serializer$;

  @override
  String toString() => 'LocationAccuracy.${_names[value]}';
}

LocationAccuracySerializer _serializer$ = LocationAccuracySerializer();

class LocationAccuracySerializer
    implements PrimitiveSerializer<LocationAccuracy> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>(<Type>[LocationAccuracy]);
  @override
  final String wireName = 'LocationAccuracy';

  @override
  Object serialize(Serializers serializers, LocationAccuracy accuracy,
      {FullType specifiedType = FullType.unspecified}) {
    return accuracy.value;
  }

  @override
  LocationAccuracy deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return LocationAccuracy.values[serialized];
  }
}
