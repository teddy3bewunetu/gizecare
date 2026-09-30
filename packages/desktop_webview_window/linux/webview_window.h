//
// Created by boyan on 10/21/21.
//

#ifndef WEBVIEW_WINDOW_LINUX_WEBVIEW_WINDOW_H_
#define WEBVIEW_WINDOW_LINUX_WEBVIEW_WINDOW_H_

#include <climits>
#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <libsoup/soup.h>
#include <webkit2/webkit2.h>

#include <functional>
#include <string>
#include <unordered_map>

typedef struct {
    GMainLoop *loop;
    GList *cookies;
} CookieData;

void get_cookies_callback(WebKitCookieManager *manager, GAsyncResult *res,
                          gpointer user_data);

GList *get_cookies_sync(WebKitWebView *web_view);

class WebviewWindow {
 public:
  WebviewWindow(FlMethodChannel *method_channel, int64_t window_id,
                std::function<void()> on_close_callback,
                const std::string &title, int width, int height,
                int title_bar_height);

  virtual ~WebviewWindow();

  void Navigate(const char *url);

  void RunJavaScriptWhenContentReady(const char *java_script);

  void Close();

  void SetApplicationNameForUserAgent(const std::string &app_name);

  void OnLoadChanged(WebKitLoadEvent load_event);

  void GoBack();

  void GoForward();

  void Reload();

  void StopLoading();

  FlValue* GetAllCookies();

  gboolean DecidePolicy(WebKitPolicyDecision *decision,
                        WebKitPolicyDecisionType type);

  void EvaluateJavaScript(const char *java_script, FlMethodCall *call);

  void RegisterJavaScriptChannel(const std::string &name);

  void UnregisterJavaScriptChannel(const std::string &name);

  /// Docks under the main Flutter view. [left]/[top]/[width]/[height] are
  /// logical coordinates relative to the FlView (same as Flutter localToGlobal).
  void Move(int left, int top, int width, int height);

  void SetVisibility(bool visible);

  void BringToForeground(bool maximized);

  void OpenDevTools();

  /// YouTube/watch-style URLs: hand off to the OS browser and leave the tab.
  void OpenExternalMediaUrl(const char *uri);
  static bool IsExternalMediaUrl(const char *uri);

 private:
  void NotifyUrlChanged(const char *uri);
  void InvokeMethod(const char *method, FlValue *args);
  static GtkWindow *FindMainAppWindow(GtkWidget *self_window);
  static FlView *FindFlView(GtkWidget *widget);
  FlMethodChannel *method_channel_;
  int64_t window_id_;
  std::function<void()> on_close_callback_;
  bool closing_ = false;
  bool handling_external_media_ = false;

  std::string default_user_agent_;

  GtkWidget *window_ = nullptr;
  GtkWidget *webview_ = nullptr;
  GtkBox *box_ = nullptr;
  int last_x_ = INT_MIN;
  int last_y_ = INT_MIN;
  int last_w_ = -1;
  int last_h_ = -1;

  std::unordered_map<std::string, gulong> js_channel_handler_ids_;
};

#endif  // WEBVIEW_WINDOW_LINUX_WEBVIEW_WINDOW_H_
