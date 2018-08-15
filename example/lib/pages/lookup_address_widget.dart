import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LookupAddressWidget extends StatefulWidget {
  @override
  _LookupAddressState createState() => _LookupAddressState();
}

class _LookupAddressState extends State<LookupAddressWidget> {
  final Geolocator _geolocator = Geolocator();
  final TextEditingController _addressTextController = TextEditingController();

  String _placemarkCoords = '';

  void _onLookupCoordinatesPressed() async {
    List<Placemark> placemarks =
        await _geolocator.placemarkFromAddress(_addressTextController.text);

    if (placemarks != null && placemarks.length >= 1) {
      var pos = placemarks[0];
      setState(() {
        _placemarkCoords = pos.position.latitude.toString() +
            ', ' +
            pos.position.longitude.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextField(
          decoration: new InputDecoration(hintText: "Please enter an address"),
          controller: _addressTextController,
        ),
        new RaisedButton(
          child: new Text('Look up...'),
          onPressed: () {
            _onLookupCoordinatesPressed();
          },
        ),
        new Text(_placemarkCoords),
      ],
    );
  }
}
