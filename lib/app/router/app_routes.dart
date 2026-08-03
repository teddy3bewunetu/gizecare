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

  /// Legacy paths — redirected to nested Messages routes.
  static const String gmailLegacy = '/gmail';
  static const String telegramLegacy = '/telegram';

  static String projectDetailPath(String id) => '/projects/$id';
  static String taskDetailPath(String id) => '/tasks/$id';

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
