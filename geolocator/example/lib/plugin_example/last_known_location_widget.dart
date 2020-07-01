import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_example/plugin_example/widgets/info_widget.dart';

/// A widget that will request and display the last known
/// location stored on the device.
class LastKnownLocationWidget extends StatefulWidget {
  @override
  _LastKnownLocationWidgetState createState() => _LastKnownLocationWidgetState();
}

class _LastKnownLocationWidgetState extends State<LastKnownLocationWidget> {
  Position _lastKnownPosition;

  @override
  void initState() {
    super.initState();

    _initLastKnownLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
    });

    _initLastKnownLocation();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      position = await getLastKnownLocation();
    } on PlatformException catch (ex) {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationPermission>(
        future: checkPermissions(),
        builder:
            (BuildContext context, AsyncSnapshot<LocationPermission> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == LocationPermission.denied) {
            return const InfoWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InfoWidget(
                    'Last known location:', _lastKnownPosition.toString()),
              ],
            ),
          );
        });
  }
}
