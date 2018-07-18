import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/location_options.dart';
import 'package:geolocator/models/position.dart';

class CurrentLocationWidget extends StatefulWidget {
  @override 
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  final Geolocator _geolocator = Geolocator();
  Position _position;
  _LocationState();

  @override
  void initState() { 
      super.initState();
    _initPlatformState();
    
    _geolocator
      .getPositionStream(LocationOptions(
          accuracy: LocationAccuracy.high, 
          distanceFilter: 10))
      .handleError((onError) {
        setState(() {
          _position = null;
        });
      })
      .listen((Position position) {
        setState(() {
          _position = position;
        });
      });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      position = await _geolocator.getPosition(LocationAccuracy.high);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
      final position = _position == null
        ? 'Unknown'
        : _position.latitude.toString() + ', ' + _position.longitude.toString();
      
      return new Text('Current location: $position\n');
    }
}