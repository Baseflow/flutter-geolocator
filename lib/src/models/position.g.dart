// GENERATED CODE - DO NOT MODIFY BY HAND

part of position;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Position> _$positionSerializer = new _$PositionSerializer();

class _$PositionSerializer implements StructuredSerializer<Position> {
  @override
  final Iterable<Type> types = const [Position, _$Position];
  @override
  final String wireName = 'Position';

  @override
  Iterable serialize(Serializers serializers, Position object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'latitude',
      serializers.serialize(object.latitude,
          specifiedType: const FullType(double)),
      'longitude',
      serializers.serialize(object.longitude,
          specifiedType: const FullType(double)),
    ];
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(DateTime)));
    }
    if (object.altitude != null) {
      result
        ..add('altitude')
        ..add(serializers.serialize(object.altitude,
            specifiedType: const FullType(double)));
    }
    if (object.accuracy != null) {
      result
        ..add('accuracy')
        ..add(serializers.serialize(object.accuracy,
            specifiedType: const FullType(double)));
    }
    if (object.heading != null) {
      result
        ..add('heading')
        ..add(serializers.serialize(object.heading,
            specifiedType: const FullType(double)));
    }
    if (object.speed != null) {
      result
        ..add('speed')
        ..add(serializers.serialize(object.speed,
            specifiedType: const FullType(double)));
    }
    if (object.speedAccuracy != null) {
      result
        ..add('speedAccuracy')
        ..add(serializers.serialize(object.speedAccuracy,
            specifiedType: const FullType(double)));
    }

    return result;
  }

  @override
  Position deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PositionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'altitude':
          result.altitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'accuracy':
          result.accuracy = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'heading':
          result.heading = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'speed':
          result.speed = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'speedAccuracy':
          result.speedAccuracy = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$Position extends Position {
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final DateTime timestamp;
  @override
  final double altitude;
  @override
  final double accuracy;
  @override
  final double heading;
  @override
  final double speed;
  @override
  final double speedAccuracy;
  Map<String, dynamic> __json;

  factory _$Position([void updates(PositionBuilder b)]) =>
      (new PositionBuilder()..update(updates)).build();

  _$Position._(
      {this.latitude,
      this.longitude,
      this.timestamp,
      this.altitude,
      this.accuracy,
      this.heading,
      this.speed,
      this.speedAccuracy})
      : super._() {
    if (latitude == null) {
      throw new BuiltValueNullFieldError('Position', 'latitude');
    }
    if (longitude == null) {
      throw new BuiltValueNullFieldError('Position', 'longitude');
    }
  }

  @override
  Map<String, dynamic> get json => __json ??= super.json;

  @override
  Position rebuild(void updates(PositionBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  PositionBuilder toBuilder() => new PositionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Position &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        timestamp == other.timestamp &&
        altitude == other.altitude &&
        accuracy == other.accuracy &&
        heading == other.heading &&
        speed == other.speed &&
        speedAccuracy == other.speedAccuracy;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, latitude.hashCode), longitude.hashCode),
                            timestamp.hashCode),
                        altitude.hashCode),
                    accuracy.hashCode),
                heading.hashCode),
            speed.hashCode),
        speedAccuracy.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Position')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('timestamp', timestamp)
          ..add('altitude', altitude)
          ..add('accuracy', accuracy)
          ..add('heading', heading)
          ..add('speed', speed)
          ..add('speedAccuracy', speedAccuracy))
        .toString();
  }
}

class PositionBuilder implements Builder<Position, PositionBuilder> {
  _$Position _$v;

  double _latitude;
  double get latitude => _$this._latitude;
  set latitude(double latitude) => _$this._latitude = latitude;

  double _longitude;
  double get longitude => _$this._longitude;
  set longitude(double longitude) => _$this._longitude = longitude;

  DateTime _timestamp;
  DateTime get timestamp => _$this._timestamp;
  set timestamp(DateTime timestamp) => _$this._timestamp = timestamp;

  double _altitude;
  double get altitude => _$this._altitude;
  set altitude(double altitude) => _$this._altitude = altitude;

  double _accuracy;
  double get accuracy => _$this._accuracy;
  set accuracy(double accuracy) => _$this._accuracy = accuracy;

  double _heading;
  double get heading => _$this._heading;
  set heading(double heading) => _$this._heading = heading;

  double _speed;
  double get speed => _$this._speed;
  set speed(double speed) => _$this._speed = speed;

  double _speedAccuracy;
  double get speedAccuracy => _$this._speedAccuracy;
  set speedAccuracy(double speedAccuracy) =>
      _$this._speedAccuracy = speedAccuracy;

  PositionBuilder();

  PositionBuilder get _$this {
    if (_$v != null) {
      _latitude = _$v.latitude;
      _longitude = _$v.longitude;
      _timestamp = _$v.timestamp;
      _altitude = _$v.altitude;
      _accuracy = _$v.accuracy;
      _heading = _$v.heading;
      _speed = _$v.speed;
      _speedAccuracy = _$v.speedAccuracy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Position other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Position;
  }

  @override
  void update(void updates(PositionBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Position build() {
    final _$result = _$v ??
        new _$Position._(
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp,
            altitude: altitude,
            accuracy: accuracy,
            heading: heading,
            speed: speed,
            speedAccuracy: speedAccuracy);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
