# Gmail setup (Linux desktop)

GizeCare reads and sends Gmail through the official **Gmail API**, using the
**same Google OAuth client** as Calendar.

## 1. Google Cloud

1. Open the same project used for Calendar ([docs/google_calendar_setup.md](google_calendar_setup.md)).
2. Enable **Gmail API** (APIs & Services → Library → Gmail API → Enable).

   Direct link (replace with your project if different):
   https://console.developers.google.com/apis/api/gmail.googleapis.com/overview

   If Connect works but sync says the API is disabled, this step is missing.
   After enabling, wait ~1 minute, then tap Refresh in GizeCare.
3. On the OAuth consent screen, add scope:
   - `https://www.googleapis.com/auth/gmail.modify`
4. Keep Calendar + `userinfo.email` scopes as before.

While the app is in **Testing**, add your Google account under **Test users**.

## 2. Credentials

Reuse existing `.env` values (no new client required):

```env
GOOGLE_CALENDAR_CLIENT_ID=...
GOOGLE_CALENDAR_CLIENT_SECRET=...
```

## 3. Connect in the app

1. Open **Gmail** in the sidebar.
2. Click **Connect Gmail** and finish the browser consent (include Gmail).
3. Inbox syncs into a local cache; open a thread to load full messages.
4. Use **Compose** / **Reply** to send.

If you previously connected **Calendar only**, Connect Gmail again so Google
returns a refresh token that includes the Gmail scope. If consent skips Gmail,
revoke GizeCare at [Google Account permissions](https://myaccount.google.com/permissions)
and Connect again.

## Notes

- Linux desktop MVP (same OAuth loopback as Calendar).
- `gmail.modify` allows read, send, and label changes (mark read); it does not
  grant full mailbox admin.
- Disconnect on the Gmail page clears the local mail cache only; Calendar tokens
  stay until you disconnect Google from Calendar / revoke access.
