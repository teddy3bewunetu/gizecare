/// Shared application configuration.
///
/// Environment flags, paths, and sync endpoints land here as features grow.
class AppConfig {
  const AppConfig._();

  /// Semantic app version shown in Settings / About.
  static const String versionLabel = '0.1.0';

  /// Reserved for future FastAPI / cloud sync base URL.
  static const String? syncBaseUrl = null;

  /// Whether cloud sync features are compiled in (always off for MVP).
  static const bool syncEnabled = false;
}
