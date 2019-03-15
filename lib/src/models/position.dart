library position;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:geolocator/src/models/serializers.dart';

part 'position.g.dart';

abstract class Position implements Built<Position, PositionBuilder> {
  factory Position([void updates(PositionBuilder b)]) = _$Position;

  Position._();

  static Position fromJson(dynamic json) =>
      serializers.deserializeWith(serializer, json);

  /// The latitude of this position in degrees normalized to the interval
  /// -90.0 to +90.0 (both inclusive).
  double get latitude;

  /// The longitude of the position in degrees normalized to the interval
  /// -180 (exclusive) to +180 (inclusive).
  double get longitude;

  /// The time at which this position was determined.
  @nullable
  DateTime get timestamp;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned
  /// value is 0.0.
  @nullable
  double get altitude;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  @nullable
  double get accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is
  /// 0.0.
  @nullable
  double get heading;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  ///
  /// The speed is not available on all devices. In these cases the value is
  /// 0.0.
  @nullable
  double get speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  @nullable
  double get speedAccuracy;

  @memoized
  Map<String, dynamic> get json => serializers.serializeWith(serializer, this);

  static Serializer<Position> get serializer => _$positionSerializer;
}
