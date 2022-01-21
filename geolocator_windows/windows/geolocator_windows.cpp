#include "include/geolocator_windows/geolocator_windows.h"

#include <flutter/plugin_registrar_windows.h>

#include "geolocator_plugin.h"

void GeolocatorWindowsRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  geolocator_plugin::GeolocatorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
