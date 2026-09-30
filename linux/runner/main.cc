#include "my_application.h"

#include <stdlib.h>

int main(int argc, char** argv) {
  // WebKitGTK + Flutter share one process tree. These must be set before any
  // WebKitWebProcess is forked (YouTube MSE/GStreamer otherwise fights Flutter
  // GL and aborts the app).
  setenv("WEBKIT_DISABLE_COMPOSITING_MODE", "1", 1);
  setenv("WEBKIT_DISABLE_DMABUF_RENDERER", "1", 1);
  // Prefer CPU decode / non-GL sinks inside WebKit's GStreamer pipeline.
  setenv("GST_PLUGIN_FEATURE_RANK",
         "avdec_av1:NONE;glimagesink:NONE;gtkglsink:NONE;"
         "glcolorconvert:NONE;glupload:NONE;gldownload:NONE",
         1);

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
