# Telegram (Client API) setup for ጊዜCare

GizeCare connects as **your Telegram user** via [TDLib](https://core.telegram.org/tdlib) (`libtdjson`), then lets you **allowlist** private chats, groups, and channels. Only allowlisted chats sync and appear in the app.

> Telegram does not offer OAuth-style “only these chats.” The session can access your account; GizeCare **enforces** the allowlist in-app.

## 1. Create API credentials

1. Open [https://my.telegram.org](https://my.telegram.org) and log in.
2. Open **API development tools** → create an application.
3. Copy **api_id** and **api_hash**.

Add to project `.env`:

```env
TELEGRAM_API_ID=12345678
TELEGRAM_API_HASH=your_api_hash_here
# Quote paths that contain spaces. Do NOT write my\ projects.
TELEGRAM_TDLIB_PATH="/home/teddy3/code/my projects/build/td/build/libtdjson.so"
```

## 2. Install TDLib (`libtdjson.so`) on Linux

GizeCare loads `libtdjson` through Dart FFI. Build TDLib once (or install a distro package if available):

```bash
# Example: build TDLib (needs cmake, g++, zlib, openssl, gperf…)
git clone --depth 1 https://github.com/tdlib/td.git
cd td
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --target tdjson -j"$(nproc)"
# Locate libtdjson.so and set TELEGRAM_TDLIB_PATH to it
```

Also tried automatically:

- `libtdjson.so` (loader path)
- `/usr/local/lib/libtdjson.so`
- `/usr/lib/libtdjson.so`
- `./libtdjson.so` / `./native/libtdjson.so` in the project root

## 3. Use in the app

1. Hot restart after filling `.env`.
2. Open **Telegram** in the sidebar.
3. **Connect** → phone → login code → optional 2FA password.
4. **Choose chats** → select DMs / groups / channels → Save.
5. Open an allowlisted chat to read/send text messages.

## 4. Disconnect

**Disconnect** logs out TDLib, deletes the local TDLib database under app support (`telegram_tdlib/`), and clears cached chats/messages.

## Scope (MVP)

- Linux desktop
- Text messages (media shown as placeholders)
- App-level chat allowlist
- No secret chats, no multi-account

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Missing API credentials | Fill `.env` and restart |
| Could not load libtdjson.so | Local: build TDLib and set `TELEGRAM_TDLIB_PATH`. Snap: use a release that includes the `tdlib` part (do not copy a 24.04 host `.so` into the snap — glibc mismatch). |
| Snap install missing Google/Slack/Telegram API config | CI must bake dart-defines from Actions Variables — see `docs/snap_setup.md` |
| Auth error | Check phone format (`+…`), code, 2FA |
| Empty chat list | Sync / Choose chats after connect; wait a few seconds for TDLib to load dialogs |
