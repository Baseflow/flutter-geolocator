#ifndef PACKAGES_GEOLOCATOR_GEOLOCATOR_WINDOWS_WINDOWS_INCLUDE_GEOLOCATOR_WINDOWS_GEOLOCATOR_plugin_H_
#define PACKAGES_GEOLOCATOR_GEOLOCATOR_WINDOWS_WINDOWS_INCLUDE_GEOLOCATOR_WINDOWS_GEOLOCATOR_plugin_H_

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void GeolocatorWindowsRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // PACKAGES_GEOLOCATOR_GEOLOCATOR_WINDOWS_WINDOWS_INCLUDE_GEOLOCATOR_WINDOWS_GEOLOCATOR_plugin_H_
