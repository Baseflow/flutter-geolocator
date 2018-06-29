# Flutter Geolocator Plugin

A Flutter plugin which provides easy access to the platform specific location services ([FusedLocationProviderClient](https://developers.google.com/android/reference/com/google/android/gms/location/FusedLocationProviderClient) on Android and [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) on iOS). 

Branch  | Build Status 
------- | ------------
develop | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-geolocator.svg?branch=develop)](https://travis-ci.com/BaseflowIT/flutter-geolocator)
master  | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-geolocator.svg?branch=master)](https://travis-ci.com/BaseflowIT/flutter-geolocator)

## Usage

To use this plugin, add `geolocator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  geolocator: '^1.0.0'
```

> **NOTE:** There's a known issue with integrating plugins that use Swift into a Flutter project created with the Objective-C template. See issue [Flutter#16049](https://github.com/flutter/flutter/issues/16049) for help on integration.

## Permissions

### Android

On Android you'll need to add the `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` permissions to your Android Manifest. Todo so open the AndroidManifest.xml file and add the following two lines as direct children of the `<manifest>` tag:

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

On iOS you'll need to add the `NSLocationWhenInUseUsageDescription` to your Info.plist file in order to access the device's location. Simply open your Info.plist file and add the following:

``` xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
```

If you would like to access the device's location when your App is running in the background, you should also add the `NSLocationAlwaysAndWhenInUseUsageDescription` (if your App support iOS 10 or earlier you should also add the key `NSLocationAlwaysUsageDescription`) key to your Info.plist file:

``` xml
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location when open and in the background.</string>
```

## Example

To query the current location of the device simply make a call to the `getPosition` method:

``` dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/position.dart';

Position position = await new Geolocator.getPosition;
```

To listen for location changes you can subscribe to the `onPositionChanged` stream:

``` dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/position.dart';

Geolocator geolocator = new Geolocator();
StreamSubscription<Position> positionStream = geolocator.onPositionChanged.listen(
    (Position position) {
        print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
    });
```

See also the [example](example/lib/main.dart) project for a complete implementation.
