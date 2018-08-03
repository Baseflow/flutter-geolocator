import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LookupCoordinatesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LookupCoordinatesState();
}

class _LookupCoordinatesState extends State<LookupCoordinatesWidget> {
  final Geolocator _geolocator = Geolocator();
  final TextEditingController _coordinatesTextController =
      TextEditingController();

  String _placemark = '';

  void _onLookupAddressPressed() async {
    var coords = _coordinatesTextController.text.split(',');
    var latitude = double.parse(coords[0]);
    var longitude = double.parse(coords[1]);
    List<Placemark> placemarks =
        await _geolocator.placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.length >= 1) {
      var pos = placemarks[0];
      setState(() {
        _placemark = pos.thoroughfare + ", " + pos.locality;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextField(
          decoration: new InputDecoration(hintText: "latitude,longitude"),
          controller: _coordinatesTextController,
        ),
        new RaisedButton(
          child: new Text('Look up...'),
          onPressed: () {
            _onLookupAddressPressed();
          },
        ),
        new Text(_placemark),
      ],
    );
  }
}
