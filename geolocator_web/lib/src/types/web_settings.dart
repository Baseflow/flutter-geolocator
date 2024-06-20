import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Represents different Web specific settings with which you can set a value
/// other then the default value of the setting.
class WebSettings extends LocationSettings {
  /// Initializes a new [WebSpecificSettings] instance with default values.
  WebSettings({
    super.accuracy,
    super.distanceFilter,
    this.maximumAge = Duration.zero,
    super.timeLimit,
  });

  /// A value indicating the maximum age of a possible cached position that is acceptable to return.
  /// If set to 0, it means that the device cannot use a cached position and must attempt to retrieve the real current position.
  /// Default: 0
  final Duration maximumAge;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'maximumAge': maximumAge,
      });
  }
}
