// GENERATED CODE - DO NOT MODIFY BY HAND

part of placemark;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Placemark> _$placemarkSerializer = new _$PlacemarkSerializer();

class _$PlacemarkSerializer implements StructuredSerializer<Placemark> {
  @override
  final Iterable<Type> types = const [Placemark, _$Placemark];
  @override
  final String wireName = 'Placemark';

  @override
  Iterable serialize(Serializers serializers, Placemark object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'isoCountryCode',
      serializers.serialize(object.isoCountryCode,
          specifiedType: const FullType(String)),
      'country',
      serializers.serialize(object.country,
          specifiedType: const FullType(String)),
      'postalCode',
      serializers.serialize(object.postalCode,
          specifiedType: const FullType(String)),
      'administrativeArea',
      serializers.serialize(object.administrativeArea,
          specifiedType: const FullType(String)),
      'subAdministrativeArea',
      serializers.serialize(object.subAdministrativeArea,
          specifiedType: const FullType(String)),
      'locality',
      serializers.serialize(object.locality,
          specifiedType: const FullType(String)),
      'subLocality',
      serializers.serialize(object.subLocality,
          specifiedType: const FullType(String)),
      'thoroughfare',
      serializers.serialize(object.thoroughfare,
          specifiedType: const FullType(String)),
      'subThoroughfare',
      serializers.serialize(object.subThoroughfare,
          specifiedType: const FullType(String)),
      'position',
      serializers.serialize(object.position,
          specifiedType: const FullType(Position)),
    ];

    return result;
  }

  @override
  Placemark deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlacemarkBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isoCountryCode':
          result.isoCountryCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'administrativeArea':
          result.administrativeArea = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subAdministrativeArea':
          result.subAdministrativeArea = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'locality':
          result.locality = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subLocality':
          result.subLocality = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'thoroughfare':
          result.thoroughfare = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subThoroughfare':
          result.subThoroughfare = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'position':
          result.position.replace(serializers.deserialize(value,
              specifiedType: const FullType(Position)) as Position);
          break;
      }
    }

    return result.build();
  }
}

class _$Placemark extends Placemark {
  @override
  final String name;
  @override
  final String isoCountryCode;
  @override
  final String country;
  @override
  final String postalCode;
  @override
  final String administrativeArea;
  @override
  final String subAdministrativeArea;
  @override
  final String locality;
  @override
  final String subLocality;
  @override
  final String thoroughfare;
  @override
  final String subThoroughfare;
  @override
  final Position position;
  Map<String, dynamic> __json;

  factory _$Placemark([void updates(PlacemarkBuilder b)]) =>
      (new PlacemarkBuilder()..update(updates)).build();

  _$Placemark._(
      {this.name,
      this.isoCountryCode,
      this.country,
      this.postalCode,
      this.administrativeArea,
      this.subAdministrativeArea,
      this.locality,
      this.subLocality,
      this.thoroughfare,
      this.subThoroughfare,
      this.position})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Placemark', 'name');
    }
    if (isoCountryCode == null) {
      throw new BuiltValueNullFieldError('Placemark', 'isoCountryCode');
    }
    if (country == null) {
      throw new BuiltValueNullFieldError('Placemark', 'country');
    }
    if (postalCode == null) {
      throw new BuiltValueNullFieldError('Placemark', 'postalCode');
    }
    if (administrativeArea == null) {
      throw new BuiltValueNullFieldError('Placemark', 'administrativeArea');
    }
    if (subAdministrativeArea == null) {
      throw new BuiltValueNullFieldError('Placemark', 'subAdministrativeArea');
    }
    if (locality == null) {
      throw new BuiltValueNullFieldError('Placemark', 'locality');
    }
    if (subLocality == null) {
      throw new BuiltValueNullFieldError('Placemark', 'subLocality');
    }
    if (thoroughfare == null) {
      throw new BuiltValueNullFieldError('Placemark', 'thoroughfare');
    }
    if (subThoroughfare == null) {
      throw new BuiltValueNullFieldError('Placemark', 'subThoroughfare');
    }
    if (position == null) {
      throw new BuiltValueNullFieldError('Placemark', 'position');
    }
  }

  @override
  Map<String, dynamic> get json => __json ??= super.json;

  @override
  Placemark rebuild(void updates(PlacemarkBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  PlacemarkBuilder toBuilder() => new PlacemarkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Placemark &&
        name == other.name &&
        isoCountryCode == other.isoCountryCode &&
        country == other.country &&
        postalCode == other.postalCode &&
        administrativeArea == other.administrativeArea &&
        subAdministrativeArea == other.subAdministrativeArea &&
        locality == other.locality &&
        subLocality == other.subLocality &&
        thoroughfare == other.thoroughfare &&
        subThoroughfare == other.subThoroughfare &&
        position == other.position;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, name.hashCode),
                                            isoCountryCode.hashCode),
                                        country.hashCode),
                                    postalCode.hashCode),
                                administrativeArea.hashCode),
                            subAdministrativeArea.hashCode),
                        locality.hashCode),
                    subLocality.hashCode),
                thoroughfare.hashCode),
            subThoroughfare.hashCode),
        position.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Placemark')
          ..add('name', name)
          ..add('isoCountryCode', isoCountryCode)
          ..add('country', country)
          ..add('postalCode', postalCode)
          ..add('administrativeArea', administrativeArea)
          ..add('subAdministrativeArea', subAdministrativeArea)
          ..add('locality', locality)
          ..add('subLocality', subLocality)
          ..add('thoroughfare', thoroughfare)
          ..add('subThoroughfare', subThoroughfare)
          ..add('position', position))
        .toString();
  }
}

class PlacemarkBuilder implements Builder<Placemark, PlacemarkBuilder> {
  _$Placemark _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _isoCountryCode;
  String get isoCountryCode => _$this._isoCountryCode;
  set isoCountryCode(String isoCountryCode) =>
      _$this._isoCountryCode = isoCountryCode;

  String _country;
  String get country => _$this._country;
  set country(String country) => _$this._country = country;

  String _postalCode;
  String get postalCode => _$this._postalCode;
  set postalCode(String postalCode) => _$this._postalCode = postalCode;

  String _administrativeArea;
  String get administrativeArea => _$this._administrativeArea;
  set administrativeArea(String administrativeArea) =>
      _$this._administrativeArea = administrativeArea;

  String _subAdministrativeArea;
  String get subAdministrativeArea => _$this._subAdministrativeArea;
  set subAdministrativeArea(String subAdministrativeArea) =>
      _$this._subAdministrativeArea = subAdministrativeArea;

  String _locality;
  String get locality => _$this._locality;
  set locality(String locality) => _$this._locality = locality;

  String _subLocality;
  String get subLocality => _$this._subLocality;
  set subLocality(String subLocality) => _$this._subLocality = subLocality;

  String _thoroughfare;
  String get thoroughfare => _$this._thoroughfare;
  set thoroughfare(String thoroughfare) => _$this._thoroughfare = thoroughfare;

  String _subThoroughfare;
  String get subThoroughfare => _$this._subThoroughfare;
  set subThoroughfare(String subThoroughfare) =>
      _$this._subThoroughfare = subThoroughfare;

  PositionBuilder _position;
  PositionBuilder get position => _$this._position ??= new PositionBuilder();
  set position(PositionBuilder position) => _$this._position = position;

  PlacemarkBuilder();

  PlacemarkBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _isoCountryCode = _$v.isoCountryCode;
      _country = _$v.country;
      _postalCode = _$v.postalCode;
      _administrativeArea = _$v.administrativeArea;
      _subAdministrativeArea = _$v.subAdministrativeArea;
      _locality = _$v.locality;
      _subLocality = _$v.subLocality;
      _thoroughfare = _$v.thoroughfare;
      _subThoroughfare = _$v.subThoroughfare;
      _position = _$v.position?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Placemark other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Placemark;
  }

  @override
  void update(void updates(PlacemarkBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Placemark build() {
    _$Placemark _$result;
    try {
      _$result = _$v ??
          new _$Placemark._(
              name: name,
              isoCountryCode: isoCountryCode,
              country: country,
              postalCode: postalCode,
              administrativeArea: administrativeArea,
              subAdministrativeArea: subAdministrativeArea,
              locality: locality,
              subLocality: subLocality,
              thoroughfare: thoroughfare,
              subThoroughfare: subThoroughfare,
              position: position.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'position';
        position.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Placemark', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
