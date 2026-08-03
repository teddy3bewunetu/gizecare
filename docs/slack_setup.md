# Slack setup for ጊዜCare

GizeCare connects with a **Slack user token** (your channels and DMs), via OAuth on Linux desktop. Messages are cached locally in Drift. While the Slack page is open, GizeCare **polls live** (active chat ~3s, conversation list ~20s).

## 1. Create a Slack app

1. Open [https://api.slack.com/apps](https://api.slack.com/apps) → **Create New App** → **Blank app**.
2. Pick a name (e.g. `GizeCare`) and your workspace.
3. Under **OAuth & Permissions**:
   - **Redirect URLs** → add:
     ```
     http://127.0.0.1:8766/callback
     ```
   - Under **User Token Scopes**, add:
     - `channels:read`, `channels:history`
     - `groups:read`, `groups:history`
     - `im:read`, `im:history`
     - `mpim:read`, `mpim:history`
     - `chat:write`
     - `users:read`
     - `reactions:read`, `reactions:write`
     - `files:read`, `files:write`
4. **Install App** to your workspace (or **reinstall** after changing scopes).
5. Copy **Client ID** and **Client Secret** from **Basic Information**.

## 2. Configure `.env`

```env
SLACK_CLIENT_ID=your_client_id
SLACK_CLIENT_SECRET=your_client_secret
```

See [`.env.example`](../.env.example).

## 3. Connect in the app

1. Open **Messages → Slack**.
2. Click **Connect Slack** (Linux only).
3. Approve access in the browser; return to GizeCare.
4. Browse channels/DMs. A **Live** badge means foreground polling is active.
5. Features: send text, **threads**, **reactions**, **file attach**, edit/delete (right-click / long-press).

## After adding scopes

If you already connected before reactions/files scopes existed:

1. Add the scopes in the Slack app → **Reinstall to workspace**.
2. In GizeCare: **Disconnect** → **Connect Slack** again so the new scopes are granted.

## Notes

- Tokens are stored on the machine (secure storage + file fallback), not in Drift.
- **Disconnect** clears local Slack cache and tokens.
- Realtime uses **polling** (not Socket Mode) so DMs and private channels work with the user token.
- Google Calendar OAuth uses port `8765`; Slack uses `8766` so both can coexist.
