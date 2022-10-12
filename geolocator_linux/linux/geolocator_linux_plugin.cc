#include "include/geolocator_linux/geolocator_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>
#include <cstring>
#include <gio/gio.h>
#include <gio/gdesktopappinfo.h>

#define GEOLOCATOR_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), geolocator_linux_plugin_get_type(), \
                              GeolocatorLinuxPlugin))

struct _GeolocatorLinuxPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(GeolocatorLinuxPlugin, geolocator_linux_plugin, g_object_get_type())

static gboolean openLocationPanel() {
  GDesktopAppInfo *appinfo;
  GdkDisplay *display;
  GError *error = NULL;
  GdkAppLaunchContext *context;
  char locationPanel[] =  "gnome-location-panel.desktop";
  

  if (g_getenv ("DISPLAY") == NULL || g_getenv ("DISPLAY")[0] == '\0')
    {
      printf ("No DISPLAY available.");
      return FALSE;
    }

  appinfo = g_desktop_app_info_new (locationPanel);

  if (appinfo == NULL)
    {
      printf ("Gnome Location Panel not available.");
      return FALSE;
    }

  display = gdk_display_get_default();
  context = gdk_display_get_app_launch_context(display);

  return g_app_info_launch((GAppInfo *)appinfo, NULL, (GAppLaunchContext *)context, &error);
}

static void geolocator_linux_plugin_handle_method_call(
    GeolocatorLinuxPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "openGnomeLocationPanel") == 0) {
    gboolean openLocationPanelResult = openLocationPanel();
    g_autoptr(FlValue) result = fl_value_new_bool(openLocationPanelResult);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void geolocator_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(geolocator_linux_plugin_parent_class)->dispose(object);
}

static void geolocator_linux_plugin_class_init(GeolocatorLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = geolocator_linux_plugin_dispose;
}

static void geolocator_linux_plugin_init(GeolocatorLinuxPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  GeolocatorLinuxPlugin* plugin = GEOLOCATOR_LINUX_PLUGIN(user_data);
  geolocator_linux_plugin_handle_method_call(plugin, method_call);
}

void geolocator_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  GeolocatorLinuxPlugin* plugin = GEOLOCATOR_LINUX_PLUGIN(
      g_object_new(geolocator_linux_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "geolocator_linux",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}