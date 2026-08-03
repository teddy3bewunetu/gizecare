/// Global constants for ጊዜCare.
///
/// Brand voice and longer copy live in `docs/branding.md`.
class AppConstants {
  const AppConstants._();

  /// Display name shown in UI and window chrome (Amharic ጊዜ + Care).
  static const String displayName = 'ጊዜCare';

  /// Internal product name for paths, package ids, and logging.
  static const String appName = 'GizeCare';

  /// Primary marketing tagline.
  static const String tagline = 'Your workday. One place.';

  /// Short supporting line for home / about surfaces.
  static const String taglineSupporting =
      'Track time, run projects, take notes, and reach calendar, mail, and '
      'Telegram — without juggling separate apps.';

  /// Default screenshot interval while the timer is running.
  static const Duration defaultScreenshotInterval = Duration(minutes: 10);

  /// Default idle timeout before the tracker pauses.
  static const Duration defaultIdleTimeout = Duration(minutes: 5);

  /// Relative screenshots folder under the user's Pictures directory.
  static const String screenshotsFolderName = 'GizeCare';
}
