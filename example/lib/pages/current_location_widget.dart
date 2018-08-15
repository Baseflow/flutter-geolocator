import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../common_widgets/placeholder_widget.dart';

class CurrentLocationWidget extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  Position _position;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      position = await Geolocator()
          .getCurrentPosition(LocationAccuracy.bestForNavigation);
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
    return FutureBuilder(
        future: Geolocator.checkGeolocationStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return PlaceholderWidget("Location services disabled",
                "Enable location services for this App using the device settings.");
          }

          return PlaceholderWidget("Current location:", _position.toString());
        });
  }
}
