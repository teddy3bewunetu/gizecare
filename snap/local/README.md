# Deploy GizeCare to the Snap Store

This folder packages the Linux app as a **snap** so users can install it with:

```bash
sudo snap install gizecare
```

You already have a Snapcraft / Ubuntu One account. Follow the steps below on Ubuntu (or another Linux distro that supports snapd + LXD).

---

## What you need

| Tool | Why |
|------|-----|
| **Snapcraft** | Builds the `.snap` file from `snapcraft.yaml` |
| **LXD** | Isolated container where Snapcraft compiles Flutter (cleaner, recommended) |
| **Snap Store account** | Login + upload (you already have this) |

---

## One-time setup

### 1. Install Snapcraft and LXD

```bash
sudo snap install snapcraft --classic
sudo snap install lxd
sudo lxd init --auto
```

`lxd init --auto` creates a default LXD setup (storage + network). Accept defaults if you run it interactively instead.

### 2. Add your user to the `lxd` group

```bash
sudo usermod -aG lxd "$USER"
```

**What this means (plain language):**

- LXD is managed by a Unix **group** named `lxd`.
- Only users in that group can talk to the LXD daemon (start containers, build snaps).
- `usermod -aG lxd "$USER"` **appends** (`-a`) your current username (`$USER`) to the **group** (`-G`) `lxd`.
- It does **not** change your password or delete other groups.

**Why you still see “LXD requires additional permissions”:**

- `usermod` updates the system group list, but your **current terminal** still has the old groups.
- Check with `groups`. If `lxd` is missing, the session is stale even if the account is already in the group.

**Fix for this terminal (no logout):**

```bash
newgrp lxd
groups          # should now list lxd
snapcraft --use-lxd
```

Or one-shot without changing the shell:

```bash
sg lxd -c 'snapcraft --use-lxd'
```

**Permanent fix:** log out of the desktop (or reboot) and log back in, then open a new terminal. After that, plain `snapcraft --use-lxd` works.

**Verify LXD:**

```bash
lxc info
```

If that prints info without a permission error, you are ready.

### 3. Log in to the Snap Store

```bash
snapcraft login
```

Use the same Ubuntu One / Snapcraft account you already have.

### 4. Register the snap name (once)

The name must match `name:` in `snapcraft.yaml` (`gizecare`):

```bash
snapcraft register gizecare
```

If the name is taken, change `name:` in `snapcraft.yaml` (and the desktop/icon filenames under `snap/gui/`) to a free name, then register that instead.

---

## Build the snap

From the **project root** (the folder that contains `pubspec.yaml` and `snap/`):

```bash
cd "/path/to/gizecare"
# Stop any local `flutter run` first — it regenerates build/ with host paths.
rm -rf build/
snapcraft pack --use-lxd
```

The first build downloads Flutter inside LXD and can take a long time. When it finishes you get a file like:

```text
gizecare_0.1.0_amd64.snap
```

**Tip:** If the project path contains spaces (e.g. `my projects`) and LXD fails oddly, clone or copy the repo to a path without spaces and build there.

**CMakeCache path errors:** usually caused by a leftover host `build/` from `flutter run`. Stop that process, `rm -rf build/`, then pack again. `snapcraft.yaml` also deletes `build/` inside the container before compiling.

---

## Test locally before uploading

```bash
sudo snap install ./gizecare_*.snap --dangerous
gizecare
```

`--dangerous` is normal for a local `.snap` that is not yet from the store.

Remove the test install:

```bash
sudo snap remove gizecare
```

---

## Publish to the Snap Store

Upload and release to the **edge** channel (good for first releases):

```bash
snapcraft upload --release=edge *.snap
```

Other risk levels (when you are ready):

| Channel | Typical use |
|---------|-------------|
| `edge` | Continuous / early builds |
| `beta` | Wider testing |
| `candidate` | Release candidate |
| `stable` | Public default install |

Example for a tagged release:

```bash
snapcraft upload --release=candidate gizecare_0.1.0_amd64.snap
```

Promote an already-uploaded revision later:

```bash
snapcraft status gizecare
snapcraft release gizecare <revision> stable
```

---

## Files in this folder

| Path | Role |
|------|------|
| `snapcraft.yaml` | How to build and what permissions the app needs |
| `gui/gizecare.desktop` | App menu entry (name, icon, categories) |
| `gui/gizecare.png` | Icon shown in the desktop / launcher |

---

## Optional: GitHub Actions

`.github/workflows/snapcraft.yml` can build and upload on pushes to `main` or tags `v*.*.*`.

To enable it, create a repository secret `SNAPCRAFT_STORE_CREDENTIALS`:

```bash
snapcraft export-login \
  --snaps=gizecare \
  --channels=edge,candidate,stable \
  --acls=package_upload,package_release \
  snapcraft-creds.txt
```

Paste the file contents into GitHub → **Settings → Secrets and variables → Actions → New repository secret** → name `SNAPCRAFT_STORE_CREDENTIALS`. Delete the local `snapcraft-creds.txt` afterward.

You do **not** need CI to publish; local `snapcraft upload` is enough.

---

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| `cannot connect to the LXD socket` / `LXD requires additional permissions` | Run `newgrp lxd` (or log out/in). See section 2 above. |
| `A network related operation failed` / no network in LXD | Docker/UFW often blocks LXD outbound traffic. Fix (run once, then rebuild): see **LXD network fix** below. |
| `snap name already taken` | Register a different name and update `snap/snapcraft.yaml` + `snap/gui/*`. |
| `CMakeCache.txt` path mismatch / Unable to generate build files | Stop `flutter run`, then `rm -rf build/ && snapcraft clean gizecare && snapcraft pack --use-lxd`. |
| `PkgConfig::mpv` target was not found | Needs `libmpv-dev` in the snap build (already in `snapcraft.yaml`). Clean the part and rebuild. |
| `flutter_quill` / `pdfrx` compile errors in Snapcraft | Snap was using a newer Flutter than this repo. Build pins **Flutter 3.38.3** (see `flutter-sdk` part). After changing the pin: `snapcraft clean && snapcraft pack --use-lxd`. |
| Build fails on WebKit / GTK | Clean and retry: `snapcraft clean && snapcraft pack --use-lxd`. |
| App cannot access network / files | Strict snaps use plugs listed in `snapcraft.yaml`. After store review, some interfaces may need manual connection once. |
| App exits immediately / `libblas.so.3: cannot open shared object file` | Debian stages BLAS/LAPACK under `blas/` and `lapack/` without alternatives soname links. `snapcraft.yaml` recreates `libblas.so.3` / `liblapack.so.3` in `override-prime`. Rebuild and republish if you changed staging. |
| App exits with `libEGL fatal: did not find extension DRI_Mesa version 1` | Staged Mesa/GL from `libmpv` conflicts with the gnome platform. `override-prime` strips those libs so graphics come from gnome-platform + `opengl`. |

### LXD network fix (Docker / UFW)

If Snapcraft creates a container but then fails with **no network access**, your host can reach the internet, but the LXD container cannot. On machines that also run **Docker**, this is common.

In a terminal where `sudo` works, run:

```bash
# Allow forwarded traffic that Docker would otherwise drop
sudo iptables -I DOCKER-USER -j ACCEPT

# If you use UFW, allow LXD bridge forwarding (lxdbr0)
sudo ufw allow in on lxdbr0
sudo ufw route allow in on lxdbr0
sudo ufw reload
```

Then retry:

```bash
newgrp lxd   # if needed
snapcraft clean
snapcraft pack --use-lxd
```

Quick check that an LXD container has internet:

```bash
lxc launch ubuntu:22.04 nettest
lxc exec nettest -- getent hosts snapcraft.io
lxc delete -f nettest
```

If `getent` prints an IP, networking is fixed.

---

## Version bumps

When you release a new version:

1. Update `version:` in `pubspec.yaml` and in `snap/snapcraft.yaml` (keep them aligned).
2. Rebuild: `snapcraft --use-lxd`
3. Upload: `snapcraft upload --release=edge *.snap` (or `candidate` / `stable`)
