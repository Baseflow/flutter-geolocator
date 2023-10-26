namespace geolocator_plugin {

enum ErrorCode {
    PermissionDefinitionsNotFound,
    OperationCanceled,
    UnknownError
};

enum LocationPermission {
  Denied,
  DeniedForever,
  WhileInUse,
  Always,
  UnableToDetermine
};

enum LocationAccuracyStatus {
  Reduced,
  Precise
};

enum LocationAccuracy {
  Lowest,
  Low,
  Medium,
  High,
  Best,
  BestForNavigation
};

enum ServiceStatus {
  Disabled,
  Enabled
};

}  // namespace geolocator_plugin
