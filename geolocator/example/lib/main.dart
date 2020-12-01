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
  final List<_GeolocatorItem> _geolocatorItems = <_GeolocatorItem>[];
  StreamSubscription<Position> _positionStreamSubscription;
  StreamSubscription<NmeaMessage> _nmeaStreamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
        itemCount: _geolocatorItems.length,
        itemBuilder: (context, index) {
          final positionItem = _geolocatorItems[index];

          if (positionItem.type == _GeolocatorItemType.permission) {
            return ListTile(
              title: Text(positionItem.displayValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            );
          } else {
            return Card(
              child: ListTile(
                tileColor: themeMaterialColor,
                title: Text(
                  positionItem.displayValue,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await Geolocator.getLastKnownPosition().then((value) => {
                      _geolocatorItems.add(_GeolocatorItem(
                          _GeolocatorItemType.position, value.toString()))
                    });
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
                  await Geolocator.getCurrentPosition().then((value) => {
                        _geolocatorItems.add(_GeolocatorItem(
                            _GeolocatorItemType.position, value.toString()))
                      });
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
              onPressed: _toggleListeningToPositionStream,
              label: Text(() {
                if (_positionStreamSubscription == null) {
                  return "getPositionStream = null";
                } else {
                  return "getPositionStream ="
                      " ${_positionStreamSubscription.isPaused ? "off" : "on"}";
                }
              }()),
              backgroundColor: _determineButtonColorForPositionStreamButton(),
            ),
          ),
          Positioned(
            bottom: 360.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: _toggleListeningToNmeaStream,
              label: Text(() {
                if (_nmeaStreamSubscription == null) {
                  return "getNmeaMessageStream= null";
                } else {
                  return "getNmeaMessageStream ="
                      " ${_nmeaStreamSubscription.isPaused ? "off" : "on"}";
                }
              }()),
              backgroundColor: _determineButtonColorForNmeaButton(),
            ),
          ),
          Positioned(
            bottom: 220.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () => setState(_geolocatorItems.clear),
              label: Text("clear "),
            ),
          ),
          Positioned(
            bottom: 290.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await Geolocator.checkPermission().then((value) => {
                      _geolocatorItems.add(_GeolocatorItem(
                          _GeolocatorItemType.permission, value.toString()))
                    });
                setState(() {});
              },
              label: Text("getPermissionStatus"),
            ),
          ),
        ],
      ),
    );
  }

  bool _isListeningToPositionStream() =>
      !(_positionStreamSubscription == null ||
          _positionStreamSubscription.isPaused);

  Color _determineButtonColorForPositionStreamButton() {
    return _isListeningToPositionStream() ? Colors.green : Colors.red;
  }

  void _toggleListeningToPositionStream() {
    if (_positionStreamSubscription == null) {
      final positionStream = Geolocator.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => setState(() => _geolocatorItems.add(
          _GeolocatorItem(_GeolocatorItemType.position, position.toString()))));
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

  bool _isListeningToNmeaStream() =>
      !(_nmeaStreamSubscription == null || _nmeaStreamSubscription.isPaused);

  Color _determineButtonColorForNmeaButton() {
    return _isListeningToNmeaStream() ? Colors.green : Colors.red;
  }

  void _toggleListeningToNmeaStream() {
    if (_nmeaStreamSubscription == null) {
      final nmeaStream = Geolocator.getNmeaMessageStream();
      _nmeaStreamSubscription = nmeaStream.handleError((error) {
        _nmeaStreamSubscription.cancel();
        _nmeaStreamSubscription = null;
      }).listen((nmeaMessage) => setState(() => _geolocatorItems.add(
          _GeolocatorItem(_GeolocatorItemType.nmea,
              nmeaMessage.message + nmeaMessage.timestamp.toString()))));
      _nmeaStreamSubscription.pause();
    }

    setState(() {
      if (_nmeaStreamSubscription.isPaused) {
        _nmeaStreamSubscription.resume();
      } else {
        _nmeaStreamSubscription.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    if (_nmeaStreamSubscription != null) {
      _nmeaStreamSubscription.cancel();
      _nmeaStreamSubscription = null;
    }

    super.dispose();
  }
}

enum _GeolocatorItemType {
  permission,
  position,
  nmea,
}

class _GeolocatorItem {
  _GeolocatorItem(this.type, this.displayValue);

  final _GeolocatorItemType type;
  final String displayValue;
}
