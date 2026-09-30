import 'package:gizecare/app/router/app_routes.dart';

/// Maps a GoRouter path to a stable feature key + display label.
({String key, String label}) featureForPath(String path) {
  final p = path.isEmpty ? '/' : path;

  if (p == AppRoutes.compact) {
    return (key: 'compact', label: 'Compact tracker');
  }
  if (p == AppRoutes.dashboard || p == '/') {
    return (key: 'home', label: 'Home');
  }
  if (p == AppRoutes.notebook || p.startsWith('${AppRoutes.notebook}/')) {
    return (key: 'notes', label: 'Notes');
  }
  if (p == AppRoutes.tasks || p.startsWith('${AppRoutes.tasks}/')) {
    return (key: 'tasks', label: 'Tasks');
  }
  if (p == AppRoutes.calendar || p.startsWith('${AppRoutes.calendar}/')) {
    return (key: 'calendar', label: 'Calendar');
  }
  if (p == AppRoutes.projects || p.startsWith('${AppRoutes.projects}/')) {
    return (key: 'projects', label: 'Projects');
  }
  if (p == AppRoutes.tracker || p.startsWith('${AppRoutes.tracker}/')) {
    return (key: 'tracker', label: 'Tracker');
  }
  if (p == AppRoutes.clock || p.startsWith('${AppRoutes.clock}/')) {
    return (key: 'clock', label: 'Clock');
  }
  if (p == AppRoutes.reports || p.startsWith('${AppRoutes.reports}/')) {
    return (key: 'reports', label: 'Reports');
  }
  if (p == AppRoutes.documents || p.startsWith('${AppRoutes.documents}/')) {
    return (key: 'documents', label: 'Documents');
  }
  if (p == AppRoutes.screenshots || p.startsWith('${AppRoutes.screenshots}/')) {
    return (key: 'screenshots', label: 'Screenshots');
  }
  if (p == AppRoutes.settings || p.startsWith('${AppRoutes.settings}/')) {
    return (key: 'settings', label: 'Settings');
  }
  if (p == AppRoutes.browser || p.startsWith('${AppRoutes.browser}/')) {
    return (key: 'browser', label: 'Browser');
  }

  // Apps hub + nested web apps.
  if (p == AppRoutes.chatgpt || p.startsWith('${AppRoutes.chatgpt}/')) {
    return (key: 'chatgpt', label: 'ChatGPT');
  }
  if (p == AppRoutes.gemini || p.startsWith('${AppRoutes.gemini}/')) {
    return (key: 'gemini', label: 'Gemini');
  }
  if (p == AppRoutes.youtube || p.startsWith('${AppRoutes.youtube}/')) {
    return (key: 'youtube', label: 'YouTube');
  }
  if (p == AppRoutes.apps || p.startsWith('${AppRoutes.apps}/')) {
    return (key: 'apps', label: 'Apps');
  }

  // Messages.
  if (p == AppRoutes.gmail ||
      p == AppRoutes.gmailLegacy ||
      p.startsWith('${AppRoutes.gmail}/')) {
    return (key: 'gmail', label: 'Gmail');
  }
  if (p == AppRoutes.telegram ||
      p == AppRoutes.telegramLegacy ||
      p.startsWith('${AppRoutes.telegram}/')) {
    return (key: 'telegram', label: 'Telegram');
  }
  if (p == AppRoutes.slack || p.startsWith('${AppRoutes.slack}/')) {
    return (key: 'slack', label: 'Slack');
  }
  if (p == AppRoutes.whatsapp || p.startsWith('${AppRoutes.whatsapp}/')) {
    return (key: 'whatsapp', label: 'WhatsApp');
  }
  if (p == AppRoutes.messages || p.startsWith('${AppRoutes.messages}/')) {
    return (key: 'messages', label: 'Messages');
  }

  return (key: 'other', label: 'Other');
}
