# GizeCare Snap — store installs, CI config, browser

## End users (Snap Store)

Install and sign in — **no `.env` file**:

```bash
sudo snap install gizecare --edge   # or stable when published
gizecare
```

Then use **Connect** / sign-in in Gmail, Slack, and Telegram. App OAuth client
IDs and Telegram `api_id` / `api_hash` are baked into release builds by CI.

Optional plugs (if a feature asks):

```bash
sudo snap connect gizecare:password-manager-service
sudo snap connect gizecare:process-control
sudo snap connect gizecare:audio-record
```

### Browser

If an embedded page shows `GDBus… portal… NotAllowed`, update to a build that
sets `GTK_USE_PORTAL=0` / `GIO_USE_PORTALS=0`, disables nested WebKit sandbox,
uses private `shared-memory`, and plugs `network-status` (auto-connected), then
fully quit and restart GizeCare.

### In-app Terminal

Under **strict** confinement many host commands (`whoami`, `man`, `df`, …) return
**Permission denied**. Prefer **Open system terminal** for a full host shell.

### Telegram TDLib

Store builds compile `libtdjson.so` inside the snap (`tdlib` part on core22) and
set `TELEGRAM_TDLIB_PATH=$SNAP/lib/libtdjson.so`. Users do not install TDLib.

Do **not** copy a host Ubuntu 24.04 `libtdjson.so` into `~/snap/gizecare/common/`
— it needs newer glibc (`GLIBC_2.38`) and will fail inside the snap.

---

## Maintainers — GitHub Actions config

**Settings → Secrets and variables → Actions**

### Variables (required for publish in this repo)

| Name | Where | Purpose |
|------|--------|---------|
| `SNAPCRAFT_STORE_CREDENTIALS` | **Variables** | Snap Store login (`snapcraft export-login` file contents) |

Use **Variables** for store credentials here (Secrets did not resolve reliably for
the multiline login blob in this workflow).

### Variables or Secrets (app credentials → dart-define)

Add each as a **Variable** or a **Secret** (workflow accepts either; Variables
first, then Secrets):

| Name |
|------|
| `GOOGLE_CALENDAR_CLIENT_ID` |
| `GOOGLE_CALENDAR_CLIENT_SECRET` |
| `SLACK_CLIENT_ID` |
| `SLACK_CLIENT_SECRET` |
| `TELEGRAM_API_ID` |
| `TELEGRAM_API_HASH` |

Copy values from your local `.env`. On push to `main` / tags `v*.*.*`, CI writes
them to `snap/local/ci_dart_defines.env` (gitignored), Snapcraft passes
`--dart-define=…`, then deletes the file.

Create the store credential once:

```bash
snapcraft export-login \
  --snaps=gizecare \
  --channels=edge,candidate,stable \
  --acls=package_upload,package_release \
  snapcraft-creds.txt
```

Paste the **entire file** into the Actions variable `SNAPCRAFT_STORE_CREDENTIALS`,
then delete the local file (do not commit it).

## Developers — local `flutter run`

Use project-root `.env` (from `.env.example`). That path is for development
only; store users never see it.

Override for a local snap test without CI:

```bash
cp .env snap/local/ci_dart_defines.env   # gitignored
# keep only KEY=value lines the build understands
snapcraft pack --use-lxd
rm -f snap/local/ci_dart_defines.env
```
