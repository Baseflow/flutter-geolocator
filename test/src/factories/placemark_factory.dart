import 'package:geolocator/geolocator.dart';

import 'position_factory.dart';

class PlacemarkFactory {
  static Placemark createMockPlacemark() {
    return Placemark(
        administrativeArea: 'Overijssel',
        country: 'Netherlands',
        isoCountryCode: 'NL',
        locality: 'Enschede',
        name: 'Gronausestraat',
        position: PositionFactory.createMockPosition(),
        postalCode: '',
        subAdministrativeArea: 'Enschede',
        subLocality: 'Enschmarke',
        subThoroughfare: '',
        thoroughfare: 'Gronausestraat');
  }
}
