import '../enums/enums.dart';

/// Provides extension methods on the LocationAccuracy enum.
extension LocationAccuracyExtensions on LocationAccuracy {
  /// Returns the value as string of the LocationAccuracy enum
  String toShortString() {
    // ignore: unnecessary_this
    return this.toString().split('.').last;
  }
}