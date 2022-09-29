#ifndef FLUTTER_PLUGIN_GEOLOCATOR_LINUX_PLUGIN_H_
#define FLUTTER_PLUGIN_GEOLOCATOR_LINUX_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _GeolocatorLinuxPlugin GeolocatorLinuxPlugin;
typedef struct {
  GObjectClass parent_class;
} GeolocatorLinuxPluginClass;

FLUTTER_PLUGIN_EXPORT GType geolocator_linux_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void geolocator_linux_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

// gboolean openLocationPanel() {

#endif  // FLUTTER_PLUGIN_GEOLOCATOR_LINUX_PLUGIN_H_
