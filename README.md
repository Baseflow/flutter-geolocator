# Flutter Geolocator Plugin  

[![pub package](https://img.shields.io/pub/v/geolocator.svg)](https://pub.dartlang.org/packages/geolocator)

A Flutter geolocation plugin which provides easy access to the platform specific location services ([LocationManager](https://developer.android.com/reference/android/location/LocationManager) on Android and [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) on iOS).

Branch  | Build Status 
------- | ------------
develop | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-geolocator.svg?branch=develop)](https://travis-ci.com/BaseflowIT/flutter-geolocator)
master  | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-geolocator.svg?branch=master)](https://travis-ci.com/BaseflowIT/flutter-geolocator)

## Features

* Get the current location of the device;
* Get continuous location updates;
* Translate an address to geocoordinates and vice verse (a.k.a. Geocoding);
* Calculate the distance (in meters) between two geocoordinates.

## Usage

To use this plugin, add `geolocator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  geolocator: '^1.3.1'
```

> **NOTE:** There's a known issue with integrating plugins that use Swift into a Flutter project created with the Objective-C template. See issue [Flutter#16049](https://github.com/flutter/flutter/issues/16049) for help on integration.

## API

### Geolocation

To query the current location of the device simply make a call to the `getPosition` method:

``` dart
import 'package:geolocator/geolocator.dart';

Position position = await Geolocator().getPosition(LocationAccuracy.High);
```

To listen for location changes you can subscribe to the `onPositionChanged` stream. Supply an instance of the `LocationOptions` class to configure
the desired accuracy and the minimum distance change (in meters) before updates are send to the application.

``` dart
import 'package:geolocator/geolocator.dart';

var geolocator = Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.High, distanceFilter: 10);

StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
        print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
    });
```

### Geocoding

To translate an address into latitude and longitude coordinates you can use the `placemarkFromAddress` method:

``` dart
import 'package:geolocator/geolocator.dart';

Placemark placemark = await Geolocator().placemarkFromAddress("Gronausestraat 710, Enschede");
```

If you want to translate latitude and longitude coordinates into an address you can use the `placemarkFromCoordinates` method:

``` dart
import 'package:geolocator/geolocator.dart';

Placemark placemark = await new Geolocator().placemarkFromCoordinates(52.2165157, 6.9437819);
```

### Calculate distance

To calculate the distance (in meters) between two geocoordinates you can use the `distanceBetween` method. The `distanceBetween` method takes four parameters:

Parameter | Type | Description
----------|------|------------
startLatitude | double | Latitude of the start position
startLongitude | double | Longitude of the start position
endLatitude | double | Latitude of the destination position
endLongitude | double | Longitude of the destination position

``` dart
import 'package:geolocator/geolocator.dart';

double distanceInMeters = await new Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
```

See also the [example](example/lib/main.dart) project for a complete implementation.

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

### Location accuracy

The table below outlines the accuracy options per platform:

|            | Android    | iOS   |
|------------|-----------:|------:|
| **lowest** | 500m       | 3000m |
| **low**    | 500m       | 1000m |    
| **medium** | 100 - 500m | 100m  |
| **high**   | 0 - 100m   | 10m   |
| **best**   | 0 - 100m   | ~0m   |
| **bestForNavigation** | 0 - 100m | [Optimized for navigation](https://developer.apple.com/documentation/corelocation/kcllocationaccuracybestfornavigation) |

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/BaseflowIT/flutter-geolocator/issues) page.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](CONTRIBUTING.md) and send us your [pull request](https://github.com/BaseflowIT/flutter-geolocator/pulls).

## Author

This Geolocator plugin for Flutter is developed by [Baseflow](https://baseflow.com). You can contact us at <hello@baseflow.com>
