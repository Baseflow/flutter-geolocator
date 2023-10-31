#include "geolocator_plugin.h"

namespace geolocator_plugin {

using namespace flutter;
using namespace winrt;
using namespace winrt::Windows::Devices::Geolocation;

namespace {

template<typename T>
T GetArgument(const std::string arg, const EncodableValue* args, T fallback) {
  T result {fallback};
  const auto* arguments = std::get_if<EncodableMap>(args);
  if (arguments) {
    auto result_it = arguments->find(EncodableValue(arg));
    if (result_it != arguments->end()) {
      result = std::get<T>(result_it->second);
    }
  }
  return result;
}

std::string ErrorCodeToString(ErrorCode errorCode) {
  switch (errorCode) {
    case ErrorCode::PermissionDefinitionsNotFound:
      return "PERMISSION_DEFINITIONS_NOT_FOUND";
    case ErrorCode::OperationCanceled:
      return "OPERATION_CANCELED";
    case ErrorCode::UnknownError:
      return "UNKNOWN_ERROR";
    default:
      throw std::logic_error("unexcepted value" + static_cast<int>(errorCode));
  }
}

}  // namespace

// static
void GeolocatorPlugin::RegisterWithRegistrar(
    PluginRegistrar* registrar) {

  auto channel = std::make_unique<MethodChannel<>>(
    registrar->messenger(), "flutter.baseflow.com/geolocator",
    &StandardMethodCodec::GetInstance());

  auto geolocatorStreamChannel = std::make_unique<EventChannel<EncodableValue>>(
    registrar->messenger(), "flutter.baseflow.com/geolocator_updates",
    &StandardMethodCodec::GetInstance());

  auto geolocatorServiceStreamChannel = std::make_unique<EventChannel<EncodableValue>>(
    registrar->messenger(), "flutter.baseflow.com/geolocator_service_updates",
    &StandardMethodCodec::GetInstance());

  std::unique_ptr<GeolocatorPlugin> plugin = std::make_unique<GeolocatorPlugin>();

  auto geolocatorHandler = std::make_unique<
    StreamHandlerFunctions<EncodableValue>>(
    [plugin_pointer = plugin.get()](
        const EncodableValue* arguments,
        std::unique_ptr<EventSink<EncodableValue>>&& events)
        -> std::unique_ptr<StreamHandlerError<EncodableValue>> {
      return plugin_pointer->OnListen(arguments, std::move(events));
    },
    [plugin_pointer = plugin.get()](const EncodableValue* arguments)
        -> std::unique_ptr<StreamHandlerError<EncodableValue>> {
      return plugin_pointer->OnCancel(arguments);
    });

  geolocatorStreamChannel->SetStreamHandler(std::move(geolocatorHandler));

  auto geolocatorServiceHandler = std::make_unique<
    StreamHandlerFunctions<EncodableValue>>(
    [plugin_pointer = plugin.get()](
        const EncodableValue* arguments,
        std::unique_ptr<EventSink<EncodableValue>>&& events)
        -> std::unique_ptr<StreamHandlerError<EncodableValue>> {
      return plugin_pointer->OnServiceListen(arguments, std::move(events));
    },
    [plugin_pointer = plugin.get()](const EncodableValue* arguments)
        -> std::unique_ptr<StreamHandlerError<EncodableValue>> {
      return plugin_pointer->OnServiceCancel(arguments);
    });

  geolocatorServiceStreamChannel->SetStreamHandler(std::move(geolocatorServiceHandler));

  channel->SetMethodCallHandler(
    [plugin_pointer = plugin.get()](const auto& call, auto result) {
      plugin_pointer->HandleMethodCall(call, std::move(result));
    });

  registrar->AddPlugin(std::move(plugin));
}

GeolocatorPlugin::GeolocatorPlugin(){}

GeolocatorPlugin::~GeolocatorPlugin() = default;

void GeolocatorPlugin::HandleMethodCall(
    const MethodCall<>& method_call,
    std::unique_ptr<MethodResult<>> result) {
  
  auto methodName = method_call.method_name();
  if (methodName.compare("checkPermission") == 0) {
    OnCheckPermission(std::move(result));
  } else if (methodName.compare("isLocationServiceEnabled") == 0) {
    OnIsLocationServiceEnabled(std::move(result));
  } else if (methodName.compare("requestPermission") == 0) {
    OnRequestPermission(std::move(result));
  } else if (methodName.compare("getLastKnownPosition") == 0) {
    OnGetLastKnownPosition(method_call, std::move(result));
  } else if (methodName.compare("getLocationAccuracy") == 0) {
    GetLocationAccuracy(std::move(result));
  } else if (methodName.compare("getCurrentPosition") == 0) {
    OnGetCurrentPosition(method_call, std::move(result));
  } else if (methodName.compare("openAppSettings") == 0
          || methodName.compare("openLocationSettings") == 0) {
    OpenPrivacyLocationSettings(std::move(result));
  } else {
    result->NotImplemented();
  }
}

void GeolocatorPlugin::OpenPrivacyLocationSettings(std::unique_ptr<MethodResult<>> result) {
  std::wstring url {L"ms-settings:privacy-location"};

  int status = static_cast<int>(reinterpret_cast<INT_PTR>(
    ::ShellExecuteW(nullptr, TEXT("open"), url.c_str(), 
    nullptr, nullptr, SW_SHOWNORMAL)));

  // Per ::ShellExecuteW documentation, anything >32 indicates success.
  result->Success(status > 32);
}

winrt::fire_and_forget GeolocatorPlugin::RequestAccessAsync(std::unique_ptr<MethodResult<>> result) {
  try {
    auto access = co_await geolocator.RequestAccessAsync();
    if(access == GeolocationAccessStatus::Allowed)
      result->Success(EncodableValue((int)LocationPermission::WhileInUse));
    else if(access == GeolocationAccessStatus::Denied)
      result->Success(EncodableValue((int)LocationPermission::Denied));
    else if(access == GeolocationAccessStatus::Unspecified)
      result->Success(EncodableValue((int)LocationPermission::DeniedForever));
  } catch(const std::exception& ex) {
    result->Error(ErrorCodeToString(ErrorCode::PermissionDefinitionsNotFound), ex.what());
  }
}

void GeolocatorPlugin::OnCheckPermission(std::unique_ptr<MethodResult<>> result) {
  RequestAccessAsync(std::move(result));
}

bool isLocationStatusValid (const PositionStatus& status) {
    return status != PositionStatus::Disabled 
        && status != PositionStatus::NotAvailable;
}

void GeolocatorPlugin::OnIsLocationServiceEnabled(std::unique_ptr<MethodResult<>> result) {
    result->Success(EncodableValue(isLocationStatusValid(geolocator.LocationStatus())));
}

void GeolocatorPlugin::OnRequestPermission(std::unique_ptr<MethodResult<>> result) {
  RequestAccessAsync(std::move(result));
}

winrt::fire_and_forget GeolocatorPlugin::OnGetLastKnownPosition(const MethodCall<>& method_call,
  std::unique_ptr<MethodResult<>> result) {
    try {
        auto location = co_await geolocator.GetGeopositionAsync(std::chrono::hours(1), std::chrono::milliseconds::zero());
        result->Success(LocationToEncodableMap(location));
    }
    catch (hresult_canceled const& error) {
        result->Error(ErrorCodeToString(ErrorCode::OperationCanceled), 
            to_string(error.message()));
    }
    catch (hresult_error const& error) {
        result->Error(ErrorCodeToString(ErrorCode::UnknownError), 
            to_string(error.message()));
    }
}

void GeolocatorPlugin::GetLocationAccuracy(std::unique_ptr<MethodResult<>> result) {
  result->Success(EncodableValue((int)(
    geolocator.DesiredAccuracy() == PositionAccuracy::High
      ? LocationAccuracyStatus::Precise
      : LocationAccuracyStatus::Reduced)));
}

winrt::fire_and_forget GeolocatorPlugin::OnGetCurrentPosition(const MethodCall<>& method_call,
  std::unique_ptr<MethodResult<>> result) {
    try {
        auto location = co_await geolocator.GetGeopositionAsync();
        result->Success(LocationToEncodableMap(location));
    }
    catch (hresult_canceled const& error) {
        result->Error(ErrorCodeToString(ErrorCode::OperationCanceled), 
            to_string(error.message()));
    }
    catch (hresult_error const& error) {
        result->Error(ErrorCodeToString(ErrorCode::UnknownError), 
            to_string(error.message()));
    }
}

std::unique_ptr<StreamHandlerError<EncodableValue>> GeolocatorPlugin::OnListen(
  const EncodableValue* arguments,
  std::unique_ptr<EventSink<EncodableValue>>&& events){

  auto accuracy = LocationAccuracy::Best;
  long distanceFilter = 0;
  long timeInterval = 1;

  if (arguments != nullptr) {
    accuracy = (LocationAccuracy)GetArgument<int>("accuracy", arguments, accuracy);
    distanceFilter = GetArgument<int>("distanceFilter", arguments, distanceFilter);
    timeInterval = GetArgument<int>("timeInterval", arguments, timeInterval);
  }

  m_positionChangedRevoker.revoke();

  geolocator.DesiredAccuracy(accuracy < LocationAccuracy::Medium
    ? PositionAccuracy::Default
    : PositionAccuracy::High);
  geolocator.MovementThreshold(distanceFilter);
  geolocator.ReportInterval(timeInterval);

  m_positionChangedRevoker = geolocator.PositionChanged(winrt::auto_revoke,
    [events = std::move(events)](Geolocator const& geolocator, PositionChangedEventArgs e)
    {
        events->Success(LocationToEncodableMap(e.Position()));
    });

  return nullptr;
}

std::unique_ptr<StreamHandlerError<EncodableValue>> GeolocatorPlugin::OnCancel(const EncodableValue* arguments){
  m_positionChangedRevoker.revoke();
  return nullptr;
}

std::unique_ptr<StreamHandlerError<EncodableValue>> GeolocatorPlugin::OnServiceListen(
  const EncodableValue* arguments,
  std::unique_ptr<EventSink<EncodableValue>>&& events){

  m_currentStatus = statusGeolocator.LocationStatus();
  if (m_currentStatus != PositionStatus::Disabled) {
    m_currentStatus = PositionStatus::Ready;
  }

  m_statusChangedRevoker = statusGeolocator.StatusChanged(winrt::auto_revoke,
    [events = std::move(events), this](Geolocator const& geolocator, StatusChangedEventArgs e)
    {
      if (m_currentStatus != PositionStatus::Disabled && e.Status() == PositionStatus::Disabled
        || m_currentStatus != PositionStatus::Ready && e.Status() == PositionStatus::Ready
        || m_currentStatus != PositionStatus::Initializing && e.Status() == PositionStatus::Initializing ) {
        auto status = e.Status() == PositionStatus::NotAvailable
          ? ServiceStatus::Disabled
          : ServiceStatus::Enabled;
        events->Success(EncodableValue((int)status));
        m_currentStatus = e.Status();
      }
    });

  return nullptr;
}

std::unique_ptr<StreamHandlerError<EncodableValue>> GeolocatorPlugin::OnServiceCancel(const EncodableValue* arguments){
  m_statusChangedRevoker.revoke();
  return nullptr;
}

EncodableMap GeolocatorPlugin::LocationToEncodableMap(Geoposition const& location) {
  if (location == nullptr) {
    return EncodableMap();
  }

  auto position = EncodableMap();

  position.insert(std::make_pair(EncodableValue("latitude"), EncodableValue(location.Coordinate().Latitude())));
  position.insert(std::make_pair(EncodableValue("longitude"), EncodableValue(location.Coordinate().Longitude())));
  position.insert(std::make_pair(EncodableValue("timestamp"), EncodableValue(clock::to_time_t(location.Coordinate().Timestamp()))));

  double altitude = location.Coordinate().Altitude() != nullptr && !std::isnan(location.Coordinate().Altitude().GetDouble())
    ? location.Coordinate().Altitude().GetDouble()
    : 0;
  position.insert(std::make_pair(EncodableValue("altitude"), EncodableValue(altitude)));
  
  double altitudeAccuracy = location.Coordinate().AltitudeAccuracy() != nullptr && !std::isnan(location.Coordinate().AltitudeAccuracy().GetDouble())
    ? location.Coordinate().AltitudeAccuracy().GetDouble()
    : 0;
  position.insert(std::make_pair(EncodableValue("altitude_accuracy"), EncodableValue(altitudeAccuracy)));
  
  position.insert(std::make_pair(EncodableValue("accuracy"), EncodableValue(location.Coordinate().Accuracy())));
  
  double heading = location.Coordinate().Heading() != nullptr && !std::isnan(location.Coordinate().Heading().GetDouble())
    ? location.Coordinate().Heading().GetDouble()
    : 0;
  position.insert(std::make_pair(EncodableValue("heading"), EncodableValue(heading)));
  
  double speed = location.Coordinate().Speed() != nullptr && !std::isnan(location.Coordinate().Speed().GetDouble())
    ? location.Coordinate().Speed().GetDouble()
    : 0;
  position.insert(std::make_pair(EncodableValue("speed"), EncodableValue(speed)));

  position.insert(std::make_pair(EncodableValue("is_mocked"), EncodableValue(false)));

  return position;
}

}  // namespace geolocator_plugin
