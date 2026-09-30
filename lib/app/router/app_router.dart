import 'package:go_router/go_router.dart';

import 'package:gizecare/app/router/app_routes.dart';
import 'package:gizecare/app/router/root_navigator.dart';
import 'package:gizecare/app/shell/app_shell.dart';
import 'package:gizecare/core/browser/app_desktop_browser.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/features/browser/presentation/pages/browser_page.dart';
import 'package:gizecare/features/calendar/presentation/pages/calendar_page.dart';
import 'package:gizecare/features/clock/presentation/pages/clock_page.dart';
import 'package:gizecare/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gizecare/features/documents/presentation/pages/documents_page.dart';
import 'package:gizecare/features/notebook/presentation/pages/notebook_page.dart';
import 'package:gizecare/features/projects/presentation/pages/project_detail_page.dart';
import 'package:gizecare/features/projects/presentation/pages/projects_page.dart';
import 'package:gizecare/features/reports/presentation/pages/reports_page.dart';
import 'package:gizecare/features/screenshots/presentation/pages/screenshots_page.dart';
import 'package:gizecare/features/settings/presentation/pages/settings_page.dart';
import 'package:gizecare/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:gizecare/features/tasks/presentation/pages/tasks_page.dart';
import 'package:gizecare/features/gmail/presentation/pages/gmail_page.dart';
import 'package:gizecare/features/slack/presentation/pages/slack_page.dart';
import 'package:gizecare/features/telegram/presentation/pages/telegram_page.dart';
import 'package:gizecare/features/tracker/presentation/pages/compact_tracker_page.dart';
import 'package:gizecare/features/tracker/presentation/pages/tracker_page.dart';

/// Root navigator for dialogs (alarms / countdown) outside the current route.
export 'package:gizecare/app/router/root_navigator.dart' show rootNavigatorKey;

/// Creates the application [GoRouter].
///
/// Compact tracker lives outside [AppShell] (desktop). Mobile opens the full
/// shell on [AppRoutes.dashboard].
GoRouter createAppRouter({String? initialLocation}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation ??
        (AppPlatform.isMobile ? AppRoutes.dashboard : AppRoutes.compact),
    routes: [
      GoRoute(
        path: AppRoutes.compact,
        name: 'compact',
        redirect: (context, state) {
          if (AppPlatform.isMobile) return AppRoutes.tracker;
          return null;
        },
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: CompactTrackerPage(),
        ),
      ),
      // Legacy redirects into Messages hub.
      GoRoute(
        path: AppRoutes.gmailLegacy,
        redirect: (_, __) => AppRoutes.gmail,
      ),
      GoRoute(
        path: AppRoutes.telegramLegacy,
        redirect: (_, __) => AppRoutes.telegram,
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.browser,
            name: 'browser',
            pageBuilder: (context, state) {
              final url = state.uri.queryParameters['url'] ?? 'about:blank';
              final title = state.uri.queryParameters['title'];
              return NoTransitionPage<void>(
                child: BrowserPage(
                  initialUrl: url,
                  title: title,
                  sessionKey: url == 'about:blank'
                      ? null
                      : AppDesktopBrowser.sessionKeyForUrl(url),
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.projects,
            name: 'projects',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ProjectsPage(),
            ),
          ),
          GoRoute(
            path: '/projects/:id',
            name: 'projectDetail',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                child: ProjectDetailPage(projectId: id),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.tasks,
            name: 'tasks',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: TasksPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            name: 'calendar',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: CalendarPage(),
            ),
          ),
          GoRoute(
            path: '/tasks/:id',
            name: 'taskDetail',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                child: TaskDetailPage(taskId: id),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.tracker,
            name: 'tracker',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: TrackerPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.clock,
            name: 'clock',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ClockPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.reports,
            name: 'reports',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ReportsPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.screenshots,
            name: 'screenshots',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ScreenshotsPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.documents,
            name: 'documents',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: DocumentsPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.messages,
            name: 'messages',
            redirect: (_, __) => AppRoutes.gmail,
          ),
          GoRoute(
            path: AppRoutes.apps,
            name: 'apps',
            redirect: (_, __) => AppRoutes.chatgpt,
          ),
          GoRoute(
            path: AppRoutes.chatgpt,
            name: 'chatgpt',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: BrowserPage(
                initialUrl: AppRoutes.chatgptUrl,
                title: 'ChatGPT',
                sessionKey: 'app:chatgpt',
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.gemini,
            name: 'gemini',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: BrowserPage(
                initialUrl: AppRoutes.geminiUrl,
                title: 'Gemini',
                sessionKey: 'app:gemini',
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.youtube,
            name: 'youtube',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: BrowserPage(
                initialUrl: AppRoutes.youtubeUrl,
                title: 'YouTube',
                sessionKey: 'app:youtube',
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.gmail,
            name: 'gmail',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: GmailPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.telegram,
            name: 'telegram',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: TelegramPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.slack,
            name: 'slack',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SlackPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.whatsapp,
            name: 'whatsapp',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: BrowserPage(
                initialUrl: AppRoutes.whatsappUrl,
                title: 'WhatsApp',
                sessionKey: 'app:whatsapp',
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.notebook,
            name: 'notebook',
            pageBuilder: (context, state) {
              final q = state.uri.queryParameters;
              return NoTransitionPage<void>(
                child: NotebookPage(
                  createOnOpen: q['create'] == '1',
                  projectId: q['projectId'],
                  taskId: q['taskId'],
                  notebookId: q['notebookId'],
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

/// Provides a stable [GoRouter] for the app lifetime.
final appRouter = createAppRouter();
