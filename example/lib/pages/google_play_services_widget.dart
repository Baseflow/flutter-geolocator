import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../common_widgets/placeholder_widget.dart';

class GooglePlayServicesWidget extends StatefulWidget {
  @override
  _GooglePlayServicesState createState() => _GooglePlayServicesState();
}

class _GooglePlayServicesState extends State<GooglePlayServicesWidget> {
  GooglePlayServicesAvailability _availability;

  @override
  void initState() {
    super.initState();

    _initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    GooglePlayServicesAvailability availability;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      availability = await Geolocator().checkGooglePlayServicesAvailability();
    } on PlatformException {
      availability = GooglePlayServicesAvailability.unknown;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _availability = availability;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderWidget("Google Play Services availability:\n",
        _availability.toString().split('.').last);
  }
}
