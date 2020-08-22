import '../enums/enums.dart';
import '../errors/errors.dart';

/// Provides extension methods on the LocationAccuracy enum.
extension IntergerExtensions on int {
  /// Tries to convert the int value to a LocationPermission enum value.
  ///
  /// Throws an InvalidPermissionException if the int value cannot be
  /// converted to a LocationPermission.
  LocationPermission toLocationPermission() {
    switch (this) {
      case 0:
        return LocationPermission.denied;
      case 1:
        return LocationPermission.deniedForever;
      case 2:
        return LocationPermission.whileInUse;
      case 3:
        return LocationPermission.always;
      default:
        throw InvalidPermissionException(this);
    }
  }
}
