import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../common_widgets/placeholder_widget.dart';

class RequestLocationSettingsWidget extends StatefulWidget {
  const RequestLocationSettingsWidget({
    Key key,
  }) : super(key: key);

  @override
  _RequestLocationSettingsState createState() =>
      _RequestLocationSettingsState();
}

class _RequestLocationSettingsState
    extends State<RequestLocationSettingsWidget> {
  bool result = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: RaisedButton(
              child: Text('Request location settings change'),
              onPressed: () async {
                result = await Geolocator().requestLocationSettingsChange();
                setState(() {});
              },
            ),
          ),
          PlaceholderWidget('Status: ', result.toString()),
        ],
      ),
    );
  }
}
