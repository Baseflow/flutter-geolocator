import 'package:flutter/material.dart';

/// A widget that will display a title and a message.
class InfoWidget extends StatelessWidget {
  /// Initialized the widget with a [title] and [message].
  const InfoWidget(this.title, this.message);

  /// The [title] that is displayed by this widget.
  final String title;

  /// The [message] that is displayed by this widget.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: const TextStyle(fontSize: 32.0, color: Colors.white),
              textAlign: TextAlign.center),
          Text(message,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
