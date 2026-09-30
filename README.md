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
./tool/patch_quill_link_cursor.sh
dart run build_runner build --delete-conflicting-outputs
flutter run -d linux
```

Linux packages for tray/notifications:

```bash
sudo apt install libnotify-dev libayatana-appindicator3-dev
```

In-app browser (GizeCare Browser):

`http` / `https` / `file` / `data` links open the in-app **/browser** surface
(Notes, Gmail, Slack, Telegram, Calendar, Documents). OAuth / `tel` / `mailto` /
`tg` stay with the system handler.

Chrome (all platforms): tab strip (+ / close, Ctrl+T / Ctrl+W), back /
forward / reload, omnibox (URL or search), https lock, bookmarks bar + star,
fullscreen (F11 / Esc to exit), settings (search engine, clear data),
Inspect (F12 / Ctrl+Shift+I on desktop), open in system browser / copy link.
Sidebar **Browser** opens the search-engine home.

- **Linux / Windows**: Flutter chrome in the main window; page pixels in a
  companion WebKitGTK / WebView2 window docked under the content area (embedding
  WebKit inside the Flutter OpenGL surface freezes on Linux).
- **Mobile / macOS**: same chrome with embedded `webview_flutter`.

Linux needs `libwebkit2gtk-4.1` (runtime) and preferably `libwebkit2gtk-4.1-dev`
(build). `linux/CMakeLists.txt` can also use `~/.local/webkit-pc` when system
-dev is missing.

Prefer an **official Flutter SDK** (not snap) when linking tray plugins.
Snap Flutter is known to mis-link ayatana/glib; use `~/flutter` instead.
**Quit and re-run** after changing native browser plugins (hot restart is not enough).


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
documents · apps (ChatGPT, Gemini, YouTube) · browser · telegram · gmail ·
slack · whatsapp · screenshots · reports · settings

Errors cross boundaries as `Result<T>` + `Failure`.

## Capabilities

- Home: tagline, active timer, today/week hours, quick start into the workspace
- Projects / Tasks: CRUD, search, color picker
- Project **Board**: per-project Kanban (columns, drag-drop cards, labels, due dates,
  priority, checklists, comments, attachments, activity)
- Notebook & Documents: capture and keep work without leaving the app
- Calendar: day/week view with Google Calendar sync
- Gmail, Telegram, Slack & WhatsApp: messaging in one place (WhatsApp Web in-browser)
- **Apps**: ChatGPT, Gemini, and YouTube open inside ጊዜCare Browser (sign in on the site; session kept in the webview profile)
- **In-app browser**: Flutter chrome + docked WebKit/WebView2 (desktop) or embedded webview (mobile); tabs, Inspect/DevTools, bookmarks, omnibox search, settings; OAuth / `tel` / `tg` stay external
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
