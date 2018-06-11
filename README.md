# [WIP] Flutter Geolocator Plugin

A Flutter plugin which provides easy access to the platform specific location services ([FusedLocationProviderClient](https://developers.google.com/android/reference/com/google/android/gms/location/FusedLocationProviderClient) on Android and [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) on iOS). 

## Usage

To use this plugin, add `flutter_geolocator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Permissions

### Android

On Android you'll need to add the `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` permissions to your Android Manifest. Todo so open the AndroidManifest.xml file and add the following two lines as direct children of the `<manifest>` tag:

```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

On iOS you'll need to add the `NSLocationWhenInUseUsageDescription` to your Info.plist file in order to access the device's location. Simply open your Info.plist file and add the following:

```
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
```

If you would like to access the device's location when your App is running in the background, you should also add the `NSLocationAlwaysAndWhenInUseUsageDescription` (if your App support iOS 10 or earlier you should also add the key `NSLocationAlwaysUsageDescription`) key to your Info.plist file:

```
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location when open and in the background.</string>
```

## Example

To query the current location of the device simply make a call to the `getPosition` method:

``` dart
import 'package:flutter_geolocator/flutter_geolocator.dart';
import 'package:flutter_geolocator/models/position.dart';

Position position = await FlutterGeolocator.getPosition;
```

To listen for location changes you can subscribe to the `onPositionChanged` stream:

``` dart
import 'package:flutter_geolocator/flutter_geolocator.dart';
import 'package:flutter_geolocator/models/position.dart';

FlutterGeolocator geolocator = new FlutterGeolocator();
StreamSubscription<Position> positionStream = geolocator.onPositionChanged.listen(
    (Position position) {
        print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
    });
```

See also the [example](example/lib/main.dart) project for a complete implementation.