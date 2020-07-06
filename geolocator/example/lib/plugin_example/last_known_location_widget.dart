import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_example/plugin_example/widgets/info_widget.dart';

/// A widget that will request and display the last known
/// location stored on the device.
class LastKnownLocationWidget extends StatefulWidget {
  @override
  _LastKnownLocationWidgetState createState() =>
      _LastKnownLocationWidgetState();
}

class _LastKnownLocationWidgetState extends State<LastKnownLocationWidget> {
  Position _lastKnownPosition;
  LocationPermission _locationPermission;
  bool _shouldRequestPermission;

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
      _locationPermission = null;
      _shouldRequestPermission = null;
    });

    _initLastKnownLocation();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    LocationPermission permission;
    bool shouldRequestPermission;

    try {
      permission = await checkPermission();
      shouldRequestPermission = permission == LocationPermission.denied;
    } on Exception {
      permission = null;
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      try {
        position = await getLastKnownLocation();
      } on Exception {
        position = null;
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _locationPermission = permission;
      _lastKnownPosition = position;
      _shouldRequestPermission = shouldRequestPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasPermission = _locationPermission != null &&
        _locationPermission != LocationPermission.denied &&
        _locationPermission != LocationPermission.deniedForever;

    if (_locationPermission == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasPermission) {
      final message = _shouldRequestPermission
          ? 'Request permission by hitting the button below.'
          : 'Allow access to the location services for this App using the device settings.';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InfoWidget(
            'Access to location denied',
            message,
          ),
          _shouldRequestPermission
              ? RaisedButton(
                  child: const Text('Request permission'),
                  onPressed: () => requestPermission()
                      .then((status) => _initLastKnownLocation()),
                )
              : Container(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InfoWidget('Last known location:', _lastKnownPosition.toString()),
      ],
    );
  }
}
