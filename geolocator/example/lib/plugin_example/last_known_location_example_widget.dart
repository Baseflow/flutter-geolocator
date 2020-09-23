import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'widgets/info_widget.dart';

/// A widget that will request and display the last known
/// location stored on the device.
class LastKnownLocationExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Geolocator.getLastKnownPosition(),
      builder: (context, snapshot) {
        List<Widget> children;

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: InfoWidget('Error', snapshot.error.toString()),
              )
            ];
          } else {
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: InfoWidget(
                  'Last known position:',
                  snapshot.data.toString(),
                ),
              ),
            ];
          }
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        );
      },
    );
  }
}
