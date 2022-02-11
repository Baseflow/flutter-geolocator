#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_channel.h>
#include <flutter/event_stream_handler.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/encodable_value.h>
#include <windows.h>

#include <memory>
#include <optional>
#include <sstream>
#include <map>
#include <string>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Devices.Geolocation.h>
#include "geolocator_enums.h"

namespace geolocator_plugin {

class GeolocatorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar* registrar);

  GeolocatorPlugin();

  virtual ~GeolocatorPlugin();

  // Disallow copy and move.
  GeolocatorPlugin(const GeolocatorPlugin&) = delete;
  GeolocatorPlugin& operator=(const GeolocatorPlugin&) = delete;

  // Called when a method is called on the plugin channel.
  void HandleMethodCall(const flutter::MethodCall<>&,
                        std::unique_ptr<flutter::MethodResult<>>);

 private:
  void OnCheckPermission(std::unique_ptr<flutter::MethodResult<>>);
  void OnIsLocationServiceEnabled(std::unique_ptr<flutter::MethodResult<>>);
  void OnRequestPermission(std::unique_ptr<flutter::MethodResult<>>);
  winrt::fire_and_forget OnGetLastKnownPosition(const flutter::MethodCall<>&,
                        std::unique_ptr<flutter::MethodResult<>>);
  void GetLocationAccuracy(std::unique_ptr<flutter::MethodResult<>>);
  winrt::fire_and_forget OnGetCurrentPosition(const flutter::MethodCall<>&,
                        std::unique_ptr<flutter::MethodResult<>>);

  winrt::fire_and_forget RequestAccessAsync(std::unique_ptr<flutter::MethodResult<>>);
  void OpenPrivacyLocationSettings(std::unique_ptr<flutter::MethodResult<>>);

  winrt::Windows::Devices::Geolocation::Geolocator::PositionChanged_revoker m_positionChangedRevoker;

  std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnListen(
      const flutter::EncodableValue* arguments,
      std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events);
  std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnCancel(
      const flutter::EncodableValue* arguments);

  winrt::Windows::Devices::Geolocation::Geolocator::StatusChanged_revoker m_statusChangedRevoker;

  std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnServiceListen(
      const flutter::EncodableValue* arguments,
      std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events);
  std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnServiceCancel(
      const flutter::EncodableValue* arguments);

  static flutter::EncodableMap LocationToEncodableMap(winrt::Windows::Devices::Geolocation::Geoposition const&);

  winrt::Windows::Devices::Geolocation::Geolocator geolocator;
  winrt::Windows::Devices::Geolocation::Geolocator statusGeolocator;

  winrt::Windows::Devices::Geolocation::PositionStatus m_currentStatus;
};

}  // namespace geolocator_plugin
