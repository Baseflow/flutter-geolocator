## 1.3.0

- Provide an interface `isGoogleLocationAccuracyEnabled` to check the Google Location Accuracy setting.

## 1.2.2

- Fixed iOS cancelation of positionStream.

## 1.2.1

- Use `requestAlwaysAuthorization` instead of `requestWhenInUseAuthorization` on macOS as both result in the same behaviour but the former has better support on Catelina.

## 1.2.0

- Make sure the `getCurrentPosition` method returns the current position and not a cached location which might be wrong (see issue [#629](https://github.com/Baseflow/flutter-geolocator/issues/629)).

## 1.1.0

- Added support for macOS Desktop.

## 1.0.0

- Initial open source release.

