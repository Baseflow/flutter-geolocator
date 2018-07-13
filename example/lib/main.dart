import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/location_options.dart';
import 'package:geolocator/models/placemark.dart';
import 'package:geolocator/models/position.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Geolocator _geolocator = new Geolocator();
  Position _position;
  String _placemarkCoords = '';
  String _placemark = '';
  StreamSubscription<Position> _positionSubscription;
  TextEditingController _addressTextController = new TextEditingController();
  TextEditingController _coordinatesTextController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _positionSubscription = _geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.high, distanceFilter: 10))
        .handleError((onError) {
      setState(() {
        _position = null;
      });
    }).listen((Position position) {
      setState(() {
        _position = position;
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
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

  void onLookupCoordinatesPressed() async {
    List<Placemark> placemarks =
        await _geolocator.toPlacemark(_addressTextController.text);

    if (placemarks != null && placemarks.length >= 1) {
      var pos = placemarks[0];
      setState(() {
        _placemarkCoords = pos.position.latitude.toString() +
            ', ' +
            pos.position.longitude.toString();
      });
    }
  }

  void onLookupAddressPressed() async {
    var coords = _coordinatesTextController.text.split(',');
    var latitude = double.parse(coords[0]);
    var longitude = double.parse(coords[1]);
    List<Placemark> placemarks =
        await _geolocator.fromPlacemark(latitude, longitude);

    if (placemarks != null && placemarks.length >= 1) {
      var pos = placemarks[0];
      setState(() {
        _placemark = pos.thoroughfare + ", " + pos.locality;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = _position == null
        ? 'Unknown'
        : _position.latitude.toString() + ', ' + _position.longitude.toString();

    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Plugin example app'),
            ),
            body: new Center(
              child: new Column(
                children: <Widget>[
                  new Text('Current location: $position\n'),
                  new Divider(),
                  new TextField(
                    decoration: new InputDecoration(
                        hintText: "Please enter an address"),
                    controller: _addressTextController,
                  ),
                  new RaisedButton(
                    child: new Text('Look up...'),
                    onPressed: () {
                      onLookupCoordinatesPressed();
                    },
                  ),
                  new Text(_placemarkCoords),
                  new Divider(),
                  new TextField(
                    decoration:
                        new InputDecoration(hintText: "latitude,longitude"),
                    controller: _coordinatesTextController,
                  ),
                  new RaisedButton(
                    child: new Text('Look up...'),
                    onPressed: () {
                      onLookupAddressPressed();
                    },
                  ),
                  new Text(_placemark),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    if (_positionSubscription != null) {
      _positionSubscription.cancel();
      _positionSubscription = null;
    }

    super.dispose();
  }
}
