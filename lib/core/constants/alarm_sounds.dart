/// Built-in alarm / timer ringtone options.
class AlarmSound {
  const AlarmSound({
    required this.id,
    required this.title,
    required this.assetPath,
  });

  final String id;
  final String title;
  final String assetPath;
}

/// Catalog of Mixkit alarm samples bundled with ጊዜCare.
abstract final class AlarmSounds {
  /// Classic digital clock buzzer — clear, urgent, fits a time app.
  static const String defaultId = 'digital_buzzer';

  static const digitalBuzzer = AlarmSound(
    id: 'digital_buzzer',
    title: 'Digital buzzer',
    assetPath: 'assets/sounds/alarms/digital_buzzer.wav',
  );

  static const clockBeep = AlarmSound(
    id: 'clock_beep',
    title: 'Alarm clock beep',
    assetPath: 'assets/sounds/alarms/clock_beep.wav',
  );

  static const vintageWarning = AlarmSound(
    id: 'vintage_warning',
    title: 'Vintage warning',
    assetPath: 'assets/sounds/alarms/vintage_warning.wav',
  );

  static const alertAlarm = AlarmSound(
    id: 'alert_alarm',
    title: 'Alert alarm',
    assetPath: 'assets/sounds/alarms/alert_alarm.wav',
  );

  static const hallAlert = AlarmSound(
    id: 'hall_alert',
    title: 'Hall alert',
    assetPath: 'assets/sounds/alarms/hall_alert.wav',
  );

  static const streetPublic = AlarmSound(
    id: 'street_public',
    title: 'Street public alarm',
    assetPath: 'assets/sounds/alarms/street_public.wav',
  );

  static const securityBreach = AlarmSound(
    id: 'security_breach',
    title: 'Security breach',
    assetPath: 'assets/sounds/alarms/security_breach.wav',
  );

  static const sciFi = AlarmSound(
    id: 'sci_fi',
    title: 'Sci‑fi scan',
    assetPath: 'assets/sounds/alarms/sci_fi.wav',
  );

  static const retroEmergency = AlarmSound(
    id: 'retro_emergency',
    title: 'Retro emergency',
    assetPath: 'assets/sounds/alarms/retro_emergency.wav',
  );

  static const all = <AlarmSound>[
    digitalBuzzer,
    clockBeep,
    vintageWarning,
    alertAlarm,
    hallAlert,
    streetPublic,
    securityBreach,
    sciFi,
    retroEmergency,
  ];

  static AlarmSound byId(String? id) {
    return all.firstWhere(
      (s) => s.id == id,
      orElse: () => digitalBuzzer,
    );
  }
}
