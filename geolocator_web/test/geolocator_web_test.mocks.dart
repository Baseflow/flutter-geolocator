// Mocks generated by Mockito 5.4.4 from annotations
// in geolocator_web/test/geolocator_web_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart'
    as _i2;
import 'package:geolocator_web/src/geolocation_manager.dart' as _i3;
import 'package:geolocator_web/src/permissions_manager.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakePosition_0 extends _i1.SmartFake implements _i2.Position {
  _FakePosition_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GeolocationManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockGeolocationManager extends _i1.Mock
    implements _i3.GeolocationManager {
  @override
  _i4.Future<_i2.Position> getCurrentPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
    Duration? maximumAge,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentPosition,
          [],
          {
            #enableHighAccuracy: enableHighAccuracy,
            #timeout: timeout,
            #maximumAge: maximumAge,
          },
        ),
        returnValue: _i4.Future<_i2.Position>.value(_FakePosition_0(
          this,
          Invocation.method(
            #getCurrentPosition,
            [],
            {
              #enableHighAccuracy: enableHighAccuracy,
              #timeout: timeout,
              #maximumAge: maximumAge,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Position>.value(_FakePosition_0(
          this,
          Invocation.method(
            #getCurrentPosition,
            [],
            {
              #enableHighAccuracy: enableHighAccuracy,
              #timeout: timeout,
              #maximumAge: maximumAge,
            },
          ),
        )),
      ) as _i4.Future<_i2.Position>);

  @override
  _i4.Stream<_i2.Position> watchPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
    Duration? maximumAge,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #watchPosition,
          [],
          {
            #enableHighAccuracy: enableHighAccuracy,
            #timeout: timeout,
            #maximumAge: maximumAge,
          },
        ),
        returnValue: _i4.Stream<_i2.Position>.empty(),
        returnValueForMissingStub: _i4.Stream<_i2.Position>.empty(),
      ) as _i4.Stream<_i2.Position>);
}

/// A class which mocks [PermissionsManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockPermissionsManager extends _i1.Mock
    implements _i5.PermissionsManager {
  @override
  bool get permissionsSupported => (super.noSuchMethod(
        Invocation.getter(#permissionsSupported),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i4.Future<_i2.LocationPermission> query(Map<dynamic, dynamic>? permission) =>
      (super.noSuchMethod(
        Invocation.method(
          #query,
          [permission],
        ),
        returnValue: _i4.Future<_i2.LocationPermission>.value(
            _i2.LocationPermission.denied),
        returnValueForMissingStub: _i4.Future<_i2.LocationPermission>.value(
            _i2.LocationPermission.denied),
      ) as _i4.Future<_i2.LocationPermission>);
}
