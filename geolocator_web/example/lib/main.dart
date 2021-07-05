import 'dart:async';

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:geolocator_web/geolocator_web.dart';

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
  /// Utility method to create a page with the Baseflow templating.
  static ExamplePage createPage() {
    return ExamplePage(Icons.location_on, (context) => GeolocatorWidget());
  }

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
        itemCount: _positionItems.length,
        itemBuilder: (context, index) {
          final positionItem = _positionItems[index];

          if (positionItem.type == _PositionItemType.permission) {
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
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _toggleListening,
            label: Text(() {
              if (_positionStreamSubscription == null) {
                return "Start position updates stream";
              } else {
                final buttonText =
                    _positionStreamSubscription!.isPaused ? "Resume" : "Pause";

                return "$buttonText position updates stream";
              }
            }()),
            backgroundColor: _determineButtonColor(),
          ),
          sizedBox,
          FloatingActionButton.extended(
            onPressed: () async {
              await GeolocatorPlatform.instance.getCurrentPosition().then(
                  (value) => {
                        _positionItems.add(_PositionItem(
                            _PositionItemType.position, value.toString()))
                      });

              setState(
                () {},
              );
            },
            label: Text("Current Position"),
          ),
          sizedBox,
          FloatingActionButton.extended(
            onPressed: () async {
              await GeolocatorPlatform.instance
                  .requestPermission()
                  .then((value) => {
                        _positionItems.add(_PositionItem(
                            _PositionItemType.permission, value.toString()))
                      });
              setState(() {});
            },
            label: Text("Request Permission"),
          ),
          sizedBox,
          FloatingActionButton.extended(
            onPressed: () async {
              await GeolocatorPlatform.instance
                  .checkPermission()
                  .then((value) => {
                        _positionItems.add(_PositionItem(
                            _PositionItemType.permission, value.toString()))
                      });
              setState(() {});
            },
            label: Text("Check Permission"),
          ),
          sizedBox,
          FloatingActionButton.extended(
            onPressed: () => setState(_positionItems.clear),
            label: Text("clear"),
          ),
        ],
      ),
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = GeolocatorPlatform.instance.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => setState(() => _positionItems.add(
          _PositionItem(_PositionItemType.position, position.toString()))));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }
}

enum _PositionItemType {
  permission,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
