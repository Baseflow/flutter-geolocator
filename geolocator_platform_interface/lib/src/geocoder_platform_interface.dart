import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'implementations/method_channel_geocoder.dart';
import 'models/models.dart';

/// The interface that implementations of geocoder  must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `geocoder` does not consider newly added methods to be breaking 
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added 
/// [GeocoderPlatform] methods.
abstract class GeocoderPlatform extends PlatformInterface {
  /// Constructs a [GeocoderPlatform].
  GeocoderPlatform() : super(token: _token);

  static final Object _token = Object();

  static GeocoderPlatform _instance = MethodChannelGeocoder();

  /// The default instance of [GeocoderPlatform] to use.
  ///
  /// Defaults to [MethodChannelGeocoder].
  static GeocoderPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own
  /// platform-specific class that extends [GeocoderPlatform] when they
  /// register themselves.
  static set instance(GeocoderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns a list of [Placemark] instances found for the supplied address.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied address could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be
  /// returned.
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The `localeIdentifier` should be formatted using the syntax: 
  /// [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromAddress(
    String address, {
    String localeIdentifier,
  }) {
    throw UnimplementedError(
        'placemarkFromAddress() has not been implementated.');
  }

  /// Returns a list of [Placemark] instances found for the supplied
  /// coordinates.
  ///
  /// In most situations the returned list should only contain one entry.
  /// However in some situations where the supplied coordinates could not be
  /// resolved into a single [Placemark], multiple [Placemark] instances may be
  /// returned.
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The `localeIdentifier` should be formatted using the syntax: 
  /// [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String localeIdentifier,
  }) {
    throw UnimplementedError(
        'placemarkFromCoordinates() has not been implementated.');
  }

  /// Convenience method to access [placemarkFromCoordinates()] using an
  /// instance of [Position].
  ///
  /// Optionally you can specify a locale in which the results are returned.
  /// When not supplied the currently active locale of the device will be used.
  /// The `localeIdentifier` should be formatted using the syntax: 
  /// [languageCode]_[countryCode] (eg. en_US or nl_NL).
  Future<List<Placemark>> placemarkFromPosition(
    Position position, {
    String localeIdentifier,
  }) =>
      placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: localeIdentifier,
      );
}
