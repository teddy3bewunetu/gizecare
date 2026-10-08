# GizeCare Snap — API keys, Telegram, browser

After installing from the Snap Store (`sudo snap install gizecare --edge`), the app
does **not** read the project-root `.env` used for local `flutter run`. Put secrets
where the snap can see them.

## 1. Config file for Google / Slack / Telegram

Create:

```bash
mkdir -p ~/snap/gizecare/common
nano ~/snap/gizecare/common/.env
```

Paste (same keys as `.env.example`):

```env
GOOGLE_CALENDAR_CLIENT_ID=....apps.googleusercontent.com
GOOGLE_CALENDAR_CLIENT_SECRET=...

TELEGRAM_API_ID=...
TELEGRAM_API_HASH=...

SLACK_CLIENT_ID=...
SLACK_CLIENT_SECRET=...
```

Also accepted:

- `~/snap/gizecare/common/.env` (preferred — survives refreshes)
- `~/.config/gizecare/.env`

Then fully quit GizeCare and start it again.

Setup guides:

- Google / Gmail: `docs/gmail_setup.md`, `docs/google_calendar_setup.md`
- Slack: `docs/slack_setup.md`
- Telegram: `docs/telegram_setup.md`

## 2. Telegram TDLib (`libtdjson.so`)

The snap does not ship TDLib yet. Build or install `libtdjson.so`, then either:

```bash
cp /path/to/libtdjson.so ~/snap/gizecare/common/libtdjson.so
```

or set in `.env`:

```env
TELEGRAM_TDLIB_PATH="/home/YOU/.local/lib/libtdjson.so"
```

(Use a path under your real home; quote paths with spaces.)

## 3. Optional interface connects

Some plugs are not auto-connected:

```bash
sudo snap connect gizecare:password-manager-service
sudo snap connect gizecare:process-control
sudo snap connect gizecare:audio-record
```

`shared-memory` should be private and connected automatically after a rebuild that
declares `plugs.shared-memory.private: true`.

## 4. Browser (Gemini / ChatGPT / etc.)

Needs network + WebKit inside the sandbox. If you still see
`GDBus.Error:org.freedesktop.portal.Error.NotAllowed`, refresh to a build that sets
`GTK_USE_PORTAL=0` and private shared-memory, then restart the app.

## 5. In-app Terminal

Under **strict** confinement many host commands (`whoami`, `man`, `df`, …) return
**Permission denied**. Core `/bin` tools still work. Prefer **Open system terminal**
for a full host shell, or run GizeCare from source with `flutter run` for an
unrestricted PTY.
