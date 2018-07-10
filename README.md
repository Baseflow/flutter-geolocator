# Flutter Geolocator Plugin

A Flutter geolocation plugin which provides easy access to the platform specific location services ([LocationManager](https://developer.android.com/reference/android/location/LocationManager) on Android and [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) on iOS).

Branch  | Build Status 
------- | ------------
develop | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-geolocator.svg?branch=develop)](https://travis-ci.com/BaseflowIT/flutter-geolocator)
master  | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-geolocator.svg?branch=master)](https://travis-ci.com/BaseflowIT/flutter-geolocator)

## Features

* Get the current location of the device
* Get continuous location updates
* Translate an address to geocoordinates and vice verse (a.k.a. Geocoding)

## Usage

To use this plugin, add `geolocator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  geolocator: '^1.0.0'
```

> **NOTE:** There's a known issue with integrating plugins that use Swift into a Flutter project created with the Objective-C template. See issue [Flutter#16049](https://github.com/flutter/flutter/issues/16049) for help on integration.

## API

### Geolocation

To query the current location of the device simply make a call to the `getPosition` method:

``` dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/position.dart';

Position position = await new Geolocator().getPosition(LocationAccuracy.High);
```

To listen for location changes you can subscribe to the `onPositionChanged` stream:

``` dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/position.dart';

Geolocator geolocator = new Geolocator();
StreamSubscription<Position> positionStream = geolocator.getPositionStream(LocationAccuracy.High).listen(
    (Position position) {
        print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
    });
```

### Geocoding

To translate an address into latitude and longitude coordinates you can use the `toPlacemark` method:

``` dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/placemark.dart';

Placemark placemark = await new Geolocator().toPlacemark("Gronausestraat 710, Enschede");
```

If you want to translate latitude and longitude coordinates into an address you can use the `fromPlacemark` method:

``` dart
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/placemark.dart';

Placemark placemark = await new Geolocator().toPlacemark(52.2165157, 6.9437819);
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
| **Lowest** | 500m       | 3000m |
| **Low**    | 500m       | 1000m |    
| **Medium** | 100 - 500m | 100m  |
| **High**   | 0 - 100m   | 10m   |
| **Best**   | 0 - 100m   | ~0m   |

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/BaseflowIT/flutter-geolocator/issues) page.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](CONTRIBUTING.md) and send us your [pull request](https://github.com/BaseflowIT/flutter-geolocator/pulls).

## Author

This Geolocator plugin for Flutter is developed by [Baseflow](https://baseflow.com). You can contact us at <hello@baseflow.com>