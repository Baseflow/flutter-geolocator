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

  Future<void> _onLookupCoordinatesPressed() async {
    final List<Placemark> placemarks =
        await _geolocator.placemarkFromAddress(_addressTextController.text);

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
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
        TextField(
          decoration:
              const InputDecoration(hintText: 'Please enter an address'),
          controller: _addressTextController,
        ),
        RaisedButton(
          child: const Text('Look up...'),
          onPressed: () {
            _onLookupCoordinatesPressed();
          },
        ),
        Text(_placemarkCoords),
      ],
    );
  }
}
