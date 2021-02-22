## 2.0.0

- Stable release for null safety.

## 2.0.0-nullsafety.1

- Merged version 1.0.9 into null safety.

## 2.0.0-nullsafety.0

- Migrated to support null safety.

## 1.0.9

- Updated the README.md to more clearly explain the purpose of the geolocator_platform_interface package.

## 1.0.8

- Added the optional floor property to the position model and can be used by implementations to specify the floor on which the device is located (see [#562](https://github.com/Baseflow/flutter-geolocator/issues/562)).

## 1.0.7

- Solves a bug causing less accurate location fixes (see [#531](https://github.com/Baseflow/flutter-geolocator/issues/531)).

## 1.0.6+1

- Solve a bug which adds a zero timeout when no timeout is supplied (see [#564]((https://github.com/Baseflow/flutter-geolocator/issues/564))).

## 1.0.6

- Allow developers to call the `getCurrentPosition` method while already listening to a position stream (see issue [#546](https://github.com/Baseflow/flutter-geolocator/issues/546));
- Make sure the position stream is stopped correctly (see issues [#485](https://github.com/Baseflow/flutter-geolocator/issues/485) and [#541](https://github.com/Baseflow/flutter-geolocator/issues/541));
- Android: fix deprecation warning (see issue [#556](https://github.com/Baseflow/flutter-geolocator/issues/556)).

## 1.0.5

- Added more detailed documentation on the `LocationServiceDisableException` (see issue [#519](https://github.com/Baseflow/flutter-geolocator/issues/519)).

## 1.0.4

- Add the `isMocked` field to the `Position` class to indicate if the position is retrieved using the Android MockLocationProvider (see issue #498);
- Fixed typo in API documentation of LocationPermission (see issue #494)

## 1.0.3+1

- Improved LocationPermission documentation (see issue #494).

## 1.0.3

- Fixed code formatting and homepage URL

## 1.0.2

- Make sure close streams are dereferenced (solves a bug where closed stream is listened to generating an exception).

## 1.0.1

- Add support to force using the Android Location Manager instead of the Android FusedLocationProvider.

## 1.0.0

- Initial open-source release.
