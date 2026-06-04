# Stars & Pines — Integration Plan (v2)

## Current State

| File | Status |
|---|---|
| `stars-and-pines-v3.html` | Public website — editorial, atmospheric, no operational features |
| `guest-portal.html` | Guest portal — token-based access, ordering, requests, grievances, guide, perool, community |
| `ridge-bell-staff-app.html` | Staff app — queue, dispatch, nudges, grievances, log |

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
    │ Editorial   │        │ Operational │
    │ Story       │        │ Field Guide │
    └─────────────┘        └──────┬──────┘
                                  │
                           ┌──────▼──────┐
                           │  RIDGE BELL │
                           │  STAFF APP  │
                           │             │
                           │ Queue       │
                           │ Dispatch    │
                           │ Nudges      │
                           │ Grievances  │
                           └─────────────┘
```

## Access Flow

```
Guest arrives → Staff creates token in Firebase /guest_access/
Guest receives token (card, WhatsApp, verbal)
Guest visits: guest-portal.html?token=ABX72K
Portal validates token → shows portal
If invalid/expired → elegant access screen
```

## Token Format

- 6-character alphanumeric: `[A-Z0-9]{6}`
- Examples: `ABX72K`, `PINE44`, `KAS91P`
- Stored in `/guest_access/{token}`
- Fields: `token`, `guestName`, `room`, `active`, `validUntil`, `createdAt`

## Data Flow

### Guest Portal → Firebase
| Trigger | Path | Data |
|---|---|---|
| Food order | `orders/` | room, items[], total, status=pending, source=portal, guestToken, guestName, notes |
| House request | `nudges/` | room, type, message, status=sent, source=portal, guestToken |
| Grievance | `grievances/` | room, type, message, severity, status=open, source=portal, guestToken |

### Staff App ← Firebase
| Listener | Path | Action |
|---|---|---|
| Orders | `orders/` | Renders queue, alerts on new portal/website orders |
| Nudges | `nudges/` | Tracks in log |
| Grievances | `grievances/` | Renders priority list, acknowledge/resolve |

### Staff App → Firebase
| Action | Path | Data |
|---|---|---|
| Place order | `orders/` | room, items[], total, status=pending, source=staff |
| Mark done | `orders/{key}` | status=done, updatedAt |
| Mark cancel | `orders/{key}` | status=cancelled, updatedAt |
| Send nudge | `nudges/` | room, type, message, status=sent |
| Acknowledge grievance | `grievances/{key}` | status=acknowledged, acknowledgedBy, acknowledgedAt |
| Resolve grievance | `grievances/{key}` | status=resolved, resolvedBy, resolvedAt |

## Defects Fixed

1. **WhatsApp placeholders** — Config pattern retained, clear placeholder comment
2. **Extra naan persistence** — Reads order from Firebase, appends naan, writes full items array
3. **Initial alert spam** — `initialSyncComplete` flag prevents alerts during first sync
4. **Website success on Firebase failure** — Promise-based push, error toast on failure
5. **Static log entries** — Removed, loads from Firebase order/nudge/grievance history

## Performance Optimizations

1. Removed noise grain overlay (GPU repaint on every frame)
2. Removed `backdrop-filter: blur()` from nav (compositing cost)
3. Reduced hero stars from 120 to 50 (fewer animated DOM elements)
4. Throttled scroll handler with `requestAnimationFrame`
5. Added `content-visibility: auto` to reveal sections
6. Removed all ordering CSS from website (~250 lines)

## Content Changes

- Founder-centric language replaced with place-centric storytelling
- "Rajat and Raman built..." → "A place built for the ridge..."
- The ridge is the protagonist, people are custodians
- Ordering section removed from public website
- Guest portal link added to footer

## Menu (Guest Portal)

New menu with mountain-cafe personality:
- Breakfast: Peculiar Poha, Shakshouka
- Burgers: Garden Fresh, Potato vs Paneer, Achaari Chicken
- Sandwiches: Chilli Cheesewich, Habibi, Creamy Shroomwich, Creamy Chickenwich
- Small plates: Patata Balota, Herb Whisperers, Cheesy Aubergine, Falafel Chips, Falafel Wrap, Pizza Toasties
- Large plates: Coconut Quinoa Bowl, Velvet Stroganov, Penne Divino, Grand Hummus Spread, Kumauni Thali
- Soups & Salads: Tomatina, Hearty Supreme, Fruity Fantasy, Bodhi Bowl, The Himalayan
- Beverages: Lime Wire, Rhodo Lover, Apple Gingerina, Thicc Shake, Cold Kaapi

Each item has prep time estimates. Today's specials rotate. Kitchen status shows open/closed based on time.

## Perool Integration

- Catalogue only (no checkout, cart, payment)
- Categories: Woollens, Handmade, Organic & Local
- Each item: image, title, description, story/origin
- Actions: WhatsApp enquiry, Instagram visit (@perool)
- Field journal aesthetic

## Remaining Items

| Item | Priority | Notes |
|---|---|---|
| WhatsApp number | LOW | Replace `REPLACE_ME` in all three files |
| Token generation UI | MEDIUM | Add to Ridge Bell for staff to create tokens at check-in |
| Dynamic menu from Firebase | LOW | Currently hardcoded in portal |
| Community events management | LOW | Add CRUD in Ridge Bell |
| Perool from Firebase | LOW | Currently hardcoded in portal |
| Database rules | MEDIUM | Add basic validation rules |
