import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../common_widgets/placeholder_widget.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
  }) : super(key: key);

  final bool androidFusedLocation;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  Position _lastKnownPosition;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    final geolocator = Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation;

    await geolocator
        .getLastKnownPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeout: Duration(seconds: 5),
    )
        .then((position) {
      if (mounted) {
        setState(() => _lastKnownPosition = position);
      }
    }).catchError((e) {
      //
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initCurrentLocation() async {
    final geolocator = Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation;

    await geolocator
        .getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeout: Duration(seconds: 5),
    )
        .then((position) {
      if (mounted) {
        setState(() => _currentPosition = position);
      }
    }).catchError((e) {
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return const PlaceholderWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Text(
                    _fusedLocationNote(),
                    textAlign: TextAlign.center,
                  ),
                ),
                PlaceholderWidget(
                    'Last known location:', _lastKnownPosition.toString()),
                PlaceholderWidget(
                    'Current location:', _currentPosition.toString()),
              ],
            ),
          );
        });
  }

  String _fusedLocationNote() {
    if (widget.androidFusedLocation) {
      return 'Geolocator is using the Android FusedLocationProvider. This requires Google Play Services to be installed on the target device.';
    }

    return 'Geolocator is using the raw location manager classes shipped with the operating system.';
  }
}
