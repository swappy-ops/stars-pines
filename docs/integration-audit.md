# Integration Audit — Stars & Pines

**Date:** 2026-06-06
**Scope:** All HTML files in repository, Firebase RTDB interactions, data flow between surfaces

---

## Critical Issues

### C1 — Firebase Config Duplicated 6 Times

**Severity:** Critical
**Files:** `index.html`, `stars-and-pines-v3.5(1).html`, `v4/index.html`, `guest-portal.html`, `ridge-bell-staff-app.html`, `guest-entry.html`, `seed-token.html`

Every file contains its own inline `APP_CONFIG` block with identical Firebase credentials:

```js
const APP_CONFIG = {
  whatsappNumber: 'REPLACE_ME',
  firebaseConfig: {
    apiKey: 'AIzaSyAJtVjg6zv1KK2puu57NICrW8mU7OTybUA',
    authDomain: 'stars-and-pines-ridge.firebaseapp.com',
    databaseURL: 'https://stars-and-pines-ridge-default-rtdb.asia-southeast1.firebasedatabase.app',
    projectId: 'stars-and-pines-ridge',
    storageBucket: 'stars-and-pines-ridge.firebasestorage.app',
    messagingSenderId: '8285256236',
    appId: '1:8285256236:web:e03af2dff72e80eed26f89'
  }
};
```

**Impact:** Changing any credential requires editing 7 files. `whatsappNumber` is `REPLACE_ME` everywhere — no production phone number configured.

**Fix:** Create `/js/firebase-config.js` as single source of truth. All files import from it.

---

### C2 — Order Status Schema Conflict

**Severity:** Critical
**Files:** `guest-portal.html`, `ridge-bell-staff-app.html`

Guest Portal writes `status: 'delivered'` when an order is complete.
Staff App writes `status: 'done'` when an order is complete.

**Impact:** Dashboard (and any future consumer) cannot reliably determine order completion. A `done` order from staff and a `delivered` order from portal are semantically identical but use different strings. The `statusHistory` field exists only in portal orders, not staff orders.

**Current status values across the system:**
- Guest Portal: `pending`, `preparing`, `ready`, `delivered`, `cancelled`
- Staff App: `pending`, `done`, `cancelled`

**Fix:** Standardize to single status enum: `pending` → `preparing` → `ready` → `delivered` (or `cancelled`). Staff App should use `delivered` instead of `done`.

---

### C3 — No Room/Occupancy Data in Firebase

**Severity:** Critical
**Files:** All

The dashboard has a full occupancy UI (3 dorms × 30 beds, 4 private rooms) but **zero Firebase integration**. Room state exists only as static HTML. The guest portal knows the guest's room from `/guest_access`, but there is no `/rooms` path tracking which beds are occupied, vacant, or in cleaning state.

**Impact:** Cannot do real-time occupancy, check-in/check-out, bed assignment, or occupancy analytics. Dashboard occupancy page is completely disconnected from reality.

**Fix:** Create `/rooms` path with bed-level and room-level state.

---

### C4 — No Inventory Data in Firebase

**Severity:** Critical
**Files:** All

Dashboard has a full inventory UI (produce, dairy, cafe, cleaning supplies with quantities, thresholds, status bars) but **zero Firebase integration**. All values are hardcoded in HTML.

**Impact:** Low-stock alerts are static. No way to track consumption, trigger reorder notifications, or sync with staff app "low stock" nudges.

**Fix:** Create `/inventory` path with category-based structure and threshold tracking.

---

### C5 — Dashboard Has Zero Firebase Integration

**Severity:** Critical
**Files:** `stars-and-pines-dashboard.html`

The dashboard is 100% static HTML. No Firebase SDK loaded. No real-time data. No writes. It is a mockup, not an operational tool.

**Impact:** Dashboard cannot serve as the control surface for the property. All toggles, sliders, buttons, and data displays are non-functional.

**Fix:** Full Firebase integration required (Phase 1A deliverable).

---

### C6 — `/experiences` and `/concierge` Are Write-Only Silos

**Severity:** Critical
**Files:** `guest-portal.html`

Guest Portal writes to `/experiences` and `/concierge` but **no other surface reads them**. Staff App has no tab for experiences or concierge requests. Dashboard has no view for them. These requests go into Firebase and disappear.

**Impact:** Guest requests for bonfires, local guides, taxi, laundry, wake-up calls, etc. are lost. No staff member sees them.

**Fix:** Staff App or Dashboard must read and display these paths. Or merge them into `/nudges` with a `type` distinction.

---

## Medium Issues

### M1 — Duplicate Marketing Site Files

**Severity:** Medium
**Files:** `index.html`, `stars-and-pines-v3.5(1).html`, `v4/index.html`

Three near-identical copies of the marketing site exist. All three write to `/events` for analytics. The v3.5 file has a `(1)` in the filename suggesting it's a duplicate copy.

**Impact:** Confusion about which is canonical. Triple analytics events if all are deployed. Wasted maintenance.

**Fix:** Keep one canonical `index.html`. Archive or delete others.

---

### M2 — `whatsappNumber` Is `REPLACE_ME` Everywhere

**Severity:** Medium
**Files:** All files with `APP_CONFIG`

The WhatsApp number placeholder has never been replaced. All WhatsApp links point to `919999999999` (fake number). The `track()` function in `index.html` only fires Firebase events when `whatsappNumber !== 'REPLACE_ME'`, meaning **no analytics are being recorded**.

**Impact:** No WhatsApp integration works. No analytics are recorded from the marketing site.

**Fix:** Set real number in shared config.

---

### M3 — Guest Access Token Has No Room-to-Bed Mapping

**Severity:** Medium
**Files:** `guest-portal.html`, `ridge-bell-staff-app.html`, `guest-entry.html`

`/guest_access` stores `room` as a string like `"Mountain Double"` or `"Six-Bed Dorm"`. There is no mapping to specific bed numbers in dorms. The dashboard UI shows individual beds (Bed 1-10 in Dorm A, etc.) but Firebase has no concept of bed-level assignment.

**Impact:** Cannot track which specific bed a guest occupies. Cannot do bed-level check-in/check-out. Cannot show accurate dorm occupancy.

**Fix:** Add `bedNumber` field to guest records. Create `/rooms` path with bed-level state.

---

### M4 — No Notification System

**Severity:** Medium
**Files:** All

There is no `/notifications` path. Alerts in the dashboard are hardcoded HTML. The Staff App has an alert banner for new orders but it's local-only (not persisted). There is no cross-surface notification system.

**Impact:** Low-stock alerts, grievance escalations, system warnings — all either hardcoded or ephemeral.

**Fix:** Create `/notifications` path. All surfaces write alerts here. Dashboard reads and displays. Dismissal marks as `read`.

---

### M5 — Staff App Has No Guest Check-in State Management

**Severity:** Medium
**Files:** `ridge-bell-staff-app.html`

The Staff App can generate QR codes (writes to `/guest_access`) but has no view of currently checked-in guests. No `/guests` path exists. The "Guest Check-in" section in the profile tab only generates codes — it doesn't show who's currently staying.

**Impact:** Staff cannot see current occupancy. Cannot manage check-outs. Cannot reassign rooms.

**Fix:** Create `/guests` path for active guest registry. Staff App reads and displays.

---

### M6 — Offline Queue Not Persisted

**Severity:** Medium
**Files:** `ridge-bell-staff-app.html`

The Staff App has an `offlineQueue` array that holds Firebase writes when offline. But this queue is in-memory only — if the page reloads, queued writes are lost.

**Impact:** Orders or nudges created while offline are silently dropped on page reload.

**Fix:** Persist offline queue to `localStorage`.

---

### M7 — No Data Validation or Schema Enforcement

**Severity:** Medium
**Files:** All

Firebase RTDB has no security rules or validation. Any client can write to any path with any shape. There are no Firebase Security Rules configured.

**Impact:** Data integrity is not guaranteed. Malformed writes could break consumers.

**Fix:** Add Firebase RTDB security rules. At minimum, validate required fields on writes.

---

### M8 — `seed-token.html` Is a Production Risk

**Severity:** Medium
**Files:** `seed-token.html`

This file creates a hardcoded test token (`888888`) with `validUntil: 9999999999999` (year 2286). If deployed, anyone who discovers this URL can access the guest portal indefinitely.

**Impact:** Security risk if deployed to production hosting.

**Fix:** Remove from production. Use only for local testing. Add to `.gitignore` or delete after testing.

---

## Low Priority Improvements

### L1 — Firebase SDK Loaded via CDN in Every File

**Severity:** Low
**Files:** All files with Firebase

Each file loads `firebase-app-compat.js` and `firebase-database-compat.js` from CDN separately. This means 7 separate HTTP requests for the same SDK across the app.

**Fix:** Consider a shared service worker cache, or accept the CDN caching benefit (CDN URLs are cacheable).

---

### L2 — No Firebase Initialization Guard

**Severity:** Low
**Files:** `index.html`, `stars-and-pines-v3.5(1).html`, `v4/index.html`

The marketing sites use `defer` and check `if (typeof firebase !== 'undefined')` before initializing. This is correct but fragile — if the CDN fails silently, Firebase is never initialized and no error is reported.

**Fix:** Add error handling for CDN load failure.

---

### L3 — Timestamp Inconsistency

**Severity:** Low
**Files:** `guest-portal.html`, `ridge-bell-staff-app.html`

Some records use `createdAt`, some use `ts` (events). Some have `updatedAt`, some don't. The `statusHistory` array exists in some paths but not others.

**Fix:** Standardize timestamp field names across all paths.

---

### L4 — No Pagination or Query Limits on Large Lists

**Severity:** Low
**Files:** `ridge-bell-staff-app.html`

The Staff App loads all orders, nudges, and grievances with `.on('value')`. As data grows, this will become slow. The log tab uses `limitToLast(50)` which is good, but the main queue does not.

**Fix:** Add `limitToLast()` or date-range queries for large collections.

---

### L5 — `guest-entry.html` Duplicates QR Generation from Staff App

**Severity:** Low
**Files:** `guest-entry.html`, `ridge-bell-staff-app.html`

Both files have nearly identical QR code generation logic (token generation, Firebase write, QR canvas rendering). This is duplicated code.

**Fix:** Extract shared QR generation into a common module.

---

### L6 — No Cleanup of Expired Guest Tokens

**Severity:** Low
**Files:** All

Expired tokens in `/guest_access` are never cleaned up. Over time, this path will accumulate stale records.

**Fix:** Add a periodic cleanup (Cloud Function or client-side on load) to remove expired tokens.

---

### L7 — Dashboard Mobile Nav Missing Pages

**Severity:** Low
**Files:** `stars-and-pines-dashboard.html`

The mobile bottom nav shows only 5 pages (Overview, Rooms, Kitchen, Water, Lights) but the desktop sidebar has 10 pages. Menu, Events, Maintenance, Music, and Analytics are inaccessible on mobile.

**Fix:** Add remaining pages to mobile nav or implement a mobile menu drawer.

---

## Data Ownership Map

| Data Domain | Current Owner | Should Be Owned By |
|---|---|---|
| Guest Access Tokens | Staff App + Guest Entry | Staff App (single writer) |
| Orders | Guest Portal + Staff App | Shared (both write, both read) |
| Nudges/Requests | Guest Portal + Staff App | Shared |
| Grievances | Guest Portal (write), Staff App (read/update) | Correct as-is |
| Experiences | Guest Portal (write only) | **Needs reader** (Staff App or Dashboard) |
| Concierge | Guest Portal (write only) | **Needs reader** (Staff App or Dashboard) |
| Events (analytics) | Marketing Site | Correct as-is |
| Rooms/Occupancy | **Nobody** | Staff App (write), Dashboard (read/write) |
| Inventory | **Nobody** | Dashboard (read/write), Staff App (read) |
| Menu | **Nobody** | Dashboard (read/write), Guest Portal (read) |
| Notifications | **Nobody** | All surfaces (write), Dashboard (read/display) |
| IoT | **Nobody** | Dashboard (write), Raspberry Pi (read/write) |
| System Health | **Nobody** | Raspberry Pi (write), Dashboard (read) |
| Analytics | **Nobody** | Computed from operational data |

---

## Dead Code / Unused Paths

| Path | Status | Notes |
|---|---|---|
| `/events` | Active but limited | Only fires when `whatsappNumber !== 'REPLACE_ME'` — currently never fires |
| `seed-token.html` | Test utility | Should not be in production |
| `stars-and-pines-v3.5(1).html` | Duplicate | Likely accidental copy |
| `v4/index.html` | Duplicate | Older version of marketing site |
| `color-swatches.html` | Design tool | No Firebase, not part of app |

---

## Summary

**Critical:** 6 issues — all block the dashboard from becoming an operational control surface.
**Medium:** 8 issues — affect reliability, security, and data integrity.
**Low:** 7 issues — quality-of-life improvements and cleanup.

**Biggest gap:** The dashboard is a static mockup with zero Firebase integration. The two operational surfaces (Guest Portal, Staff App) work but have schema conflicts and orphaned data paths.

**Recommended first action:** Create shared Firebase config, then integrate dashboard to read existing paths (`/orders`, `/nudges`, `/grievances`) before adding new paths.
