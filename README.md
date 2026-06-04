# Stars & Pines

A mountain house on Crank's Ridge, Kasar Devi, Almora — 1,645m.

This repository contains the complete digital ecosystem: the public website, the guest portal, and the staff operations app. All three are single HTML files connected through Firebase Realtime Database.

No build step. No framework. No backend server.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE REALTIME DB                      │
│  /orders/  /nudges/  /grievances/  /guest_access/            │
│  /community/ (future)  /menu/ (future)  /perool/ (future)    │
└──────────┬──────────────────────┬────────────────────────────┘
           │                      │
    ┌──────▼──────┐        ┌──────▼──────┐
    │  PUBLIC     │        │  GUEST      │
    │  WEBSITE    │        │  PORTAL     │
    │             │        │             │
    │ stars-and-  │        │ guest-      │
    │ pines-v3    │        │ portal      │
    │ .html       │        │ .html       │
    │             │        │             │
    │ Editorial   │        │ Operational │
    │ Atmospheric │        │ Functional  │
    │ Story       │        │ Field Guide │
    └─────────────┘        └──────┬──────┘
                                  │
                           ┌──────▼──────┐
                           │  RIDGE BELL │
                           │  STAFF APP  │
                           │             │
                           │ ridge-bell- │
                           │ staff-app   │
                           │ .html       │
                           │             │
                           │ Queue       │
                           │ Dispatch    │
                           │ Nudges      │
                           │ Grievances  │
                           └─────────────┘
```

## File Structure

| File | Purpose | Lines |
|---|---|---|
| `stars-and-pines-v3.html` | Public website — editorial, atmospheric, booking | ~2,100 |
| `guest-portal.html` | Guest portal — token-based access, ordering, requests, grievances | ~1,400 |
| `ridge-bell-staff-app.html` | Staff operations — queue, dispatch, nudges, grievances, log | ~2,200 |
| `seed-token.html` | One-time utility to seed a test access token | ~30 |
| `ARCHITECTURE.md` | Full architecture proposal with diagrams and schema | — |
| `AUDIT.md` | System audit — defects, fixes, compatibility matrix | — |
| `PLAN.md` | Integration plan and roadmap | — |

## The Three Apps

### 1. Public Website (`stars-and-pines-v3.html`)

**Job:** Sell the experience. Tell the story.

The website is editorial. It reads like a mountain journal — not a hotel booking site. It focuses on:

- **Crank's Ridge** — history, figures, timeline
- **Philosophy** — why the house exists, what it feels like
- **A Day Here** — morning to night on the ridge
- **Rooms** — six-bed dormitory, mountain double, deluxe twin
- **Reviews** — guest voices, not marketing copy
- **The Guide** — Kasar Devi, trails, sunrise points, contacts
- **Booking** — WhatsApp, Instagram, Booking.com, email, quick enquiry form

**Removed from the public site:**
- Room service ordering (moved to guest portal)
- Guest requests (moved to guest portal)
- Grievances (moved to guest portal)
- Staff interactions (moved to guest portal)

**Performance optimizations:**
- Removed noise grain overlay (GPU repaint on every frame)
- Removed `backdrop-filter: blur()` from nav
- Reduced hero stars from 120 to 50
- Throttled scroll handler with `requestAnimationFrame`
- Added `content-visibility: auto` to reveal sections

### 2. Guest Portal (`guest-portal.html`)

**Job:** Support the stay. A field guide for living on the ridge.

The portal is operational. Available only to active guests via access token.

**Access:** `guest-portal.html?token=ABX72K`

**Sections:**

| Section | Description |
|---|---|
| **Food & Drink** | Full menu with today's specials, kitchen timings, prep time estimates. Cart, order submission, real-time status updates. |
| **House Requests** | One-tap requests: extra blanket, towels, water refill, room cleaning, firepit setup, tea to room. |
| **Concerns** | Grievance system: water issue, noise, room, service, maintenance, other. Higher priority visibility in staff app. |
| **The Ridge Guide** | Operational guide: Kasar Devi Temple, Chitai Temple, Almora Bazaar, Binsar, trails, sunrise points, emergency contacts, taxi contacts. |
| **Perool** | Classy Unisex Woollens — catalogue of objects discovered during a stay. Woollens, handmade clothing, organic products, local crafts. WhatsApp enquiry + Instagram. No checkout. |
| **Community** | Firepit gatherings, community dinners, music nights, workshops, yoga sessions, announcements. Firebase-powered (future). |
| **Your Stay** | Personal area: room info, active orders, order history, request history, grievance history. |

**Menu highlights:**
- Breakfast: Peculiar Poha, Shakshouka
- Burgers: Garden Fresh, Potato vs Paneer, Achaari Chicken
- Sandwiches: Chilli Cheesewich, Habibi, Creamy Shroomwich, Creamy Chickenwich
- Small plates: Patata Balota, Herb Whisperers, Cheesy Aubergine, Falafel Chips, Falafel Wrap, Pizza Toasties
- Large plates: Coconut Quinoa Bowl, Velvet Stroganov, Penne Divino, Grand Hummus Spread, Kumauni Thali
- Soups & Salads: Tomatina, Hearty Supreme, Fruity Fantasy, Bodhi Bowl, The Himalayan
- Beverages: Lime Wire, Rhodo Lover, Apple Gingerina, Thicc Shake, Cold Kaapi

### 3. Ridge Bell Staff App (`ridge-bell-staff-app.html`)

**Job:** Operational dispatch.

A mobile-first staff app designed for the ridge team. Lock screen with user selection, tabbed interface.

**Tabs:**

| Tab | Description |
|---|---|
| **Queue** | Live order queue — pending orders from website, portal, and staff. Mark done/cancel. |
| **Order** | Staff can place orders on behalf of guests. Full menu, room selector, cart. |
| **Nudge** | House requests from guests. One-tap send. Also staff-initiated flags (maintenance, guest concern, low stock, safety). |
| **Concerns** | Guest grievances with priority indicators. Acknowledge and resolve workflow. |
| **Log** | Full activity log — orders, nudges, grievances. Firebase-driven, no static entries. |
| **Me** | Staff profile, property info, WhatsApp contacts, app version. |

**Features:**
- Real-time Firebase sync
- Alert banner + sound + vibration on new orders
- Offline support with write queue
- Online/offline detection
- Confirmation modals for all actions

## Firebase Schema

### Collections

```
/orders/{orderId}
  id: string          — "order_" + timestamp
  room: string        — "Mountain Double", "Dorm Bed 1", etc.
  items: array        — [{ name, qty, price }]
  total: number       — total cost
  status: string      — "pending" | "preparing" | "done" | "cancelled"
  source: string      — "website" | "staff" | "portal"
  createdAt: number   — timestamp
  updatedAt: number   — timestamp
  notes: string       — optional guest notes
  guestToken: string  — links order to guest access token
  guestName: string   — guest name

/nudges/{nudgeId}
  id: string          — "nudge_" + timestamp
  room: string        — room or "General"
  type: string        — "extra_towels", "water_refill", etc.
  message: string     — human-readable
  status: string      — "sent" | "resolved"
  source: string      — "staff" | "portal"
  guestToken: string  — links nudge to guest
  guestName: string   — guest name
  createdAt: number   — timestamp

/grievances/{grievanceId}
  id: string          — "grievance_" + timestamp
  room: string        — guest room
  type: string        — "water_issue", "noise", "room", "service", "maintenance", "other"
  message: string     — guest description
  severity: string    — "low" | "medium" | "high" | "urgent"
  status: string      — "open" | "acknowledged" | "resolved" | "escalated"
  source: string      — "portal"
  guestToken: string  — links to guest
  guestName: string   — guest name
  createdAt: number   — timestamp
  updatedAt: number   — timestamp
  resolvedBy: string  — staff name (when resolved)
  resolvedAt: number  — timestamp
  acknowledgedBy: string — staff name
  acknowledgedAt: number — timestamp

/guest_access/{token}
  token: string       — "ABX72K", "PINE44", "888888", etc.
  guestName: string   — "Priya K."
  room: string        — "Mountain Double"
  active: boolean     — true while stay is active
  validUntil: number  — timestamp (checkout + 1 day buffer)
  createdAt: number   — timestamp
  checkIn: number     — timestamp
  checkOut: number    — timestamp
```

### Future Collections (structure only)

```
/community/{eventId}
  id, title, description, type, date, time, location, active, createdAt

/menu/{category}
  items[], specials[], kitchenOpen, kitchenMessage

/perool/{category}
  items[]
```

## Access Token System

Tokens are 6-character alphanumeric codes: `[A-Z0-9]{6}`

**Examples:** `ABX72K`, `PINE44`, `KAS91P`, `888888`

**Lifecycle:**
1. Created at check-in (manual entry in Firebase console or future Ridge Bell UI)
2. Active during stay
3. Expires 24 hours after checkout
4. Can be manually deactivated by staff

**Validation:**
- Checks `active` field
- Checks `validUntil` timestamp
- Shows elegant access screen if invalid (not a generic error)

## Quick Start

### 1. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project: `stars-and-pines-ridge`
3. Enable **Realtime Database**
4. Set rules to allow read/write (MVP — add validation later)

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

5. Copy the `firebaseConfig` object
6. Replace the config in all three HTML files

### 2. Seed a Test Token

Open `seed-token.html` in a browser. It creates token `888888` in Firebase and gives you a link to the portal.

Or manually add to Firebase:

```json
{
  "guest_access": {
    "888888": {
      "token": "888888",
      "guestName": "Test Guest",
      "room": "Mountain Double",
      "active": true,
      "validUntil": 9999999999999,
      "createdAt": 1717500000000
    }
  }
}
```

### 3. Open the Apps

| App | URL |
|---|---|
| Public website | `stars-and-pines-v3.html` |
| Guest portal | `guest-portal.html?token=888888` |
| Staff app | `ridge-bell-staff-app.html` |

### 4. Test the Flow

1. Open guest portal → add food items → send order
2. Open staff app → see order in queue → mark done
3. Guest portal → Your Stay → see order status update
4. Guest portal → raise a grievance → staff app → see in Concerns tab

## Content Philosophy

### Place-Centric Storytelling

The ridge is the protagonist. People are custodians.

| Before | After |
|---|---|
| "Rajat and Raman built a place..." | "Stars & Pines is a mountain house on Crank's Ridge..." |
| "They didn't come from hospitality..." | "The house started the way good places do — from knowing what this ridge feels like..." |
| "They'll know your name..." | "Your name is known before check-in..." |

### Menu Personality

Menu items have mountain-cafe character. Not generic restaurant descriptions.

- **Peculiar Poha** — "A mountain-café take on the classic, bright with fresh herbs, roasted peanuts, and a few unexpected twists from the chef's mood."
- **Potato vs Paneer** — "A friendly clash of two Indian favorites—crispy potato and soft paneer—united in one indulgent burger."
- **Lime Wire** — "A sharp, refreshing lime cooler that wakes up the senses like a mountain breeze."

### Perool Positioning

Not e-commerce. Not Amazon. Objects discovered during a stay on the ridge.

- Field journal aesthetic
- Mountain workshop feel
- Handmade goods, slow craftsmanship
- WhatsApp enquiry + Instagram only
- No checkout, no cart, no payment

## Defects Fixed

| Issue | Fix |
|---|---|
| WhatsApp placeholders | Config pattern retained, clear placeholder comment |
| Extra naan persistence | Reads order from Firebase, appends naan, writes full items array |
| Initial alert spam | `initialSyncComplete` flag — skips `child_added` alerts during first sync |
| Website success on Firebase failure | Promise-based push, error toast on failure |
| Static log entries | Removed, loads from Firebase order/nudge/grievance history |

## Performance

| Optimization | Impact |
|---|---|
| Removed noise grain overlay | Eliminates GPU repaint on every frame |
| Removed `backdrop-filter: blur()` from nav | Reduces compositing cost on scroll |
| Reduced hero stars from 120 to 50 | Fewer animated DOM elements |
| Throttled scroll handler with `requestAnimationFrame` | Prevents scroll jank |
| Added `content-visibility: auto` to reveal sections | Browser skips off-screen rendering |
| Removed all ordering CSS from website (~250 lines) | Smaller stylesheet, faster parse |

## Remaining Items

| Item | Priority | Notes |
|---|---|---|
| WhatsApp number | LOW | Replace `REPLACE_ME` in all three files |
| Token generation UI | MEDIUM | Add to Ridge Bell for staff to create tokens at check-in |
| Dynamic menu from Firebase | LOW | Currently hardcoded in portal |
| Community events management | LOW | Add CRUD in Ridge Bell |
| Perool from Firebase | LOW | Currently hardcoded in portal |
| Database rules | MEDIUM | Add basic validation rules |
| Capacitor APK build | LOW | Package Ridge Bell as Android APK |

## Tech Stack

- **Frontend:** Vanilla HTML, CSS, JavaScript — no framework, no build step
- **Database:** Firebase Realtime Database
- **SDK:** Firebase v10.12.0 (compat)
- **Fonts:** Playfair Display, EB Garamond, Outfit, DM Sans (Google Fonts)
- **Mobile:** Ridge Bell designed for Capacitor APK (max-width: 430px, safe-area insets)

## Deployment

Each file is self-contained. Deploy anywhere:

- Firebase Hosting
- GitHub Pages
- Netlify
- Vercel
- Any static file server

No build step. No dependencies to install. Just serve the HTML files.

## License

Private — Stars & Pines.
