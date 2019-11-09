import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LookupAddressWidget extends StatefulWidget {
  @override
  _LookupAddressState createState() => _LookupAddressState();
}

class _LookupAddressState extends State<LookupAddressWidget> {
  final Geolocator _geolocator = Geolocator();
  final TextEditingController _addressTextController = TextEditingController();

  List<String> _placemarkCoords = [];

  Future<void> _onLookupCoordinatesPressed(BuildContext context) async {
    final List<Placemark> placemarks = await Future(
            () => _geolocator.placemarkFromAddress(_addressTextController.text))
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(onError.toString()),
      ));
      return Future.value(List<Placemark>());
    });

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      final List<String> coords = placemarks
          .map((placemark) =>
              pos.position?.latitude.toString() +
              ', ' +
              pos.position?.longitude.toString())
          .toList();
      setState(() {
        _placemarkCoords = coords;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            decoration:
                const InputDecoration(hintText: 'Please enter an address'),
            controller: _addressTextController,
          ),
          RaisedButton(
            child: const Text('Look up...'),
            onPressed: () {
              _onLookupCoordinatesPressed(context);
            },
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _placemarkCoords.length,
              itemBuilder: (context, index) => Text(_placemarkCoords[index]),
            ),
          )
        ],
      ),
    );
  }
}
