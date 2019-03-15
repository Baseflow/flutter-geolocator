// GENERATED CODE - DO NOT MODIFY BY HAND

part of location_options;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LocationOptions> _$locationOptionsSerializer =
    new _$LocationOptionsSerializer();

class _$LocationOptionsSerializer
    implements StructuredSerializer<LocationOptions> {
  @override
  final Iterable<Type> types = const [LocationOptions, _$LocationOptions];
  @override
  final String wireName = 'LocationOptions';

  @override
  Iterable serialize(Serializers serializers, LocationOptions object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'accuracy',
      serializers.serialize(object.accuracy,
          specifiedType: const FullType(LocationAccuracy)),
      'distanceFilter',
      serializers.serialize(object.distanceFilter,
          specifiedType: const FullType(int)),
      'forceAndroidLocationManager',
      serializers.serialize(object.forceAndroidLocationManager,
          specifiedType: const FullType(bool)),
      'timeInterval',
      serializers.serialize(object.timeInterval,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  LocationOptions deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LocationOptionsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'accuracy':
          result.accuracy = serializers.deserialize(value,
                  specifiedType: const FullType(LocationAccuracy))
              as LocationAccuracy;
          break;
        case 'distanceFilter':
          result.distanceFilter = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'forceAndroidLocationManager':
          result.forceAndroidLocationManager = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'timeInterval':
          result.timeInterval = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$LocationOptions extends LocationOptions {
  @override
  final LocationAccuracy accuracy;
  @override
  final int distanceFilter;
  @override
  final bool forceAndroidLocationManager;
  @override
  final int timeInterval;
  Map<String, dynamic> __json;

  factory _$LocationOptions([void updates(LocationOptionsBuilder b)]) =>
      (new LocationOptionsBuilder()..update(updates)).build();

  _$LocationOptions._(
      {this.accuracy,
      this.distanceFilter,
      this.forceAndroidLocationManager,
      this.timeInterval})
      : super._() {
    if (accuracy == null) {
      throw new BuiltValueNullFieldError('LocationOptions', 'accuracy');
    }
    if (distanceFilter == null) {
      throw new BuiltValueNullFieldError('LocationOptions', 'distanceFilter');
    }
    if (forceAndroidLocationManager == null) {
      throw new BuiltValueNullFieldError(
          'LocationOptions', 'forceAndroidLocationManager');
    }
    if (timeInterval == null) {
      throw new BuiltValueNullFieldError('LocationOptions', 'timeInterval');
    }
  }

  @override
  Map<String, dynamic> get json => __json ??= super.json;

  @override
  LocationOptions rebuild(void updates(LocationOptionsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationOptionsBuilder toBuilder() =>
      new LocationOptionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationOptions &&
        accuracy == other.accuracy &&
        distanceFilter == other.distanceFilter &&
        forceAndroidLocationManager == other.forceAndroidLocationManager &&
        timeInterval == other.timeInterval;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, accuracy.hashCode), distanceFilter.hashCode),
            forceAndroidLocationManager.hashCode),
        timeInterval.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LocationOptions')
          ..add('accuracy', accuracy)
          ..add('distanceFilter', distanceFilter)
          ..add('forceAndroidLocationManager', forceAndroidLocationManager)
          ..add('timeInterval', timeInterval))
        .toString();
  }
}

class LocationOptionsBuilder
    implements Builder<LocationOptions, LocationOptionsBuilder> {
  _$LocationOptions _$v;

  LocationAccuracy _accuracy;
  LocationAccuracy get accuracy => _$this._accuracy;
  set accuracy(LocationAccuracy accuracy) => _$this._accuracy = accuracy;

  int _distanceFilter;
  int get distanceFilter => _$this._distanceFilter;
  set distanceFilter(int distanceFilter) =>
      _$this._distanceFilter = distanceFilter;

  bool _forceAndroidLocationManager;
  bool get forceAndroidLocationManager => _$this._forceAndroidLocationManager;
  set forceAndroidLocationManager(bool forceAndroidLocationManager) =>
      _$this._forceAndroidLocationManager = forceAndroidLocationManager;

  int _timeInterval;
  int get timeInterval => _$this._timeInterval;
  set timeInterval(int timeInterval) => _$this._timeInterval = timeInterval;

  LocationOptionsBuilder();

  LocationOptionsBuilder get _$this {
    if (_$v != null) {
      _accuracy = _$v.accuracy;
      _distanceFilter = _$v.distanceFilter;
      _forceAndroidLocationManager = _$v.forceAndroidLocationManager;
      _timeInterval = _$v.timeInterval;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationOptions other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LocationOptions;
  }

  @override
  void update(void updates(LocationOptionsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$LocationOptions build() {
    final _$result = _$v ??
        new _$LocationOptions._(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
            forceAndroidLocationManager: forceAndroidLocationManager,
            timeInterval: timeInterval);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
