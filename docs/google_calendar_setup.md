# Google Calendar setup (Linux desktop)

GizeCare connects to Google Calendar with an **installed-app OAuth** loopback on Linux.

The **Client ID / Client Secret** identify the GizeCare app (same for every user).  
Each person still clicks **Connect Google** and signs in with their own account; access tokens are stored per machine.

## 1. Google Cloud project

1. Open [Google Cloud Console](https://console.cloud.google.com/).
2. Create or select a project.
3. Enable **Google Calendar API**.
4. Configure the OAuth consent screen (External or Internal).
5. Add scopes:
   - `https://www.googleapis.com/auth/calendar`
   - `https://www.googleapis.com/auth/gmail.modify` (shared OAuth with Gmail)
   - `https://www.googleapis.com/auth/userinfo.email`

Gmail uses the same Desktop OAuth client — see [docs/gmail_setup.md](gmail_setup.md).
Also enable **Gmail API** in the Cloud project if you want mail in GizeCare.

## 2. OAuth Desktop client

1. **APIs & Services → Credentials → Create credentials → OAuth client ID**.
2. Application type: **Desktop app** (not Web application).
3. Copy **Client ID** and **Client secret**.

You will **not** see a place to type `http://127.0.0.1:8765/`. That is normal.

For **Desktop** clients, Google already allows the loopback redirect our app uses:

```text
http://127.0.0.1:8765
```

(No console entry required.)

If you created a **Web application** client by mistake, either:

- Create a new client with type **Desktop app**, or  
- On the Web client, under **Authorized redirect URIs**, add `http://127.0.0.1:8765` (and optionally `http://localhost:8765`).

## 3. Consent screen (testing)

1. **OAuth consent screen** → keep status **Testing**.
2. Add yourself under **Test users**.
3. If you see “Google hasn’t verified this app”, click **Advanced** → continue to the app.

## 4. Put credentials in `.env`

```bash
cp .env.example .env
```

Edit `.env`:

```env
GOOGLE_CALENDAR_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CALENDAR_CLIENT_SECRET=your-client-secret
```

`.env` is gitignored — do not commit real secrets.

Then run normally from the project root:

```bash
flutter run -d linux
```

### Overrides (optional)

If set, these win over `.env`:

```bash
flutter run -d linux \
  --dart-define=GOOGLE_CALENDAR_CLIENT_ID=... \
  --dart-define=GOOGLE_CALENDAR_CLIENT_SECRET=...
```

Process environment variables with the same names also work as a fallback.

## 5. Connect in the app

1. Open **Calendar** in the sidebar.
2. Click **Connect Google**.
3. Sign in and approve access in the browser.
4. Return to GizeCare — events sync into the day/week view.

## Notes

- Tokens are stored with `flutter_secure_storage` (Linux: libsecret / keyring).
- Connect Google is available on **Linux desktop** only in this MVP.
- Creating **New Event** writes to your Google primary calendar.
