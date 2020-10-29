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
