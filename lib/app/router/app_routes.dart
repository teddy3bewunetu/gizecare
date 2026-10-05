/// Named route paths for ጊዜCare.
abstract final class AppRoutes {
  static const String compact = '/compact';
  static const String dashboard = '/';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String tasks = '/tasks';
  static const String taskDetail = '/tasks/:id';
  static const String tracker = '/tracker';
  static const String clock = '/clock';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String screenshots = '/screenshots';
  static const String documents = '/documents';
  static const String notebook = '/notebook';
  static const String calendar = '/calendar';

  /// Messages hub (redirects to Gmail).
  static const String messages = '/messages';
  static const String gmail = '/messages/gmail';
  static const String telegram = '/messages/telegram';
  static const String slack = '/messages/slack';
  static const String whatsapp = '/messages/whatsapp';

  /// Legacy paths — redirected to nested Messages routes.
  static const String gmailLegacy = '/gmail';
  static const String telegramLegacy = '/telegram';

  /// Apps hub (redirects to ChatGPT).
  static const String apps = '/apps';
  static const String chatgpt = '/apps/chatgpt';
  static const String gemini = '/apps/gemini';
  static const String youtube = '/apps/youtube';
  static const String terminal = '/apps/terminal';

  /// Full-screen in-app browser (`?url=` required, optional `title=`).
  static const String browser = '/browser';

  /// Default ChatGPT web URL opened in the in-app browser.
  static const String chatgptUrl = 'https://chatgpt.com/';

  /// Default Gemini web URL opened in the in-app browser.
  static const String geminiUrl = 'https://gemini.google.com/';

  /// Default WhatsApp Web URL opened in the in-app browser.
  static const String whatsappUrl = 'https://web.whatsapp.com/';

  /// Default YouTube web URL opened in the in-app browser.
  static const String youtubeUrl = 'https://www.youtube.com/';

  static String projectDetailPath(String id) => '/projects/$id';
  static String taskDetailPath(String id) => '/tasks/$id';

  /// Opens the in-app browser at [url].
  static String browserPath(String url, {String? title}) {
    return Uri(
      path: browser,
      queryParameters: {
        'url': url,
        if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
      },
    ).toString();
  }

  /// Opens Notebook and creates a note, optionally linked to project/task.
  static String notebookCreatePath({
    String? projectId,
    String? taskId,
    String? notebookId,
  }) {
    final params = <String, String>{'create': '1'};
    if (projectId != null) params['projectId'] = projectId;
    if (taskId != null) params['taskId'] = taskId;
    if (notebookId != null) params['notebookId'] = notebookId;
    return Uri(path: notebook, queryParameters: params).toString();
  }
}
