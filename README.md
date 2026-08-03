# ጊዜCare (GizeCare)

**Your workday. One place.**

Offline-first workday hub for freelancers, software engineers, designers, and
professionals. Track time, manage projects and tasks, take notes, keep
documents, and reach Calendar, Gmail, Telegram, and Slack without juggling separate
apps — less context-switching, lighter on the machine, more focus on the work.

**Gize (ጊዜ)** means *Time* in Amharic. Branding (vision, mission, values):
[`docs/branding.md`](docs/branding.md).

## Stack

| Layer | Choice |
| --- | --- |
| UI | Flutter (Material 3), desktop |
| State | Riverpod |
| Navigation | GoRouter + sidebar shell |
| Database | Drift (SQLite) |
| Charts | fl_chart |
| Desktop | window_manager, tray_manager, screen_retriever, local_notifier |

> `desktop_lifecycle` is omitted (Dart 2 only). Use `window_manager` focus events.

## Run

```bash
cd gizecare
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d linux
```

Linux packages for tray/notifications:

```bash
sudo apt install libnotify-dev libayatana-appindicator3-dev
```

Prefer an **official Flutter SDK** (not snap) when linking tray plugins.

```bash
# Official SDK (recommended for tray)
export PATH="$HOME/flutter/bin:$PATH"
export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

cd gizecare
flutter pub get
flutter run -d linux
```

`tray_manager` is included. Flutter **snap** fails to link ayatana/glib on Ubuntu 24.04;
use `~/flutter` instead. If tray init still fails at runtime, the compact window
keeps working (Settings shows tray unavailable).

## Compact tracker + tray

- Default launch: compact Upwork-style window (`/compact`)
- Full app: sidebar shell for home, notes, tasks, calendar, projects, tracker,
  clock, reports, documents, Messages (Gmail, Telegram, Slack), settings
- System tray menu: Open tracker · Open full app · Start · Pause · Stop · Quit
- Close / minimize can hide to tray (Settings)

## Architecture

```
lib/
  app/                 bootstrap, router, shell
  core/                theme, database, errors, services, widgets
  features/
    <feature>/
      data/
      domain/
      presentation/
```

Features: dashboard · notebook · projects · tasks · tracker · clock · calendar ·
documents · telegram · gmail · activity · screenshots · reports · settings

Errors cross boundaries as `Result<T>` + `Failure`.

## Capabilities

- Home: tagline, active timer, today/week hours, quick start into the workspace
- Projects / Tasks: CRUD, search, color picker
- Project **Board**: per-project Kanban (columns, drag-drop cards, labels, due dates,
  priority, checklists, comments, attachments, activity)
- Notebook & Documents: capture and keep work without leaving the app
- Calendar: day/week view with Google Calendar sync
- Gmail, Telegram & Slack: scoped in-app access so everyday messaging stays in one place
- Tracker: start / pause / resume / stop, activity %, idle prompt
- Screenshots: interval capture to `~/Pictures/GizeCare/`
- Reports: daily/weekly/monthly charts + CSV export
- Settings: theme, idle, screenshots, startup, compact launch, close-to-tray
- Compact tracker window + system tray (top bar)
- Window size/position persistence (compact + full)

## Tests

```bash
flutter test
flutter analyze
```

## Roadmap status

1. Project initialization ✓  
2. Folder architecture ✓  
3. Theme system ✓  
4. Routing ✓  
5. Drift database ✓  
6. Dashboard ✓  
7. Projects ✓  
8. Tasks ✓  
8b. Per-project Kanban board ✓  
9. Timer engine ✓  
10. Activity service ✓  
11. Screenshot service ✓  
12. Reports ✓  
13. Settings ✓  
14. Polishing ✓ (baseline)

## License

Private — not published to pub.dev.
