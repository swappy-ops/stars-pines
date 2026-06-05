# Stars & Pines — Digital Guest Experience System

A complete guest experience system built for a mountain house on Crank's Ridge, Kasar Devi, Almora — 1,645m.

**What it is:** A three-part digital system that replaces paper menus, walkie-talkie requests, and front-desk friction with a seamless guest portal and staff dispatch app. No hardware. No servers. No training. Works on any phone.

**What it costs to run:** Firebase free tier. Zero infrastructure. Zero maintenance.

---

## Visual Documentation

| Document | Contents |
|---|---|
| [DIAGRAMS.md](DIAGRAMS.md) | System architecture, data flows, token lifecycle, offline support, state machines, collection relationships |
| [FLOWCHARTS.md](FLOWCHARTS.md) | Complete guest journey, order placement, grievance resolution, staff tab decision trees, booking flow, error handling |

---

## The Problem

Mountain properties operate on paper, memory, and walkie-talkies. Guests don't know what's on the menu, how to request extra blankets, or where to raise a concern. Staff miss orders, lose track of requests, and have no record of what happened. The guest experience suffers because the systems to support it don't exist.

## The Solution

Three connected apps that run on phones the staff already own and the guests already carry:

| App | Who Uses It | What It Does |
|---|---|---|
| **Public Website** | Prospective guests | Tells the story, sells the experience, takes bookings |
| **Guest Portal** | Checked-in guests | Orders food, makes requests, raises concerns, explores the ridge |
| **Ridge Bell Staff App** | Your team | Receives orders, dispatches tasks, tracks concerns, generates guest access codes |

All three talk to each other in real-time through Firebase. When a guest places an order, it appears on the staff app instantly. When staff marks it done, the guest sees it update. No refresh needed.

---

## How It Works — Guest Journey

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

## How It Works — Staff Side

### The Ridge Bell App

Your team opens it on their phone. They pick their profile (Karan for kitchen, Meena for front desk). They see:

**Queue tab** — Live list of all pending orders. Room, items, how long ago, any notes. Tap "Done" or "Cancel." Completed orders sit below for reference.

**Order tab** — Staff can place orders on behalf of guests who don't have portal access. Select the room, pick from the menu, send.

**Nudge tab** — All guest requests appear here. Extra towels, water refill, room cleaning. Staff can also flag things: maintenance issues, low stock, safety concerns.

**Concerns tab** — Guest grievances with priority indicators. Urgent ones show with a red border. Staff acknowledges → resolves. Guest sees the status change in their portal.

**Log tab** — Everything that happened today. Orders placed, requests made, concerns raised. Full history.

**Me tab** — Staff profile, guest check-in with QR code generator, property info, quick WhatsApp contacts.

### When a New Order Arrives

1. A banner slides down: "New order — Mountain Double — Thukpa × 1, Butter naan × 2"
2. The phone plays a bell sound
3. The phone vibrates
4. A red dot appears on the queue icon
5. Staff taps it, sees the order, starts preparing

### When the Internet Goes Down

The app keeps working. Orders and requests are queued locally. When the connection returns, everything syncs automatically. No data lost.

---

## What's Included

### Public Website

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

### Guest Portal

- Token-based access — no login, no password, no download
- **Food & Drink** — full menu with search, category filters, cart, order submission, real-time status
- **House Requests** — one-tap: blanket, towels, water, cleaning, firepit, tea
- **Concerns** — 9 grievance types, urgency selector, message field, status tracking
- **Ridge Guide** — places, trails, contacts, bookmarkable entries
- **Experiences** — bonfire, local guide, photography, village walk, bird watching, stargazing, transport, special meals
- **Concierge** — blankets, cleaning, hot water, laundry, taxi, wake-up call, medical, luggage
- **Your Stay** — personal dashboard: room info, active orders, history, requests, concerns, experiences

### Ridge Bell Staff App

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

### Guest Entry Flow

- Staff generates QR codes for guests at check-in
- Guest scans QR → registration form → welcome → enters portal
- Or staff shares the link via WhatsApp directly

---

## The Numbers

| Metric | Value |
|---|---|
| Total files | 4 active HTML files |
| Total code | ~7,600 lines |
| Total size | ~266 KB (all four apps combined) |
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

## What It Looks Like

### Guest Portal

```
┌─────────────────────────────┐
│ Good evening, Priya         │
│ Mountain Double · ABX72K    │
├─────────────────────────────┤
│ Food  Requests  Concerns    │
│ Guide  Experiences  Stay    │
├─────────────────────────────┤
│                             │
│  🍲  Peculiar Poha    ₹120  │
│  🍔  Garden Fresh     ₹180  │
│  🥪  Habibi           ₹170  │
│  🥗  Bodhi Bowl       ₹200  │
│  ☕  Cold Kaapi       ₹140  │
│                             │
├─────────────────────────────┤
│ 2 items · ₹300              │
│ [Send to kitchen →]         │
└─────────────────────────────┘
```

### Staff App — Queue

```
┌─────────────────────────────┐
│ Good evening, Karan         │
│ Kitchen & Café              │
├─────────────────────────────┤
│ Queue  Order  Nudge  Log Me │
├─────────────────────────────┤
│                             │
│ Mountain Double · Portal    │
│ Thukpa × 1, Butter naan × 2 │
│ "Extra spicy please"        │
│ 3 min ago                   │
│ [Done ✓]        [Cancel]    │
│                             │
│ Dorm Bed 2 · Web order      │
│ Shakshouka × 1, Lime Wire   │
│ 8 min ago                   │
│ [Done ✓]        [Cancel]    │
│                             │
└─────────────────────────────┘
```

---

## Technical Details (For Your IT Person)

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE REALTIME DB                      │
│  /orders/  /nudges/  /grievances/  /guest_access/            │
│  /experiences/  /concierge/  /events/                        │
└──────┬───────────────────────┬───────────────────────┬──────┘
       │                       │                       │
┌──────▼──────┐         ┌──────▼──────┐         ┌──────▼──────┐
│  PUBLIC     │         │  GUEST      │         │  GUEST      │
│  WEBSITE    │         │  PORTAL     │         │  ENTRY      │
│ index.html  │         │ guest-      │         │ guest-      │
│             │         │ portal.html │         │ entry.html  │
└─────────────┘         └──────┬──────┘         └──────┬──────┘
                               │                       │
                        ┌──────▼──────┐                │
                        │  RIDGE BELL │◄───────────────┘
                        │  STAFF APP  │
                        │ ridge-bell- │
                        │ staff-app   │
                        │ .html       │
                        └─────────────┘
```

### Tech Stack

- **Frontend:** Vanilla HTML, CSS, JavaScript — no framework, no build step
- **Database:** Firebase Realtime Database
- **SDK:** Firebase v10.12.0
- **Fonts:** Playfair Display, DM Sans (Google Fonts)
- **QR Codes:** qrcode@1.5.3
- **Audio:** Web Audio API (no external sound files)
- **Mobile:** Designed for any phone, works in browser

### Deployment

Each file is self-contained. Deploy anywhere:

- Firebase Hosting (recommended — free tier)
- GitHub Pages
- Netlify
- Vercel
- Any static file server

No build step. No dependencies to install. Just upload the HTML files.

### Firebase Setup

1. Create a Firebase project
2. Enable Realtime Database
3. Set rules to allow read/write
4. Copy the config into the four HTML files
5. Done

### Access Tokens

6-character codes (e.g., `ABX72K`). Generated at check-in. Active during stay. Expire 24 hours after checkout. Can be deactivated manually.

---

## What's Next

| Feature | Status | Notes |
|---|---|---|
| WhatsApp number | Ready | Replace placeholder with your number |
| Database validation rules | Planned | Add type checking and field validation |
| Dynamic menu from Firebase | Planned | Edit menu items without touching code |
| Community events | Planned | Firepit gatherings, music nights, workshops |
| Perool catalogue | Planned | Local woollens and crafts — browse, enquire via WhatsApp |
| Android APK for staff | Planned | Package Ridge Bell as a native app |

---

## What You Get

- **4 HTML files** — website, guest portal, staff app, guest entry
- **Complete Firebase schema** — orders, nudges, grievances, guest access, experiences, concierge
- **Full documentation** — architecture, data flow, deployment guide
- **No ongoing cost** — Firebase free tier covers everything
- **No maintenance** — no server, no updates, no dependencies
- **No training** — if your staff can use WhatsApp, they can use this

---

## Contact

Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601
