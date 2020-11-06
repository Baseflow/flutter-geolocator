import 'dart:async';

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Defines the main theme color.
final MaterialColor themeMaterialColor =
    BaseflowPluginExample.createMaterialColor(
        const Color.fromRGBO(48, 49, 60, 1));

void main() {
  runApp(BaseflowPluginExample(
    pluginName: 'Geolocator',
    githubURL: 'https://github.com/Baseflow/flutter-geolocator',
    pubDevURL: 'https://pub.dev/packages/geolocator',
    pages: [GeolocatorWidget.createPage()],
  ));
}

/// Example [Widget] showing the functionalities of the geolocator plugin
class GeolocatorWidget extends StatefulWidget {
  static ExamplePage createPage() {
    return ExamplePage(Icons.location_on, (context) => GeolocatorWidget());
  }

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  List<Position> posList = <Position>[];
  StreamSubscription<Position> _positionStreamSubscription;
  LocationPermission permissionStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
          itemCount: posList.length == 0 ? 1 : posList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                  title: Text(
                "LocationPermission = $permissionStatus",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ));
            }
            index -= 1;
            return Card(
              child: ListTile(
                tileColor: themeMaterialColor,
                title: Text(posList[index].toString(),
                    style: TextStyle(color: Colors.white)),
              ),
            );
          }),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () async {
                posList.add(await Geolocator.getLastKnownPosition());

                setState(
                  () {},
                );
              },
              label: Text("getLastKnownPosition"),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton.extended(
                onPressed: () async {
                  posList.add(await Geolocator.getCurrentPosition());

                  setState(
                    () {},
                  );
                },
                label: Text("getCurrentPosition")),
          ),
          Positioned(
            bottom: 150.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: _toggleListening,
              label: Text(() {
                if (_positionStreamSubscription == null) {
                  return "getPositionStream = off";
                } else {
                  return "getPositionStream ="
                      " ${_positionStreamSubscription.isPaused ? "off" : "on"}";
                }
              }()),
              backgroundColor: _determineButtonColor(),
            ),
          ),
          Positioned(
            bottom: 220.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () => setState(posList.clear),
              label: Text("clear positions"),
            ),
          ),
          Positioned(
            bottom: 290.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () async {
                permissionStatus = await Geolocator.checkPermission()
                    .whenComplete(() => setState(() {}));
              },
              label: Text("getPermissionStatus"),
            ),
          ),
        ],
      ),
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = Geolocator.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => setState(() => posList.add(position)));
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }
}
