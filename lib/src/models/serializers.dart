library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:geolocator/src/models/location_accuracy.dart';
import 'package:geolocator/src/models/location_options.dart';
import 'package:geolocator/src/models/placemark.dart';
import 'package:geolocator/src/models/position.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[
  LocationOptions,
  Placemark,
  Position,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(LocationAccuracy.serializer)
      ..add(DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addBuilderFactory(
          const FullType(BuiltList, <FullType>[FullType(Position)]),
          () => ListBuilder<Position>())
      ..addBuilderFactory(
          const FullType(BuiltList, <FullType>[FullType(Placemark)]),
          () => ListBuilder<Position>()))
    .build();

/// Serializer for [DateTime].
///
/// An exception will be thrown on attempt to serialize local DateTime
/// instances; you must use UTC.
class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>(<Type>[DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    if (!dateTime.isUtc) {
      throw ArgumentError.value(
          dateTime, 'dateTime', 'Must be in utc for serialization.');
    }

    return dateTime.microsecondsSinceEpoch;
  }

  @override
  DateTime deserialize(Serializers serializers, dynamic serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final int millisecondsSinceEpoch = serialized.toInt();
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
        isUtc: true);
  }
}
