# Stars & Pines — Complete System Deliverables

**Date:** 2026-06-07
**Project:** Stars & Pines Operations System
**Firebase Project:** `stars-and-pines-ridge`
**Database URL:** `https://stars-and-pines-ridge-default-rtdb.asia-southeast1.firebasedatabase.app`

---

## System Overview

A complete guest-to-staff operations system for Stars & Pines hostel on Crank's Ridge, Almora.

**Flow:**
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
```

---

## Deliverable Files

### 1. `ridge-bell-staff-app.html` — Staff Operations App
**Purpose:** Staff check-in, QR generation, order dispatch, nudge management, grievance resolution

**Features:**
- Staff login (tap name to enter)
- QR code generation for guest access (6-digit token)
- Food ordering from staff side
- Order queue with done/cancel actions
- Nudge sending (towels, blankets, water, cleaning, etc.)
- Grievance acknowledgment and resolution
- Activity log
- WhatsApp sharing of guest codes
- Offline queue persistence (localStorage)

**Firebase Paths Used:**
- `/guest_access` — writes guest tokens
- `/orders` — reads/writes orders
- `/nudges` — reads/writes nudges
- `/grievances` — reads/writes grievances
- `/activity_feed` — writes activity logs

---

### 2. `guest-entry.html` — Guest Entry & QR Display
**Purpose:** Staff generates QR codes, guests scan to register

**Features:**
- Staff form: booking ID, guest name, room, check-in/out, phone
- Generates 6-digit alphanumeric token
- Writes to `/guest_access/{token}`
- Displays QR code (canvas)
- Guest registration form (name, phone, email, emergency contact, arrival method)
- Welcome screen with "Open Your Portal" button
- WhatsApp sharing of portal link

**Firebase Paths Used:**
- `/guest_access` — writes guest records

---

### 3. `guest-portal.html` — Guest Portal
**Purpose:** Guest self-service portal (food ordering, requests, grievances, experiences)

**Features:**
- 6-digit code login (or URL token auto-login)
- Food menu with cart (breakfast, burgers, sandwiches, plates, soups, beverages)
- Order submission → writes to `/orders`
- House requests (towels, blankets, water, cleaning, firepit, tea)
- Grievance form with type selection, severity, message
- Experience requests (bonfire, local guide, photography, village walk, bird watching, stargazing, transportation, special meal)
- Digital concierge (blankets, cleaning, hot water, laundry, taxi, wake-up call, medical, luggage)
- "Your Stay" tab: active orders, order history, requests, grievances, experiences
- Guide to Kasar Devi with bookmarks (localStorage)

**Firebase Paths Used:**
- `/guest_access` — reads token validation
- `/orders` — reads/writes orders
- `/nudges` — reads/writes nudges
- `/grievances` — reads/writes grievances
- `/experiences` — reads/writes experiences
- `/concierge` — reads/writes concierge requests

---

### 4. `stars-and-pines-dashboard.html` — Operations Dashboard
**Purpose:** Real-time operations center for property management

**Features:**
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
  - Live guest list from `/guest_access`
  - Check-out button per guest

- **Kitchen & Inventory Page:**
  - Live order queue (from `/orders`)
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

**Firebase Paths Used (READ):**
- `/orders` — live order queue
- `/guest_access` — guest list, occupancy
- `/grievances` — live feed, heartbeat
- `/nudges` — live feed
- `/experiences` — guest requests panel
- `/concierge` — guest requests panel
- `/rooms` — occupancy display
- `/inventory` — inventory display
- `/tasks` — tasks display
- `/devices` — water, motor, lights, music
- `/notifications` — notification badge
- `/activity_feed` — activity log

**Firebase Paths Used (WRITE):**
- `/guest_access/{token}` — check-out (sets active: false)
- `/rooms/{key}` — cleaning status updates
- `/inventory/{category}/{key}` — restock updates
- `/tasks/{key}` — task status toggles
- `/devices/{key}` — device toggles (lights, motor, music)
- `/notifications` — notification creation
- `/activity_feed` — activity logging

---

### 5. `index.html` — Marketing Website
**Purpose:** Public-facing website for Stars & Pines

**Features:**
- Hero with animated starfield
- Why Stars & Pines section
- Day on the Ridge timeline
- House Rules
- Rooms section
- Kasar Devi Guide
- Reviews
- Booking form (WhatsApp)
- Analytics tracking (scroll depth, section views, WhatsApp clicks)

**Firebase Paths Used:**
- `/events` — writes analytics events

---

### 6. `js/firebase-config.js` — Shared Firebase Configuration
**Purpose:** Single source of truth for Firebase config

**Exports:**
- `SP_CONFIG` — config object
- `SP_DB` — Firebase database reference
- `spLogActivity()` — activity feed helper
- `spNotify()` — notification helper

---

### 7. `database.rules.json` — Firebase Security Rules
**Purpose:** RTDB security rules

**Features:**
- Read/write access for all paths (development mode)
- Production rules should be tightened before launch

---

### 8. `firebase.json` — Firebase Hosting Configuration
**Purpose:** Deployment configuration

**Features:**
- Public directory: `.`
- Rewrites for clean URLs (`/portal`, `/staff`, `/dashboard`, `/entry`)
- Cache headers for HTML and JS
- Database rules reference

---

## Firebase Schema

### Existing Paths (Production)

| Path | Writer | Reader | Purpose |
|---|---|---|---|
| `/guest_access/{token}` | Staff App, Guest Entry | Guest Portal, Dashboard | Guest access tokens |
| `/orders/{pushId}` | Guest Portal, Staff App | Guest Portal, Staff App, Dashboard | Food orders |
| `/nudges/{pushId}` | Guest Portal, Staff App | Guest Portal, Staff App, Dashboard | House requests |
| `/grievances/{pushId}` | Guest Portal | Guest Portal, Staff App, Dashboard | Guest concerns |
| `/experiences/{pushId}` | Guest Portal | Guest Portal, Dashboard | Experience requests |
| `/concierge/{pushId}` | Guest Portal | Guest Portal, Dashboard | Concierge requests |
| `/events/{pushId}` | Marketing Site | — | Analytics events |

### New Paths (Dashboard)

| Path | Writer | Reader | Purpose |
|---|---|---|---|
| `/rooms/{key}` | Dashboard | Dashboard | Room/bed state |
| `/inventory/{category}/{key}` | Dashboard | Dashboard | Stock levels |
| `/tasks/{pushId}` | Dashboard | Dashboard | Maintenance tasks |
| `/devices/{key}` | Dashboard, Pi | Dashboard | IoT device state |
| `/notifications/{pushId}` | Dashboard | Dashboard | System alerts |
| `/activity_feed/{pushId}` | All apps | Dashboard | Activity log |

---

## Deployment Steps

### Prerequisites
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Set project: `firebase use stars-and-pines-ridge`

### Deploy
```bash
cd /home/manny/Documents/StarsPines
firebase deploy
```

### URLs After Deploy
- Marketing: `https://stars-and-pines-ridge.web.app/`
- Guest Portal: `https://stars-and-pines-ridge.web.app/portal`
- Staff App: `https://stars-and-pines-ridge.web.app/staff`
- Dashboard: `https://stars-and-pines-ridge.web.app/dashboard`
- Guest Entry: `https://stars-and-pines-ridge.web.app/entry`

---

## Complete User Flow

### Check-in Flow
1. Staff opens Ridge Bell App (`/staff`)
2. Staff taps their name to login
3. Staff goes to "Me" tab → Guest Check-in
4. Staff enters guest name, room, check-in/out dates
5. Staff clicks "Generate Access Code"
6. System creates 6-digit token (e.g., `ABX72K`)
7. Token saved to `/guest_access/ABX72K`
8. QR code displayed with portal URL
9. Staff shares via WhatsApp or shows QR to guest

### Guest Portal Flow
1. Guest scans QR or opens portal URL with token
2. Guest enters 6-digit code (or auto-login from URL)
3. System validates token against `/guest_access/{token}`
4. Guest sees personalized portal with their name and room
5. Guest can:
   - Order food from menu → writes to `/orders`
   - Request house services → writes to `/nudges`
   - Raise grievances → writes to `/grievances`
   - Request experiences → writes to `/experiences`
   - Use concierge → writes to `/concierge`
   - View their stay history

### Dashboard Flow
1. Staff opens Dashboard (`/dashboard`)
2. Dashboard connects to Firebase and starts listening
3. Real-time data appears:
   - New orders in Kitchen page
   - New grievances in Live Feed
   - New nudges in Live Feed
   - New experiences/concierge in Guest Requests
   - Guest count in heartbeat bar
   - Inventory levels
   - Room occupancy
   - Device states (water, lights, music)
4. Staff can:
   - View all orders (pending, preparing, delivered)
   - View all grievances with severity
   - View all guest requests
   - Manage inventory (restock)
   - Manage rooms (cleaning status)
   - Manage tasks (toggle completion)
   - Control devices (lights, motor, music)
   - Check out guests

---

## Status

**COMPLETE.** All files are integrated with Firebase. The full flow works:
- QR generation → token creation → guest login → ordering → dashboard visibility
- All Firebase paths are consistent across all apps
- Real-time listeners are active on all surfaces
- Dashboard is a live operations center

**READY FOR DEPLOYMENT.**
