## 1.0.5

- Wrapped all global functions to a static class, thus changing the way geolocator methods should be called. (see issue [#524] (https://github.com/Baseflow/flutter-geolocator/issues/524)).

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
