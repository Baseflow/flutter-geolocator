import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart';

/// The widget which defines the info page.
class InfoPage extends StatefulWidget {
  /// Constructs the [InfoPage] widget
  InfoPage({Key key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            Globals.defaultHorizontalPadding + Globals.defaultVerticalPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'res/images/poweredByBaseflowLogoLight@3x.png',
                width: 250,
                alignment: Alignment.centerLeft,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
            ),
            Text(
              'This app showcases the possibilities of the ${Globals.pluginName} plugin, powered by Baseflow. '
              'This plugin is available as open source project on Github. \n\n'
              'Need help with integrading functionalities within your own apps? Contact us at hello@baseflow.com',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            _launcherRaisedButton('Find us on Github', Globals.githubURL),
            _launcherRaisedButton('Find us on pub.dev', Globals.pubDevURL),
            _launcherRaisedButton('Visit baseflow.com', Globals.baseflowURL),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _launcherRaisedButton(String text, String url) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.only(top: 24.0),
      alignment: Alignment.center,
      child: SizedBox.expand(
        child: RaisedButton(
          textTheme: Theme.of(context).buttonTheme.textTheme,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.all(8),
          child: Text(text),
          onPressed: () => _launchURL(url),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
