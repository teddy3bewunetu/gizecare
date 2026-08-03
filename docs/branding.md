# ጊዜCare (GizeCare) — Branding

## Name

| Form | Use |
| --- | --- |
| **ጊዜCare** | Display name in UI, window chrome, and marketing |
| **GizeCare** | Package id, paths, logs, English-facing docs |
| **gizecare** | Repository / pub package name |

**Gize (ጊዜ)** means *time* in Amharic.  
**Care** means protecting that time — not only measuring it.

Together: care for your time by putting the workday in one place.

---

## Tagline

**Primary**

> Your workday. One place.

**Supporting (one sentence)**

> One place for your workday — so your time isn’t spent finding it.

**Product blurb (short)**

> ጊዜCare is an offline-first workday hub: track time, manage projects and tasks, take notes, keep documents, and reach Calendar, Gmail, and Telegram without juggling separate apps.

**Product blurb (long)**

> ጊዜCare (GizeCare) is an offline-first workday hub for freelancers, engineers, designers, and professionals. It brings time tracking, projects, tasks, notes, documents, calendar, Gmail, and Telegram into one desktop and mobile workspace — less context-switching, less resource drain, faster access to everything you need to get work done.

---

## Vision

A world where professionals spend their time on the work itself — not on opening, switching between, and maintaining a scattered stack of apps.

ጊዜCare becomes the calm home for the workday: time, tasks, notes, documents, and essential communication in one trusted place.

---

## Mission

Protect people’s time by unifying the tools of a workday into a single, offline-first workspace that is fast to reach, light on the machine, and clear about where time goes.

We do this by:

- Keeping the **time spine** strong (tracker, activity, reports)
- Folding in **daily work surfaces** (notes, documents, projects, tasks, calendar)
- Bringing **essential communication** closer (Gmail, Telegram) without forcing people to live in a dozen windows
- Preferring **local-first** data and a light footprint over cloud lock-in

---

## Values

### 1. Time is the product
Every feature should save time or make time visible. If it only adds noise, it does not belong.

### 2. One place over many windows
We reduce app-hopping and workspace clutter. Accessibility of notes, mail, chat, calendar, and tracking should feel immediate — not like launching a second OS.

### 3. Light footprint
Fewer always-on apps means less RAM, fewer distractions, and a quieter desktop. Prefer efficiency over feature theater.

### 4. Offline-first, user-owned
Core work data lives on the user’s machine. Integrations (Calendar, Gmail, Telegram) serve the workspace; they do not own it.

### 5. Clarity over clutter
One job per surface. Honest copy. No dashboard wallpaper of empty metrics. The brand should feel focused, not busy.

### 6. Cultural honesty
The Amharic root of the name is intentional identity, not decoration. Prefer ጊዜCare in the UI; explain GizeCare when English clarity helps.

---

## Positioning

| We are | We are not |
| --- | --- |
| A **workday hub** with a time-care spine | Only a time tracker that bolted on extras |
| A way to **decrease access time** to everyday work tools | A full replacement for every specialist app |
| **Offline-first** with selective cloud integrations | A cloud suite that requires an account to think |
| Built for **freelancers and focused professionals** | An enterprise collaboration platform |

**Elevator pitch (15 seconds)**  
ጊዜCare cares for your time by putting your workday in one app — track hours, run projects, take notes, and reach calendar, mail, and Telegram without jumping between windows or burning resources on a dozen open tools.

---

## Voice & tone

- **Direct** — say what the product does; avoid vague “productivity” fluff  
- **Calm** — confident, not hypey; no emoji noise in brand surfaces  
- **Concrete** — prefer “one place for notes, mail, and tracking” over “supercharge your workflow”  
- **Respectful of time** — short sentences; the brand practices what it preaches  

---

## Product pillars (what “one place” means)

1. **Time** — tracker, idle awareness, screenshots, reports  
2. **Work** — projects, tasks, boards  
3. **Capture** — notes, documents  
4. **Schedule** — calendar  
5. **Connect** — Gmail, Telegram (scoped / allowlisted where needed)  

Time remains the spine; the other pillars exist to protect it.

---

## Logo

Primary mark: open cyan ring with a single center pointer and a pixel trail
breaking toward the upper-right — time as motion into a digital workspace.

| Asset | Path |
| --- | --- |
| **In-app SVG (preferred)** | `assets/brand/gc-logo.svg` |
| Brand tile (black bg) | `assets/brand/gc-logo.png` |
| Raster fallback | `assets/brand/gc-logo-mark.png` |
| Legacy alias | `assets/brand/logo.png` |
| App icons | `assets/icons/app_icon_*.png` |
| Tray (active / idle) | `assets/icons/tray_icon_*.png` |
| Linux window fallback | `linux/runner/resources/gizecare.png` |

Colors: cyan `#009DFE` on ink/black. Sidebar uses **`gc-logo.svg`** via
`flutter_svg` (sharp at any size) with the wordmark vertically centered.
Replace `gc-logo.svg` with your design-tool export to match the brand 1:1.
Idle tray / launcher still use PNG.

## Usage notes

- Prefer **ጊዜCare** in UI chrome and headings.  
- Use **GizeCare** in file paths, OAuth consent screens, device model strings, and English-only contexts.  
- Lead marketing and README with the **primary tagline**, then the short blurb.  
- Feature buttons may still say “time tracker” when they open the *Tracker* feature specifically — that is a surface name, not the product identity.
