import 'package:flutter/material.dart';
import 'package:geolocator_example/widgets/calculate_distance_widget.dart';
import 'package:geolocator_example/widgets/current_location_widget.dart';
import 'package:geolocator_example/widgets/lookup_address_widget.dart';
import 'package:geolocator_example/widgets/lookup_coordinates_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Plugin example app'),
            ),
            body: new Center(
              child: new Column(
                children: <Widget>[
                  new CurrentLocationWidget(),
                  new Divider(),
                  new LookupAddressWidget(),
                  new Divider(),
                  new LookupCoordinatesWidget(),
                  new Divider(),
                  new CalculateDistanceWidget(),
                ],
              ),
            )));
  }
}
