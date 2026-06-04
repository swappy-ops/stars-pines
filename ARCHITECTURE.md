# Stars & Pines — Architecture Redesign

Date: 2026-06-04

## 1. SYSTEM OVERVIEW

```
┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE REALTIME DB                      │
│  stars-and-pines-ridge-default-rtdb.asia-southeast1          │
│                                                              │
│  /orders/        — food & drink orders                       │
│  /nudges/        — house requests                            │
│  /grievances/    — guest complaints (NEW)                    │
│  /guest_access/  — access tokens (NEW)                       │
│  /menu/          — menu data (NEW, future)                   │
│  /community/     — events & announcements (NEW, future)      │
│  /guide/         — ridge guide content (NEW, future)         │
│  /perool/        — product catalogue (NEW, future)           │
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

## 2. SEPARATION OF CONCERNS

### Public Website (stars-and-pines-v3.html)
**Job:** Sell the experience. Tell the story.
- Crank's Ridge history
- Philosophy
- Rooms
- Reviews
- Guide (editorial)
- Booking channels
- WhatsApp enquiry form

**Removed:**
- Room service ordering (moved to guest portal)
- Guest requests (moved to guest portal)
- Grievances (moved to guest portal)
- Staff interactions (moved to guest portal)

### Guest Portal (guest-portal.html)
**Job:** Support the stay. A field guide for living on the ridge.
- Access via token: `starsandpines.com/guest-portal.html?token=ABX72K`
- Food & Drink (reuses existing order system)
- House Requests (one-tap)
- Grievances (separate, higher priority)
- The Ridge Guide (operational)
- Perool (catalogue)
- Community Board (future)
- Your Stay (personal history)

### Ridge Bell Staff App (ridge-bell-staff-app.html)
**Job:** Operational dispatch.
- Order queue (unchanged)
- Staff ordering (unchanged)
- Nudges / requests (unchanged, now also receives from portal)
- Grievances (NEW — higher priority visibility)
- Log (fixed — no more static entries)

## 3. FIREBASE SCHEMA

### Existing (preserved)

```
/orders/{orderId}
  id: string          — "order_" + timestamp
  room: string        — "Mountain Double", "Dorm Bed 1", etc.
  items: array        — [{ name, qty, price }]
  total: number       — total cost
  status: string      — "pending" | "preparing" | "done" | "cancelled"
  source: string      — "website" | "staff" | "portal" (NEW)
  createdAt: number   — timestamp
  updatedAt: number   — timestamp
  notes: string       — optional guest notes
  guestToken: string  — (NEW) links order to guest access token
```

```
/nudges/{nudgeId}
  id: string          — "nudge_" + timestamp
  room: string        — room or "General"
  type: string        — "extra_towels", "water_refill", etc.
  message: string     — human-readable
  status: string      — "sent" | "resolved"
  createdAt: number   — timestamp
  source: string      — "staff" | "portal" (NEW)
  guestToken: string  — (NEW) links nudge to guest
```

### New collections

```
/guest_access/{token}
  token: string       — "ABX72K", "PINE44", etc.
  guestName: string   — "Priya K."
  room: string        — "Mountain Double"
  active: boolean     — true while stay is active
  validUntil: number  — timestamp (checkout + 1 day buffer)
  createdAt: number   — timestamp
  checkIn: number     — timestamp
  checkOut: number    — timestamp
```

```
/grievances/{grievanceId}
  id: string          — "grievance_" + timestamp
  room: string        — guest room
  type: string        — "water_issue", "noise", "room", "service", "maintenance", "other"
  message: string     — guest description
  severity: string    — "low" | "medium" | "high" | "urgent"
  status: string      — "open" | "acknowledged" | "resolved" | "escalated"
  source: string      — "portal"
  guestToken: string  — links to guest
  createdAt: number   — timestamp
  updatedAt: number   — timestamp
  resolvedBy: string  — staff name (when resolved)
  resolvedAt: number  — timestamp
```

```
/community/{eventId}          — (future)
  id: string
  title: string
  description: string
  type: string                — "firepit", "dinner", "music", "workshop", "yoga", "announcement"
  date: number                — timestamp
  time: string                — "7:00 PM"
  location: string            — "Firepit area", "Common room"
  active: boolean             — show/hide
  createdAt: number
```

```
/menu/{category}              — (future, for dynamic menu)
  items: array                — [{ name, price, available, prepTime }]
  specials: array             — [{ name, description, price }]
  kitchenOpen: boolean        — kitchen status
  kitchenMessage: string      — "Breakfast until 10 AM", etc.
```

## 4. ACCESS TOKEN SYSTEM

### Token Generation
Tokens are 6-character alphanumeric codes:
- Pattern: `[A-Z0-9]{6}`
- Examples: `ABX72K`, `PINE44`, `KAS91P`, `RIDGE7`
- Generated at check-in by staff (manual entry in Ridge Bell or Firebase console)
- Stored in `/guest_access/{token}`

### Access Flow
```
Guest arrives → Staff creates token → Token stored in Firebase
Guest receives token (card, WhatsApp, verbal)
Guest visits: starsandpines.com/guest-portal.html?token=ABX72K
Portal validates token against Firebase
If valid → show portal
If invalid/expired → show elegant access screen
```

### Token Lifecycle
- Created at check-in
- Active during stay
- Expires 24 hours after checkout
- Can be manually deactivated by staff

## 5. USER FLOWS

### 5.1 Guest Ordering (Portal)
```
Guest opens portal → Food & Drink section
→ Browses menu (with today's specials, kitchen timings)
→ Selects items → Cart updates
→ "Send to kitchen" → Confirmation modal
→ Push to /orders/ with source="portal", guestToken
→ Success toast
→ Order appears in Ridge Bell queue
→ Guest sees order in "Your Stay" section
→ Staff marks done → Guest sees status update in real-time
```

### 5.2 House Request (Portal)
```
Guest opens portal → House Requests section
→ Taps "Extra blanket" (one-tap)
→ Push to /nudges/ with source="portal", guestToken, room
→ Confirmation
→ Appears in Ridge Bell nudge tab
→ Staff fulfills → marks resolved
```

### 5.3 Grievance (Portal)
```
Guest opens portal → Grievances section
→ Selects type (water, noise, room, service, maintenance)
→ Writes description
→ Submits
→ Push to /grievances/ with severity
→ High-priority alert in Ridge Bell (distinct from orders)
→ Staff acknowledges → resolves
→ Guest sees status in "Your Stay"
```

### 5.4 Staff Workflow (Ridge Bell)
```
Staff opens app → Selects identity → Enters main screen
→ Queue tab: sees all pending orders (website + portal + staff)
→ Order tab: can place orders on behalf of guests
→ Nudge tab: sees house requests from portal + staff-initiated
→ Grievances tab (NEW): sees grievances with priority indicators
→ Log tab: sees all activity (now Firebase-driven, no static entries)
```

## 6. CONTENT RESTRUCTURE

### Founder-centric → Place-centric

| Before | After |
|--------|-------|
| "Rajat and Raman built a place..." | "Stars & Pines is a mountain house on Crank's Ridge..." |
| "They didn't come from hospitality..." | "The house started the way good places do — from knowing what this ridge feels like..." |
| "They'll know your name..." | "Your name is known before check-in..." |

### The ridge as protagonist
- The ridge is the constant
- People are custodians, not founders
- Storytelling is place-first, people-second

## 7. DEFECT FIXES

### Issue 1: WhatsApp placeholders
- `whatsappNumber: 'REPLACE_ME'` in both files
- Hardcoded `919999999999` in HTML
- **Fix:** Keep config pattern, add clear placeholder comment

### Issue 2: Extra naan persistence
- `confirmNaanExtra()` only writes `updatedAt`, not items
- **Fix:** Read current order items, append extra naan, write full items array

### Issue 3: Initial alert spam
- `child_added` fires for all existing orders on login
- **Fix:** Track initial sync completion, only alert on new children after sync

### Issue 4: Website success state on Firebase failure
- `submitOrder()` shows success regardless of Firebase result
- **Fix:** Use Promise-based push, show error on failure

### Issue 5: Static log entries
- Log tab has 3 hardcoded entries
- **Fix:** Remove static entries, load from Firebase order/nudge history

## 8. PERool INTEGRATION

### Philosophy
- Not e-commerce
- Not a store
- Objects discovered during a stay
- Field journal aesthetic

### Structure
```
/perool/
  /woollens/
  /clothing/
  /organic/
  /crafts/
```

Each item:
- image (URL or placeholder)
- title
- short description
- story/origin
- enquiry button → WhatsApp or Instagram

### Actions
- WhatsApp enquiry (pre-filled message)
- Instagram visit (@perool)
- No checkout, no cart, no payment

## 9. MIGRATION STRATEGY

### Phase 1: Fix defects (immediate)
- Fix all 5 identified defects in existing files
- No new features, just bug fixes

### Phase 2: Create guest portal
- New file: `guest-portal.html`
- Token-based access
- Reuse existing order logic
- Add house requests, grievances, guide, perool, community, your stay

### Phase 3: Update public website
- Remove `#order` section
- Fix founder-centric language
- Add link to guest portal (subtle, in footer or booking section)
- Keep all editorial content

### Phase 4: Update staff app
- Add grievance tab
- Fix log tab (Firebase-driven)
- Fix naan persistence
- Fix alert spam
- Support `source: "portal"` orders

### Phase 5: Firebase schema additions
- Add `/guest_access/` collection
- Add `/grievances/` collection
- Add `/community/` collection (structure only)
- Add `/menu/` collection (structure only)
- Add `/perool/` collection (structure only)

## 10. COMPATIBILITY MATRIX

| Feature | Website | Portal | Ridge Bell |
|---------|---------|--------|------------|
| Place orders | ✓ (removed) | ✓ | ✓ |
| View orders | — | ✓ (own) | ✓ (all) |
| House requests | — | ✓ | ✓ |
| Grievances | — | ✓ | ✓ (priority) |
| Menu browsing | — | ✓ | ✓ |
| Token access | — | ✓ | — |
| Staff identity | — | — | ✓ |
| Order dispatch | — | — | ✓ |
| Community board | — | ✓ (view) | ✓ (manage) |
| Perool | — | ✓ | — |
| Ridge guide | ✓ (editorial) | ✓ (operational) | — |

## 11. IMPLEMENTATION ROADMAP

| Step | Action | File | Est. |
|------|--------|------|------|
| 1 | Fix 5 defects | Both existing files | 30 min |
| 2 | Create guest portal | guest-portal.html | 90 min |
| 3 | Update public website | stars-and-pines-v3.html | 45 min |
| 4 | Update staff app | ridge-bell-staff-app.html | 30 min |
| 5 | Update documentation | AUDIT.md, PLAN.md | 15 min |

**Total: ~3.5 hours**
