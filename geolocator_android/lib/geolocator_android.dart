export 'package:geolocator_platform_interface/geolocator_platform_interface.dart'
    show
        ActivityMissingException,
        AlreadySubscribedException,
        InvalidPermissionException,
        LocationAccuracy,
        LocationAccuracyStatus,
        LocationPermission,
        LocationServiceDisabledException,
        LocationSettings,
        PermissionDefinitionsNotFoundException,
        PermissionDeniedException,
        PermissionRequestInProgressException,
        Position,
        PositionUpdateException,
        ServiceStatus;

export 'src/geolocator_android.dart';
export 'src/types/android_settings.dart' show AndroidSettings;
export 'src/types/foreground_settings.dart'
    show AndroidResource, ForegroundNotificationConfig;
