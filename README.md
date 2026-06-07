# Stars & Pines — Complete Operations System

A full-stack guest-to-staff operations system for a mountain property on Crank's Ridge, Kasar Devi, Almora — 1,645m.

**What it is:** Five connected surfaces that replace paper menus, walkie-talkie requests, and front-desk friction with a seamless guest portal, staff dispatch app, and live operations dashboard. No hardware. No servers. No training. Works on any phone.

**What it costs to run:** Firebase free tier. Zero infrastructure. Zero maintenance.

---

## System Architecture

```
Staff (Ridge Bell App)
  → Generates 6-digit access code + QR
  → Shares via WhatsApp or prints QR

Guest (scans QR or enters code)
  → Enters 6-digit code in Guest Portal
  → Orders food, raises grievances, requests services

Dashboard (Operations Center)
  → Sees all orders in real-time
  → Sees all grievances, nudges, experiences, concierge requests
  → Manages inventory, rooms, tasks, devices
  → Monitors water, power, lighting, music

All connected via Firebase Realtime Database
```

---

## Quick Start

### Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize (if not done)
firebase init hosting

# Deploy
firebase deploy
```

### URLs After Deploy

| Surface | URL | Purpose |
|---|---|---|
| Marketing Site | `https://stars-and-pines-ridge.web.app/` | Public website, bookings |
| Guest Portal | `https://stars-and-pines-ridge.web.app/portal` | Guest self-service |
| Staff App | `https://stars-and-pines-ridge.web.app/staff` | Staff operations |
| Dashboard | `https://stars-and-pines-ridge.web.app/dashboard` | Operations center |
| Guest Entry | `https://stars-and-pines-ridge.web.app/entry` | QR generation, guest registration |

---

## Complete Guest Journey

### Before Arrival

1. Guest finds the website — it reads like a mountain journal, not a hotel booking page
2. They see the rooms, the guide, the reviews
3. They reach out via WhatsApp, Instagram, or the quick enquiry form
4. Booking happens the way it always does — directly

### At Check-In

1. Staff opens the Ridge Bell app, enters the guest's name and room
2. A unique 6-character access code is generated (e.g., `ABX72K`)
3. Staff shares it via WhatsApp or shows a QR code
4. That's it. No app download. No login. No password.

### During the Stay

The guest opens their portal on their phone:

**"I'm hungry"** → Opens Food tab → browses the menu → adds items → sends order → watches it go from "Pending" to "Preparing" to "Ready"

**"I need extra blankets"** → Opens Requests tab → taps "Extra Blankets" → done. Staff sees it immediately.

**"The water isn't hot"** → Opens Concerns tab → selects "Water issue" → writes a message → submits. It appears in the staff app with a priority flag. Staff acknowledges. Guest sees the status update.

**"What should I do today?"** → Opens Guide tab → sees Kasar Devi Temple, the unmarked ridge walk, Crank's Ridge Café, sunrise points, emergency contacts. Can bookmark places.

**"I want to join the bonfire"** → Opens Experiences tab → requests bonfire, local guide, bird watching, stargazing, transport.

**"I need a taxi"** → Opens Concierge tab → taps "Taxi" → staff arranges it.

### At Checkout

Staff deactivates the guest's access code. The portal stops working. Clean.

---

## What's Included

### 1. Public Website (`index.html`)

- Full editorial website with mountain-journal storytelling
- Hero with animated starfield and SVG mountains
- "Why People Come" — silence, light, company
- "A Day Here" — morning to night on the ridge
- "The House" — philosophy and warmth
- Three room types with details and pricing
- The Kasar Guide — temples, trails, cafes, sunrise, town, day trips
- Guest reviews
- Booking channels: WhatsApp, Instagram, Booking.com, email
- Quick WhatsApp enquiry form with live message preview
- Six easter eggs (hidden star, torn note, polaroid, terrace lightbox, room observation, footer secret)
- Analytics tracking (scroll depth, section views, WhatsApp clicks)

### 2. Guest Portal (`guest-portal.html`)

- Token-based access — no login, no password, no download
- **Food & Drink** — full menu with search, category filters, cart, order submission, real-time status
- **House Requests** — one-tap: blanket, towels, water, cleaning, firepit, tea
- **Concerns** — 9 grievance types, urgency selector, message field, status tracking
- **Ridge Guide** — places, trails, contacts, bookmarkable entries
- **Experiences** — bonfire, local guide, photography, village walk, bird watching, stargazing, transport, special meals
- **Concierge** — blankets, cleaning, hot water, laundry, taxi, wake-up call, medical, luggage
- **Your Stay** — personal dashboard: room info, active orders, history, requests, concerns, experiences

### 3. Ridge Bell Staff App (`ridge-bell-staff-app.html`)

- Lock screen with staff profiles
- **Queue** — live order queue, mark done/cancel, completed history
- **Order** — staff places orders for guests, room selector, full menu
- **Nudge** — guest requests, staff flags, extra naan button
- **Concerns** — grievances with priority, acknowledge → resolve workflow
- **Log** — full activity history from Firebase
- **Me** — staff profile, guest check-in, QR code generator, property info
- Incoming order alerts (banner + sound + vibration)
- Offline support with automatic sync
- Online/offline detection

### 4. Operations Dashboard (`stars-and-pines-dashboard.html`)

- **Overview Page:**
  - Live heartbeat bar (guests, beds, events, tasks, water, power, kitchen, grievances, inventory)
  - Live feed (merged grievances + nudges timeline)
  - Guest requests panel (experiences + concierge)
  - Occupancy snapshot (dorms + private rooms)
  - Today's schedule timeline
  - Open tasks list
  - Water tank visual
  - Revenue today breakdown

- **Occupancy Page:**
  - Dorm A/B/C bed grids (occupied/vacant/cleaning)
  - Private rooms table with check-in/check-out
  - Live guest list from Firebase
  - Check-out button per guest

- **Kitchen & Inventory Page:**
  - Live order queue (from Firebase)
  - Inventory by category (produce, dairy, cafe, cleaning)
  - Low stock alerts
  - Restock buttons

- **Menu Page:**
  - Menu items with availability toggles
  - Hot drinks, cold drinks, food categories

- **Events Page:**
  - Today's events with progress bars
  - Upcoming events table

- **Maintenance Page:**
  - Open tasks with priority
  - Completed tasks
  - Add quick task

- **Water Page:**
  - Tank level visual
  - Motor status
  - Daily usage history
  - Alert rules

- **Lighting & Power Page:**
  - Zone controls (7 zones)
  - Brightness sliders
  - Toggle switches
  - Power summary
  - Scene presets

- **Music & Ambience Page:**
  - Now playing display
  - Playlists
  - Speaker zones with volume sliders
  - Announcements

- **Analytics Page:**
  - Weekly revenue, occupancy, orders, water usage
  - Daily revenue breakdown
  - Most ordered items
  - Occupancy rate

### 5. Guest Entry (`guest-entry.html`)

- Staff generates QR codes for guests at check-in
- Guest scans QR → registration form → welcome → enters portal
- Or staff shares the link via WhatsApp directly
- 6-digit alphanumeric token generation
- Guest registration (name, phone, email, emergency contact, arrival method)

---

## Firebase Schema

### Production Paths

| Path | Writer | Reader | Purpose |
|---|---|---|---|
| `/guest_access/{token}` | Staff App, Guest Entry | Guest Portal, Dashboard | Guest access tokens |
| `/orders/{pushId}` | Guest Portal, Staff App | Guest Portal, Staff App, Dashboard | Food orders |
| `/nudges/{pushId}` | Guest Portal, Staff App | Guest Portal, Staff App, Dashboard | House requests |
| `/grievances/{pushId}` | Guest Portal | Guest Portal, Staff App, Dashboard | Guest concerns |
| `/experiences/{pushId}` | Guest Portal | Guest Portal, Dashboard | Experience requests |
| `/concierge/{pushId}` | Guest Portal | Guest Portal, Dashboard | Concierge requests |
| `/events/{pushId}` | Marketing Site | — | Analytics events |

### Dashboard Paths

| Path | Writer | Reader | Purpose |
|---|---|---|---|
| `/rooms/{key}` | Dashboard | Dashboard | Room/bed state |
| `/inventory/{category}/{key}` | Dashboard | Dashboard | Stock levels |
| `/tasks/{pushId}` | Dashboard | Dashboard | Maintenance tasks |
| `/devices/{key}` | Dashboard, Pi | Dashboard | IoT device state |
| `/notifications/{pushId}` | Dashboard | Dashboard | System alerts |
| `/activity_feed/{pushId}` | All apps | Dashboard | Activity log |

---

## File Structure

```
StarsPines/
├── index.html                      # Marketing website
├── guest-portal.html               # Guest self-service portal
├── ridge-bell-staff-app.html       # Staff operations app
├── stars-and-pines-dashboard.html  # Operations dashboard
├── guest-entry.html                # Guest entry & QR generation
├── seed-data.html                  # Database seeding tool
├── seed-token.html                 # Test token generator (dev only)
├── firebase.json                   # Firebase Hosting config
├── database.rules.json             # Firebase RTDB security rules
├── js/
│   └── firebase-config.js          # Shared Firebase configuration
├── DELIVERABLES.md                 # Complete system documentation
├── firebase-schema.md              # Firebase path inventory
├── integration-audit.md            # System audit findings
├── ARCHITECTURE.md                 # System architecture
├── DIAGRAMS.md                     # Visual diagrams
├── FLOWCHARTS.md                   # User flow diagrams
├── PLAN.md                         # Project plan
├── AUDIT.md                        # Initial audit
└── README.md                       # This file
```

---

## The Numbers

| Metric | Value |
|---|---|
| Total active files | 5 HTML files + 1 shared JS |
| Total code | ~12,000+ lines |
| Total size | ~420 KB (all apps combined) |
| External dependencies | Firebase SDK, Google Fonts, QR code library |
| Server required | None |
| Build step | None |
| Training required | None — tap and go |
| Monthly hosting cost | Free (Firebase free tier) |

---

## Why This Works for Your Property

### No New Hardware

Your staff already have phones. Your guests already have phones. Nothing to buy.

### No Training

The staff app is six tabs. Tap an order, mark it done. Tap a request, note it. Tap a concern, acknowledge it. If someone can use WhatsApp, they can use this.

### No App Download

Guests open a link. That's it. No App Store, no Play Store, no "download our app" friction.

### No Internet Dependency

Works offline. Queues everything. Syncs when the connection returns. Mountain internet is unreliable — this system expects that.

### Real-Time, Not Batch

Orders appear instantly. Status updates instantly. No "let me check with the kitchen." No "I'll write that down."

### Everything Is Recorded

Every order, every request, every concern. Full history. No "I never got that request." No "who placed that order?"

### Scales With You

One room or fifty rooms — the system works the same. Add more staff, more guests, more rooms. No reconfiguration.

---

## Technical Details

### Tech Stack

- **Frontend:** Vanilla HTML, CSS, JavaScript — no framework, no build step
- **Database:** Firebase Realtime Database
- **SDK:** Firebase v10.12.0
- **Fonts:** Libre Baskerville, DM Mono, Instrument Sans (Google Fonts)
- **QR Codes:** qrcode@1.5.3
- **Audio:** Web Audio API (no external sound files)
- **Mobile:** Designed for any phone, works in browser

### Firebase Setup

1. Create a Firebase project (`stars-and-pines-ridge`)
2. Enable Realtime Database
3. Set rules to allow read/write (see `database.rules.json`)
4. Config is already in all HTML files
5. Deploy with `firebase deploy`

### Access Tokens

6-character codes (e.g., `ABX72K`). Generated at check-in. Active during stay. Expire 24 hours after checkout. Can be deactivated manually.

### Offline Support

The staff app queues all writes locally when offline. When the connection returns, everything syncs automatically. No data lost.

---

## What's Next

| Feature | Status | Notes |
|---|---|---|
| WhatsApp number | Ready | Replace `REPLACE_ME` in config with your number |
| Database validation rules | Planned | Add type checking and field validation |
| Dynamic menu from Firebase | Planned | Edit menu items without touching code |
| Community events | Planned | Firepit gatherings, music nights, workshops |
| Perool catalogue | Planned | Local woollens and crafts — browse, enquire via WhatsApp |
| Android APK for staff | Planned | Package Ridge Bell as a native app |
| Raspberry Pi integration | Planned | IoT control for lights, motor, music, sensors |

---

## What You Get

- **5 HTML files** — website, guest portal, staff app, dashboard, guest entry
- **Shared Firebase config** — single source of truth
- **Firebase Hosting config** — ready to deploy
- **Database security rules** — production-ready
- **Seed data tool** — initialize your database
- **Complete documentation** — architecture, data flow, deployment guide
- **No ongoing cost** — Firebase free tier covers everything
- **No maintenance** — no server, no updates, no dependencies
- **No training** — if your staff can use WhatsApp, they can use this

---

## Contact

Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601
