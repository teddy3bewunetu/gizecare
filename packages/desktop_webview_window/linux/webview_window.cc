//
// Created by boyan on 10/21/21.
//

#include "webview_window.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <utility>
#include "message_channel_plugin.h"
#include <string>
#include <unordered_map>

#if WEBKIT_MAJOR_VERSION < 2 || \
    (WEBKIT_MAJOR_VERSION == 2 && WEBKIT_MINOR_VERSION < 40)
#define WEBKIT_OLD_USED
#endif

static void webkit_breadcrumb(const char *msg) {
  FILE *f = fopen("/tmp/gizecare-webview.log", "a");
  if (f != nullptr) {
    fprintf(f, "%lld %s\n", static_cast<long long>(g_get_monotonic_time()),
            msg != nullptr ? msg : "(null)");
    fflush(f);
    fclose(f);
  }
  fprintf(stderr, "[gizecare-webview] %s\n", msg != nullptr ? msg : "(null)");
  fflush(stderr);
}

void get_cookies_callback(WebKitCookieManager *manager, GAsyncResult *res,
                          gpointer user_data) {
  CookieData *data = (CookieData *)user_data;
  GError *error = NULL;

  GList *cookies =
      webkit_cookie_manager_get_cookies_finish(manager, res, &error);
  if (error != NULL) {
    g_print("Error getting cookies: %s\n", error->message);
    g_error_free(error);
    data->cookies = NULL;
  } else {
    data->cookies = cookies;
  }

  g_main_loop_quit(data->loop);
}

GList *get_cookies_sync(WebKitWebView *web_view) {
  WebKitCookieManager *cookie_manager;
  GMainLoop *loop;
  CookieData data = {0};

  cookie_manager = webkit_web_context_get_cookie_manager(
      webkit_web_view_get_context(web_view));
  loop = g_main_loop_new(NULL, FALSE);
  data.loop = loop;

  const gchar *uri = webkit_web_view_get_uri(web_view);

  // Start the asynchronous operation
  webkit_cookie_manager_get_cookies(cookie_manager, uri, NULL,
                                    (GAsyncReadyCallback)get_cookies_callback,
                                    &data);

  // Run the main loop until the callback is called
  g_main_loop_run(loop);

  g_main_loop_unref(loop);

  return data.cookies;
}

namespace {

gboolean on_load_failed_with_tls_errors(WebKitWebView *web_view,
                                        char *failing_uri,
                                        GTlsCertificate *certificate,
                                        GTlsCertificateFlags errors,
                                        gpointer user_data) {
  auto *webview = static_cast<WebviewWindow *>(user_data);
  g_critical("on_load_failed_with_tls_errors: %s %p error= %d", failing_uri,
             webview, errors);
  return false;
}

void apply_stable_webkit_settings(WebKitSettings *settings) {
  if (settings == nullptr) return;
  webkit_settings_set_javascript_can_open_windows_automatically(settings,
                                                                TRUE);
  webkit_settings_set_hardware_acceleration_policy(
      settings, WEBKIT_HARDWARE_ACCELERATION_POLICY_NEVER);
  webkit_settings_set_media_content_types_requiring_hardware_support(settings,
                                                                     "");
  // WebKit media under Flutter's Linux GL compositor aborts the process on
  // YouTube /watch. Browse in WebKit; play videos in Flutter (media_kit).
  webkit_settings_set_enable_media(settings, FALSE);
  webkit_settings_set_enable_mediasource(settings, FALSE);
  webkit_settings_set_media_playback_requires_user_gesture(settings, TRUE);
  webkit_settings_set_enable_webgl(settings, FALSE);
  webkit_settings_set_enable_2d_canvas_acceleration(settings, FALSE);
  webkit_settings_set_enable_media_stream(settings, FALSE);
  webkit_settings_set_enable_webrtc(settings, FALSE);
  webkit_settings_set_enable_smooth_scrolling(settings, TRUE);
  webkit_settings_set_enable_developer_extras(settings, TRUE);
  // Chrome-like desktop UA — Google OAuth often rejects WebKitGTK / custom
  // "AppName" user agents with "This browser or app may not be secure".
  webkit_settings_set_user_agent(
      settings,
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/128.0.0.0 Safari/537.36");
}

// Called after Flutter has created its GL context, immediately before the
// first WebKitWebView. Child WebKitWebProcess inherits these and uses
// software GL / non-GL media sinks — Flutter keeps its existing HW context.
void prepare_webkit_subprocess_env() {
  static bool done = false;
  if (done) return;
  done = true;
  setenv("LIBGL_ALWAYS_SOFTWARE", "1", 1);
  setenv("WEBKIT_DISABLE_COMPOSITING_MODE", "1", 1);
  setenv("WEBKIT_DISABLE_DMABUF_RENDERER", "1", 1);
  setenv("GST_PLUGIN_FEATURE_RANK",
         "avdec_av1:NONE;glimagesink:NONE;gtkglsink:NONE;"
         "glcolorconvert:NONE;glupload:NONE;gldownload:NONE",
         1);
  setenv("GST_GL_PLATFORM", "disabled", 0);
  webkit_breadcrumb("prepare_webkit_subprocess_env");
}

// Shared, on-disk WebKit profile so Apps keep cookies / localStorage / HTTP
// cache across window creates and app restarts.
WebKitWebContext *shared_webkit_context() {
  static WebKitWebContext *context = nullptr;
  if (context != nullptr) return context;

  g_autofree gchar *data_dir =
      g_build_filename(g_get_user_data_dir(), "gizecare", "webkit", nullptr);
  g_autofree gchar *cache_dir =
      g_build_filename(g_get_user_cache_dir(), "gizecare", "webkit", nullptr);
  g_mkdir_with_parents(data_dir, 0700);
  g_mkdir_with_parents(cache_dir, 0700);

  WebKitWebsiteDataManager *manager = webkit_website_data_manager_new(
      "base-data-directory", data_dir, "base-cache-directory", cache_dir,
      nullptr);
  context = webkit_web_context_new_with_website_data_manager(manager);

  // Persist cookies to SQLite — without this, Google/session cookies are
  // often memory-only and vanish when the WebKit process exits.
  WebKitCookieManager *cookies =
      webkit_web_context_get_cookie_manager(context);
  g_autofree gchar *cookie_file =
      g_build_filename(data_dir, "cookies.sqlite", nullptr);
  webkit_cookie_manager_set_persistent_storage(
      cookies, cookie_file, WEBKIT_COOKIE_PERSISTENT_STORAGE_SQLITE);
  webkit_cookie_manager_set_accept_policy(
      cookies, WEBKIT_COOKIE_POLICY_ACCEPT_ALWAYS);

  webkit_breadcrumb("shared_webkit_context");
  return context;
}

// OAuth / account hosts that commonly open popups. Related WebViews crash
// under Flutter's Linux GL compositor — keep them in the same tab instead.
bool is_auth_or_account_url(const char *uri) {
  if (uri == nullptr || *uri == '\0') return false;
  return strstr(uri, "accounts.google.com") != nullptr ||
         strstr(uri, "account.google.com") != nullptr ||
         strstr(uri, "google.com/o/oauth2") != nullptr ||
         strstr(uri, "google.com/signin") != nullptr ||
         strstr(uri, "apis.google.com/js") != nullptr ||
         strstr(uri, "login.microsoftonline.com") != nullptr ||
         strstr(uri, "login.live.com") != nullptr ||
         strstr(uri, "github.com/login") != nullptr ||
         strstr(uri, "appleid.apple.com") != nullptr ||
         strstr(uri, "auth0.com") != nullptr ||
         strstr(uri, "/oauth") != nullptr ||
         strstr(uri, "oauth2") != nullptr;
}

// Force every window.open / target=_blank into the existing tab. Creating a
// related WebView shares a WebProcess with the parent; adopt/blank of that
// sibling has SIGTRAP'd the UI when opening YouTube videos / Google OAuth.
GtkWidget *on_create(WebKitWebView *web_view,
                     WebKitNavigationAction *navigation_action,
                     gpointer user_data) {
  (void)user_data;
  webkit_breadcrumb("on_create");
  if (navigation_action != nullptr) {
    auto *request = webkit_navigation_action_get_request(navigation_action);
    if (request != nullptr) {
      const gchar *uri = webkit_uri_request_get_uri(request);
      if (uri != nullptr && *uri != '\0' &&
          g_strcmp0(uri, "about:blank") != 0) {
        // Explicit same-tab load: some WebKit builds do not auto-navigate
        // the parent when create returns NULL (OAuth popups would no-op).
        webkit_breadcrumb(uri);
        webkit_web_view_load_uri(web_view, uri);
        return nullptr;
      }
    }
  }
  // about:blank popup: refuse related view. JS inject provides a fake
  // window whose location.assign navigates this same tab.
  webkit_breadcrumb("on_create_null_blank");
  return nullptr;
}

gboolean on_enter_fullscreen(WebKitWebView *web_view, gpointer user_data) {
  (void)web_view;
  (void)user_data;
  webkit_breadcrumb("enter_fullscreen_swallowed");
  // Swallow OS-level fullscreen — the companion pane is a utility window and
  // native fullscreen here has crashed the UI process with YouTube.
  return TRUE;
}

gboolean on_leave_fullscreen(WebKitWebView *web_view, gpointer user_data) {
  (void)web_view;
  (void)user_data;
  return TRUE;
}

void on_web_process_terminated(WebKitWebView *web_view,
                               WebKitWebProcessTerminationReason reason,
                               gpointer user_data) {
  char buf[64];
  snprintf(buf, sizeof(buf), "web_process_terminated reason=%d",
           static_cast<int>(reason));
  webkit_breadcrumb(buf);
  g_warning("WebKit web process terminated (reason=%d) — reloading",
            static_cast<int>(reason));
  // Recover the tab instead of leaving a dead pane that can cascade into a
  // Flutter "Lost connection to device" when the UI tears down mid-crash.
  auto *window = static_cast<WebviewWindow *>(user_data);
  (void)window;
  if (web_view != nullptr) {
    const gchar *uri = webkit_web_view_get_uri(web_view);
    if (uri != nullptr && *uri != '\0' &&
        g_strcmp0(uri, "about:blank") != 0) {
      webkit_web_view_reload(web_view);
    } else {
      webkit_web_view_load_uri(web_view, "about:blank");
    }
  }
}

void on_uri_notify(GObject *object, GParamSpec *pspec, gpointer user_data) {
  (void)pspec;
  const gchar *uri = webkit_web_view_get_uri(WEBKIT_WEB_VIEW(object));
  webkit_breadcrumb(uri != nullptr ? uri : "uri_null");
  auto *window = static_cast<WebviewWindow *>(user_data);
  if (uri != nullptr && WebviewWindow::IsExternalMediaUrl(uri)) {
    window->OpenExternalMediaUrl(uri);
  }
}

void on_load_changed(WebKitWebView *web_view, WebKitLoadEvent load_event,
                     gpointer user_data) {
  char buf[48];
  snprintf(buf, sizeof(buf), "load_changed event=%d",
           static_cast<int>(load_event));
  webkit_breadcrumb(buf);
  auto *window = static_cast<WebviewWindow *>(user_data);
  window->OnLoadChanged(load_event);
}

gboolean decide_policy_cb(WebKitWebView *web_view,
                          WebKitPolicyDecision *decision,
                          WebKitPolicyDecisionType type, gpointer user_data) {
  auto *window = static_cast<WebviewWindow *>(user_data);
  return window->DecidePolicy(decision, type);
}

}  // namespace

WebviewWindow::WebviewWindow(FlMethodChannel *method_channel, int64_t window_id,
                             std::function<void()> on_close_callback,
                             const std::string &title, int width, int height,
                             int title_bar_height)
    : method_channel_(method_channel),
      window_id_(window_id),
      on_close_callback_(std::move(on_close_callback)),
      default_user_agent_() {
  g_object_ref(method_channel_);

  window_ = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  g_signal_connect(G_OBJECT(window_), "destroy",
                   G_CALLBACK(+[](GtkWidget *, gpointer arg) {
                     auto *window = static_cast<WebviewWindow *>(arg);
                     if (window->closing_) return;
                     window->closing_ = true;

                     // Hold an extra channel ref across teardown. on_close
                     // erases this WebviewWindow (and may dispose the plugin),
                     // which used to free the channel before onWindowClose.
                     FlMethodChannel *channel = window->method_channel_;
                     const int64_t id = window->window_id_;
                     if (channel != nullptr) {
                       g_object_ref(channel);
                     }

                     auto *args = fl_value_new_map();
                     fl_value_set(args, fl_value_new_string("id"),
                                  fl_value_new_int(id));
                     if (channel != nullptr && FL_IS_METHOD_CHANNEL(channel)) {
                       fl_method_channel_invoke_method(
                           channel, "onWindowClose", args, nullptr, nullptr,
                           nullptr);
                     } else {
                       fl_value_unref(args);
                     }

                     auto cb = std::move(window->on_close_callback_);
                     window->on_close_callback_ = nullptr;
                     // Destructor will unref method_channel_; drop our extra
                     // ref after the callback may have deleted |window|.
                     if (cb) {
                       cb();
                     }
                     if (channel != nullptr) {
                       g_object_unref(channel);
                     }
                   }),
                   this);
  gtk_window_set_title(GTK_WINDOW(window_), title.c_str());
  gtk_window_set_default_size(GTK_WINDOW(window_), width, height);
  gtk_window_set_position(GTK_WINDOW(window_), GTK_WIN_POS_CENTER);

  // GizeCare: borderless content pane docked under Flutter chrome — not a
  // separate decorated app window. Skip taskbar so it feels embedded.
  if (title_bar_height <= 0) {
    gtk_window_set_decorated(GTK_WINDOW(window_), FALSE);
    gtk_window_set_skip_taskbar_hint(GTK_WINDOW(window_), TRUE);
    gtk_window_set_skip_pager_hint(GTK_WINDOW(window_), TRUE);
    gtk_window_set_type_hint(GTK_WINDOW(window_),
                             GDK_WINDOW_TYPE_HINT_UTILITY);
    gtk_window_set_accept_focus(GTK_WINDOW(window_), TRUE);
  }

  box_ = GTK_BOX(gtk_box_new(GTK_ORIENTATION_VERTICAL, 0));
  gtk_container_add(GTK_CONTAINER(window_), GTK_WIDGET(box_));

  // GizeCare patch: do NOT create a Flutter FlView title bar.
  // fl_view_new() fights the main app OpenGL compositor on Linux (flicker,
  // dark frames, freezes). Native GTK window chrome is enough.

  // Flutter already owns HW GL; point WebKit's forked WebProcess at software
  // GL / non-GL GStreamer sinks before the first web view is created.
  prepare_webkit_subprocess_env();

  // initial web_view — persistent profile (cookies / cache / localStorage).
  webview_ = webkit_web_view_new_with_context(shared_webkit_context());
  g_signal_connect(G_OBJECT(webview_), "load-failed-with-tls-errors",
                   G_CALLBACK(on_load_failed_with_tls_errors), this);
  g_signal_connect(G_OBJECT(webview_), "create", G_CALLBACK(on_create), this);
  g_signal_connect(G_OBJECT(webview_), "load-changed",
                   G_CALLBACK(on_load_changed), this);
  g_signal_connect(G_OBJECT(webview_), "decide-policy",
                   G_CALLBACK(decide_policy_cb), this);
  g_signal_connect(G_OBJECT(webview_), "enter-fullscreen",
                   G_CALLBACK(on_enter_fullscreen), this);
  g_signal_connect(G_OBJECT(webview_), "leave-fullscreen",
                   G_CALLBACK(on_leave_fullscreen), this);
  g_signal_connect(G_OBJECT(webview_), "web-process-terminated",
                   G_CALLBACK(on_web_process_terminated), this);
  g_signal_connect(G_OBJECT(webview_), "notify::uri",
                   G_CALLBACK(on_uri_notify), this);

  auto settings = webkit_web_view_get_settings(WEBKIT_WEB_VIEW(webview_));
  apply_stable_webkit_settings(settings);
  default_user_agent_ = webkit_settings_get_user_agent(settings);
  gtk_box_pack_start(box_, webview_, TRUE, TRUE, 0);

  gtk_widget_show_all(GTK_WIDGET(window_));
  gtk_widget_grab_focus(GTK_WIDGET(webview_));
  // Stay hidden until Flutter docks the pane under the chrome.
  if (title_bar_height <= 0) {
    gtk_widget_hide(window_);
  }
}

WebviewWindow::~WebviewWindow() {
  closing_ = true;
  if (webview_ != nullptr) {
    g_signal_handlers_disconnect_by_data(webview_, this);
    WebKitUserContentManager *manager =
        webkit_web_view_get_user_content_manager(WEBKIT_WEB_VIEW(webview_));
    for (auto &entry : js_channel_handler_ids_) {
      g_signal_handler_disconnect(manager, entry.second);
    }
    js_channel_handler_ids_.clear();
    webview_ = nullptr;
  }
  if (window_ != nullptr) {
    g_signal_handlers_disconnect_by_data(window_, this);
    window_ = nullptr;
  }
  if (method_channel_ != nullptr) {
    g_object_unref(method_channel_);
    method_channel_ = nullptr;
  }
}

void WebviewWindow::InvokeMethod(const char *method, FlValue *args) {
  if (closing_ || method_channel_ == nullptr ||
      !FL_IS_METHOD_CHANNEL(method_channel_)) {
    if (args != nullptr) fl_value_unref(args);
    return;
  }
  fl_method_channel_invoke_method(FL_METHOD_CHANNEL(method_channel_), method,
                                  args, nullptr, nullptr, nullptr);
}

// static
bool WebviewWindow::IsExternalMediaUrl(const char *uri) {
  if (uri == nullptr || *uri == '\0') return false;
  // Heavy MSE/WebGL sites that crash WebKitGTK when nested under Flutter GL.
  return strstr(uri, "youtube.com/watch") != nullptr ||
         strstr(uri, "youtube.com/shorts/") != nullptr ||
         strstr(uri, "youtube.com/embed/") != nullptr ||
         strstr(uri, "youtube.com/live/") != nullptr ||
         strstr(uri, "youtu.be/") != nullptr ||
         strstr(uri, "youtube-nocookie.com/") != nullptr;
}

void WebviewWindow::OpenExternalMediaUrl(const char *uri) {
  if (closing_ || handling_external_media_ || uri == nullptr) return;
  handling_external_media_ = true;
  webkit_breadcrumb("in_app_media_handoff");
  webkit_breadcrumb(uri);

  auto *args = fl_value_new_map();
  fl_value_set(args, fl_value_new_string("id"), fl_value_new_int(window_id_));
  fl_value_set(args, fl_value_new_string("url"), fl_value_new_string(uri));
  InvokeMethod("onExternalUrlRequested", args);

  // Leave the watch page immediately (media is disabled, but SPA still
  // navigates here). Keep the user on search/channel results.
  if (webview_ != nullptr) {
    const gchar *current =
        webkit_web_view_get_uri(WEBKIT_WEB_VIEW(webview_));
    if (current != nullptr && IsExternalMediaUrl(current)) {
      if (webkit_web_view_can_go_back(WEBKIT_WEB_VIEW(webview_))) {
        webkit_web_view_go_back(WEBKIT_WEB_VIEW(webview_));
      } else {
        webkit_web_view_load_uri(WEBKIT_WEB_VIEW(webview_),
                                "https://www.youtube.com/");
      }
    }
  }
  handling_external_media_ = false;
}

void WebviewWindow::Navigate(const char *url) {
  webkit_breadcrumb("navigate");
  if (url != nullptr) webkit_breadcrumb(url);
  if (IsExternalMediaUrl(url)) {
    OpenExternalMediaUrl(url);
    return;
  }
  webkit_web_view_load_uri(WEBKIT_WEB_VIEW(webview_), url);
}

void WebviewWindow::RunJavaScriptWhenContentReady(const char *java_script) {
  auto *manager =
      webkit_web_view_get_user_content_manager(WEBKIT_WEB_VIEW(webview_));
  webkit_user_content_manager_add_script(
      manager,
      webkit_user_script_new(java_script, WEBKIT_USER_CONTENT_INJECT_TOP_FRAME,
                             WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_START,
                             nullptr, nullptr));
}

void WebviewWindow::SetApplicationNameForUserAgent(
    const std::string &app_name) {
  // Keep the Chrome-like UA from apply_stable_webkit_settings. Appending a
  // custom app token causes Google to reject sign-in in embedded WebKit.
  (void)app_name;
}

void WebviewWindow::Close() { gtk_window_close(GTK_WINDOW(window_)); }

void WebviewWindow::NotifyUrlChanged(const char *uri) {
  if (uri == nullptr || *uri == '\0') return;
  auto *args = fl_value_new_map();
  fl_value_set(args, fl_value_new_string("id"), fl_value_new_int(window_id_));
  fl_value_set(args, fl_value_new_string("url"), fl_value_new_string(uri));
  InvokeMethod("onUrlRequested", args);
}

// static
GtkWindow *WebviewWindow::FindMainAppWindow(GtkWidget *self_window) {
  GtkWindow *fallback = nullptr;
  for (GList *tops = gtk_window_list_toplevels(); tops != nullptr;
       tops = tops->next) {
    auto *candidate = GTK_WINDOW(tops->data);
    auto *widget = GTK_WIDGET(candidate);
    if (widget == self_window) continue;
    if (!gtk_widget_get_visible(widget)) continue;
    // Prefer the window that hosts an FlView (main GizeCare shell).
    if (FindFlView(widget) != nullptr) {
      return candidate;
    }
    if (fallback == nullptr) fallback = candidate;
  }
  return fallback;
}

// static
FlView *WebviewWindow::FindFlView(GtkWidget *widget) {
  if (widget == nullptr) return nullptr;
  if (FL_IS_VIEW(widget)) return FL_VIEW(widget);
  if (!GTK_IS_CONTAINER(widget)) return nullptr;
  GList *children = gtk_container_get_children(GTK_CONTAINER(widget));
  for (GList *c = children; c != nullptr; c = c->next) {
    FlView *found = FindFlView(GTK_WIDGET(c->data));
    if (found != nullptr) {
      g_list_free(children);
      return found;
    }
  }
  g_list_free(children);
  return nullptr;
}

void WebviewWindow::Move(int left, int top, int width, int height) {
  if (window_ == nullptr) return;
  if (width < 1) width = 1;
  if (height < 1) height = 1;

  GtkWindow *parent = FindMainAppWindow(window_);
  gint abs_x = left;
  gint abs_y = top;

  if (parent != nullptr) {
    // Keep the content pane stacked with the shell, but do not steal focus
    // from page inputs when re-docking.
    gtk_window_set_transient_for(GTK_WINDOW(window_), parent);
    FlView *view = FindFlView(GTK_WIDGET(parent));
    GtkWidget *anchor =
        view != nullptr ? GTK_WIDGET(view) : GTK_WIDGET(parent);
    GdkWindow *gdk = gtk_widget_get_window(anchor);
    if (gdk != nullptr) {
      gint ox = 0;
      gint oy = 0;
      gdk_window_get_origin(gdk, &ox, &oy);
      const gint scale = gdk_window_get_scale_factor(gdk);
      abs_x = (ox / scale) + left;
      abs_y = (oy / scale) + top;
    } else {
      gint px = 0;
      gint py = 0;
      gtk_window_get_position(parent, &px, &py);
      abs_x = px + left;
      abs_y = py + top;
    }
  }

  // Compare against the live window geometry — cached last_* goes stale after
  // maximize/restore when the WM changes the parent without our Move succeeding.
  gint cur_w = 0;
  gint cur_h = 0;
  gint cur_x = 0;
  gint cur_y = 0;
  gtk_window_get_size(GTK_WINDOW(window_), &cur_w, &cur_h);
  gtk_window_get_position(GTK_WINDOW(window_), &cur_x, &cur_y);
  const bool same_bounds =
      abs_x == cur_x && abs_y == cur_y && width == cur_w && height == cur_h;
  const bool was_visible = gtk_widget_get_visible(window_);

  if (!same_bounds) {
    gtk_window_resize(GTK_WINDOW(window_), width, height);
    gtk_window_move(GTK_WINDOW(window_), abs_x, abs_y);
    last_x_ = abs_x;
    last_y_ = abs_y;
    last_w_ = width;
    last_h_ = height;
  }

  // Show without present/raise — raising steals focus from text fields.
  if (!was_visible) {
    gtk_widget_show(window_);
  }
}

void WebviewWindow::SetVisibility(bool visible) {
  if (window_ == nullptr) return;
  if (visible) {
    gtk_widget_show(window_);
  } else {
    gtk_widget_hide(window_);
  }
}

void WebviewWindow::BringToForeground(bool maximized) {
  if (window_ == nullptr) return;
  gtk_widget_show(window_);
  gtk_window_present(GTK_WINDOW(window_));
  if (maximized) {
    gtk_window_maximize(GTK_WINDOW(window_));
  }
}

void WebviewWindow::OpenDevTools() {
  if (webview_ == nullptr) return;
  auto *settings = webkit_web_view_get_settings(WEBKIT_WEB_VIEW(webview_));
  webkit_settings_set_enable_developer_extras(settings, TRUE);
  auto *inspector = webkit_web_view_get_inspector(WEBKIT_WEB_VIEW(webview_));
  if (inspector == nullptr) return;
  webkit_web_inspector_show(inspector);
}

void WebviewWindow::OnLoadChanged(WebKitLoadEvent load_event) {
  if (closing_ || webview_ == nullptr) return;

  // notify history changed event.
  {
    auto can_go_back = webkit_web_view_can_go_back(WEBKIT_WEB_VIEW(webview_));
    auto can_go_forward =
        webkit_web_view_can_go_forward(WEBKIT_WEB_VIEW(webview_));
    auto *args = fl_value_new_map();
    fl_value_set(args, fl_value_new_string("id"), fl_value_new_int(window_id_));
    fl_value_set(args, fl_value_new_string("canGoBack"),
                 fl_value_new_bool(can_go_back));
    fl_value_set(args, fl_value_new_string("canGoForward"),
                 fl_value_new_bool(can_go_forward));
    InvokeMethod("onHistoryChanged", args);
  }

  // notify load start/finished event.
  switch (load_event) {
    case WEBKIT_LOAD_STARTED: {
      auto *args = fl_value_new_map();
      fl_value_set(args, fl_value_new_string("id"),
                   fl_value_new_int(window_id_));
      InvokeMethod("onNavigationStarted", args);
      break;
    }
    case WEBKIT_LOAD_COMMITTED:
    case WEBKIT_LOAD_FINISHED: {
      NotifyUrlChanged(webkit_web_view_get_uri(WEBKIT_WEB_VIEW(webview_)));
      if (load_event == WEBKIT_LOAD_FINISHED) {
        auto *args = fl_value_new_map();
        fl_value_set(args, fl_value_new_string("id"),
                     fl_value_new_int(window_id_));
        InvokeMethod("onNavigationCompleted", args);
      }
      break;
    }
    default:
      break;
  }
}

void WebviewWindow::GoForward() {
  webkit_web_view_go_forward(WEBKIT_WEB_VIEW(webview_));
}

void WebviewWindow::GoBack() {
  webkit_web_view_go_back(WEBKIT_WEB_VIEW(webview_));
}

void WebviewWindow::Reload() {
  webkit_web_view_reload(WEBKIT_WEB_VIEW(webview_));
}

void WebviewWindow::StopLoading() {
  webkit_web_view_stop_loading(WEBKIT_WEB_VIEW(webview_));
}

FlValue *WebviewWindow::GetAllCookies() {
  GList *cookies = get_cookies_sync(WEBKIT_WEB_VIEW(webview_));

  g_autoptr(FlValue) fl_cookie_list = fl_value_new_list();

  FlValue* cookie_list = fl_value_ref(fl_cookie_list);

  for (GList *l = cookies; l; l = l->next) {
    SoupCookie *cookie = (SoupCookie *)l->data;
    g_autoptr(FlValue) cookie_map = fl_value_new_map();

    fl_value_set_string_take(cookie_map, "name",
                             fl_value_new_string(soup_cookie_get_name(cookie)));
    fl_value_set_string_take(
        cookie_map, "value",
        fl_value_new_string(soup_cookie_get_value(cookie)));
    fl_value_set_string_take(
        cookie_map, "domain",
        fl_value_new_string(soup_cookie_get_domain(cookie)));
    fl_value_set_string_take(cookie_map, "path",
                             fl_value_new_string(soup_cookie_get_path(cookie)));

    gdouble expires = g_date_time_get_seconds(soup_cookie_get_expires(cookie));

    if (expires >= 0) {
      fl_value_set_string_take(cookie_map, "expires",
                               fl_value_new_float(expires));
    } else {
      fl_value_set_string_take(cookie_map, "expires", fl_value_new_null());
    }

    fl_value_set_string_take(
        cookie_map, "httpOnly",
        fl_value_new_bool(soup_cookie_get_http_only(cookie)));
    fl_value_set_string_take(cookie_map, "secure",
                             fl_value_new_bool(soup_cookie_get_secure(cookie)));
    fl_value_set_string_take(cookie_map, "sessionOnly",
                             fl_value_new_bool(false));

    fl_value_append(cookie_list, cookie_map);
    soup_cookie_free(cookie);
  }

  g_free(cookies);

  return cookie_list;
}

gboolean WebviewWindow::DecidePolicy(WebKitPolicyDecision *decision,
                                     WebKitPolicyDecisionType type) {
  if (closing_ || webview_ == nullptr) return FALSE;

  // Open "new window" navigations in this same webview (Flutter owns tabs).
  if (type == WEBKIT_POLICY_DECISION_TYPE_NEW_WINDOW_ACTION) {
    webkit_breadcrumb("decide_new_window");
    auto *navigation_decision = WEBKIT_NAVIGATION_POLICY_DECISION(decision);
    auto *navigation_action =
        webkit_navigation_policy_decision_get_navigation_action(
            navigation_decision);
    auto *request = webkit_navigation_action_get_request(navigation_action);
    auto *uri = webkit_uri_request_get_uri(request);
    if (uri != nullptr && *uri != '\0' &&
        g_strcmp0(uri, "about:blank") != 0) {
      webkit_breadcrumb(uri);
      if (is_auth_or_account_url(uri)) {
        webkit_breadcrumb("auth_same_tab");
      }
      webkit_web_view_load_uri(WEBKIT_WEB_VIEW(webview_), uri);
      auto *args = fl_value_new_map();
      fl_value_set(args, fl_value_new_string("id"),
                   fl_value_new_int(window_id_));
      fl_value_set(args, fl_value_new_string("url"), fl_value_new_string(uri));
      InvokeMethod("onUrlRequested", args);
    }
    webkit_policy_decision_ignore(decision);
    return TRUE;
  }

  if (type == WEBKIT_POLICY_DECISION_TYPE_NAVIGATION_ACTION) {
    auto *navigation_decision = WEBKIT_NAVIGATION_POLICY_DECISION(decision);
    auto *navigation_action =
        webkit_navigation_policy_decision_get_navigation_action(
            navigation_decision);
    auto *request = webkit_navigation_action_get_request(navigation_action);
    auto *uri = webkit_uri_request_get_uri(request);
    if (uri != nullptr && IsExternalMediaUrl(uri)) {
      OpenExternalMediaUrl(uri);
      webkit_policy_decision_ignore(decision);
      return TRUE;
    }
    if (uri != nullptr) {
      auto *args = fl_value_new_map();
      fl_value_set(args, fl_value_new_string("id"),
                   fl_value_new_int(window_id_));
      fl_value_set(args, fl_value_new_string("url"), fl_value_new_string(uri));
      InvokeMethod("onUrlRequested", args);
    }
  }
  return FALSE;
}

void WebviewWindow::EvaluateJavaScript(const char *java_script,
                                       FlMethodCall *call) {
#ifdef WEBKIT_OLD_USED
  webkit_web_view_run_javascript(
#else
  webkit_web_view_evaluate_javascript(
#endif
      WEBKIT_WEB_VIEW(webview_), java_script,
#ifndef WEBKIT_OLD_USED
      -1, nullptr, nullptr,
#endif
      nullptr,
      [](GObject *object, GAsyncResult *result, gpointer user_data) {
        auto *call = static_cast<FlMethodCall *>(user_data);
        GError *error = nullptr;
        auto *js_result =
#ifdef WEBKIT_OLD_USED
            webkit_web_view_run_javascript_finish(
#else
            webkit_web_view_evaluate_javascript_finish(
#endif
                WEBKIT_WEB_VIEW(object), result, &error);
        if (!js_result) {
          fl_method_call_respond_error(call, "failed to evaluate javascript.",
                                       error->message, nullptr, nullptr);
          g_error_free(error);
        } else {
          auto *js_value = jsc_value_to_json(
#ifdef WEBKIT_OLD_USED
              webkit_javascript_result_get_js_value
#endif
              (js_result),
              0);
          fl_method_call_respond_success(
              call, js_value ? fl_value_new_string(js_value) : nullptr,
              nullptr);
        }
        g_object_unref(call);
      },
      g_object_ref(call));
}

void WebviewWindow::RegisterJavaScriptChannel(const std::string &name) {
    WebKitUserContentManager *manager =
            webkit_web_view_get_user_content_manager(WEBKIT_WEB_VIEW(webview_));

    webkit_user_content_manager_register_script_message_handler(
            manager, name.c_str());

    struct HandlerData {
        WebviewWindow *self;
        std::string name;
    };

    HandlerData *data = new HandlerData{this, name};
    auto it = js_channel_handler_ids_.find(name);
    if (it != js_channel_handler_ids_.end()) {
        g_signal_handler_disconnect(manager, it->second);
        js_channel_handler_ids_.erase(it);
    }

    gulong handler_id = g_signal_connect_data(
            manager,
            ("script-message-received::" + name).c_str(),
            G_CALLBACK(+[](WebKitUserContentManager *manager,
                           WebKitJavascriptResult *result,
                           gpointer user_data) {
                HandlerData *data = static_cast<HandlerData *>(user_data);
                WebviewWindow *self = data->self;
                const std::string &handler_name = data->name;

                JSCValue *value = webkit_javascript_result_get_js_value(result);

                if (jsc_value_is_string(value)) {
                    gchar *str_value = jsc_value_to_string(value);
                    if (str_value != nullptr) {
                        FlValue *args = fl_value_new_map();
                        fl_value_set_string(args, "name",
                                            fl_value_new_string(handler_name.c_str()));
                        fl_value_set_string(args, "body",
                                            fl_value_new_string(str_value));
                        fl_value_set_string(args, "id",
                                            fl_value_new_int(self->window_id_));

                        self->InvokeMethod("onJavaScriptMessage", args);

                        g_free(str_value);
                    }
                }
            }),
            data,
            +[](gpointer user_data, GClosure *) {
                delete static_cast<HandlerData *>(user_data);
            },
            static_cast<GConnectFlags>(0));

    js_channel_handler_ids_[name] = handler_id;
}


void WebviewWindow::UnregisterJavaScriptChannel(const std::string &name) {
    WebKitUserContentManager *manager =
            webkit_web_view_get_user_content_manager(WEBKIT_WEB_VIEW(webview_));

    auto it = js_channel_handler_ids_.find(name);
    if (it != js_channel_handler_ids_.end()) {
        g_signal_handler_disconnect(manager, it->second);
        js_channel_handler_ids_.erase(it);
    }

    webkit_user_content_manager_unregister_script_message_handler(
            manager, name.c_str());
}

