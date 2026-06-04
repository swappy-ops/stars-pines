# STARS & PINES — FULL SYSTEM AUDIT (v2)

Date: 2026-06-04

## 1. FILE INVENTORY

| File | Role |
|---|---|
| `stars-and-pines-v3.html` | Public website — editorial, atmospheric |
| `guest-portal.html` | Guest portal — operational, field guide |
| `ridge-bell-staff-app.html` | Staff app — dispatch, queue, concerns |

## 2. SEPARATION OF CONCERNS

### Public Website
- Crank's Ridge history, philosophy, rooms, reviews, guide, booking
- No operational features (ordering, requests, grievances removed)
- Founder-centric language replaced with place-centric storytelling
- Link to guest portal in footer

### Guest Portal
- Token-based access (`?token=ABX72K`)
- Food & Drink (new menu with specials, kitchen timings, prep times)
- House Requests (one-tap)
- Grievances (separate, higher priority)
- Ridge Guide (operational)
- Perool (catalogue — woollens, handmade, organic)
- Community Board (Firebase-powered, future)
- Your Stay (personal order/request/grievance history)

### Ridge Bell Staff App
- Order queue (website + portal + staff sources)
- Staff ordering (unchanged)
- Nudges / requests (unchanged, now receives from portal)
- Grievances tab (NEW — priority visibility, acknowledge/resolve)
- Log (Firebase-driven, no static entries)

## 3. FIREBASE CONFIG — PASS

All three files share identical config:
```
apiKey:          AIzaSyAJtVjg6zv1KK2puu57NICrW8mU7OTybUA
databaseURL:     https://stars-and-pines-ridge-default-rtdb.asia-southeast1.firebasedatabase.app
projectId:       stars-and-pines-ridge
```

## 4. FIREBASE SCHEMA

### Existing (preserved)
```
/orders/{orderId}
  id, room, items[], total, status, source, createdAt, updatedAt, notes
  NEW: guestToken, guestName

/nudges/{nudgeId}
  id, room, type, message, status, createdAt
  NEW: source, guestToken, guestName
```

### New collections
```
/guest_access/{token}
  token, guestName, room, active, validUntil, createdAt, checkIn, checkOut

/grievances/{grievanceId}
  id, room, type, message, severity, status, source, guestToken, guestName,
  createdAt, updatedAt, resolvedBy, resolvedAt, acknowledgedBy, acknowledgedAt

/community/{eventId}          — (future)
  id, title, description, type, date, time, location, active, createdAt

/menu/{category}              — (future)
  items[], specials[], kitchenOpen, kitchenMessage

/perool/{category}            — (future)
  items[]
```

## 5. DEFECTS FIXED

| Issue | Status | Fix |
|---|---|---|
| WhatsApp placeholders | ✓ | Config pattern retained, clear placeholder |
| Extra naan persistence | ✓ | Reads order from Firebase, appends naan, writes full items array |
| Initial alert spam | ✓ | `initialSyncComplete` flag — skips `child_added` alerts during first sync |
| Website success on Firebase failure | ✓ | Promise-based push, error toast on failure |
| Static log entries | ✓ | Removed, loads from Firebase order/nudge/grievance history |

## 6. PERFORMANCE OPTIMIZATIONS

| Optimization | Impact |
|---|---|
| Removed noise grain overlay (`body::after`) | Eliminates GPU repaint on every frame |
| Removed `backdrop-filter: blur()` from nav | Reduces compositing cost on scroll |
| Reduced hero stars from 120 to 50 | Fewer animated DOM elements |
| Throttled scroll handler with `requestAnimationFrame` | Prevents scroll jank |
| Added `content-visibility: auto` to reveal sections | Browser skips off-screen rendering |
| Removed all ordering CSS from website (~250 lines) | Smaller stylesheet, faster parse |

## 7. SOURCE VALUES

| Source | Origin |
|---|---|
| `website` | Old website ordering (removed from public site) |
| `portal` | New guest portal |
| `staff` | Ridge Bell staff app |

## 8. COMPATIBILITY

| Feature | Website | Portal | Ridge Bell |
|---------|---------|--------|------------|
| Place orders | — | ✓ | ✓ |
| View orders | — | ✓ (own) | ✓ (all) |
| House requests | — | ✓ | ✓ |
| Grievances | — | ✓ | ✓ (priority) |
| Token access | — | ✓ | — |
| Staff identity | — | — | ✓ |
| Community board | — | ✓ (view) | ✓ (manage) |
| Perool | — | ✓ | — |
| Ridge guide | ✓ (editorial) | ✓ (operational) | — |

## 9. SECURITY

| Check | Status |
|---|---|
| Database rules | `.read: true, .write: true` — open (acceptable for MVP) |
| Token validation | Checks `active` and `validUntil` fields |
| No auth required | Yes — anyone can read/write (acceptable for MVP) |
| Input sanitization | Orders/nudges/grievances written as-is from DOM |

## 10. REMAINING ITEMS

| Item | Priority | Notes |
|---|---|---|
| WhatsApp number | LOW | Replace `REPLACE_ME` in all three files |
| Database rules | MEDIUM | Add basic validation rules |
| Token generation UI | MEDIUM | Add to Ridge Bell for staff to create tokens |
| Dynamic menu from Firebase | LOW | Future — currently hardcoded in portal |
| Community events management | LOW | Future — add CRUD in Ridge Bell |
| Perool from Firebase | LOW | Future — currently hardcoded in portal |
