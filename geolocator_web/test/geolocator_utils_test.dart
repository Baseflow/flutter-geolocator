import 'dart:async';
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_web/src/utils.dart';

import 'geolocator_utils_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Geoposition>(),
  MockSpec<PositionError>(),
])
void main() {
  test('toPosition should throw a exception if coords is null', () {
    final geoposition = MockGeoposition();
    when(geoposition.coords).thenReturn(null);

    expect(
        () => toPosition(geoposition), throwsA(isA<PositionUpdateException>()));
  });

  test('toLocationPermission returns the correct LocationPermission', () {
    expect(toLocationPermission('granted'), LocationPermission.whileInUse);
    expect(toLocationPermission('prompt'), LocationPermission.denied);
    expect(toLocationPermission('denied'), LocationPermission.deniedForever);
    expect(() => toLocationPermission(''), throwsA(isA<ArgumentError>()));
  });

  test('convertPositionError returns the correct exception', () {
    final positionError = MockPositionError();

    when(positionError.code).thenReturn(1);
    expect(
        convertPositionError(positionError), isA<PermissionDeniedException>());

    when(positionError.code).thenReturn(2);
    expect(convertPositionError(positionError), isA<PositionUpdateException>());

    when(positionError.code).thenReturn(3);
    expect(convertPositionError(positionError), isA<TimeoutException>());

    when(positionError.code).thenReturn(4);
    expect(convertPositionError(positionError), isA<PlatformException>());
  });
}
