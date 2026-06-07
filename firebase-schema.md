# Firebase Schema — Stars & Pines

**Project:** `stars-and-pines-ridge`
**Database URL:** `https://stars-and-pines-ridge-default-rtdb.asia-southeast1.firebasedatabase.app`
**SDK Version:** Firebase 10.12.0 (compat)
**Region:** `asia-southeast1`

---

## /guest_access

**Writer:** Staff App (`ridge-bell-staff-app.html`), Guest Entry (`guest-entry.html`), Seed Token (`seed-token.html`)
**Reader:** Guest Portal (`guest-portal.html`), Guest Entry (`guest-entry.html`)
**Purpose:** Guest access tokens for portal authentication. Generated at check-in, validated on portal entry.

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `token` | string | yes | 6-char alphanumeric code (e.g. `ABX72K`) |
| `guestName` | string | yes | Guest display name |
| `room` | string | yes | Room type (e.g. `Mountain Double`, `Six-Bed Dorm`) |
| `active` | boolean | yes | Whether token is valid |
| `validUntil` | number | yes | Expiry timestamp (ms) |
| `createdAt` | number | yes | Creation timestamp |
| `bookingId` | string | no | Set by guest-entry.html |
| `phone` | string | no | Guest phone number |
| `checkin` | number | no | Check-in timestamp |
| `checkout` | number | no | Check-out timestamp |
| `email` | string | no | Set during guest registration |
| `guests` | string | no | Number of guests |
| `nationality` | string | no | Guest nationality |
| `emergencyContact` | string | no | Emergency contact phone |
| `arrivalMethod` | string | no | How guest is arriving |
| `specialRequirements` | string | no | Dietary, accessibility notes |
| `registeredAt` | number | no | When guest completed registration |
| `status` | string | no | `checked-in`, `registered` |
| `source` | string | no | `staff-qr`, `ridge-bell-qr` |

**Dependencies:** Guest Portal auth flow, QR code generation, WhatsApp sharing

---

## /orders

**Writer:** Guest Portal (`guest-portal.html`), Staff App (`ridge-bell-staff-app.html`)
**Reader:** Guest Portal, Staff App, Dashboard (future)
**Purpose:** Food & beverage orders from guests. Push-based queue system.

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | `order_<timestamp>` |
| `room` | string | yes | Room name or bed number |
| `items` | array | yes | `[{ name, qty, price }]` |
| `total` | number | yes | Total in INR |
| `status` | string | yes | `pending`, `preparing`, `done`, `cancelled`, `ready`, `delivered` |
| `source` | string | yes | `portal`, `staff`, `website` |
| `guestToken` | string | no | Present for portal orders |
| `guestName` | string | no | Guest name for portal orders |
| `createdAt` | number | yes | Order creation timestamp |
| `updatedAt` | number | yes | Last status change timestamp |
| `notes` | string | no | Kitchen notes from guest |
| `statusHistory` | array | no | `[{ status, at }]` — only in portal orders |

**Status Flow:**
- Portal: `pending` → `preparing` → `ready` → `delivered` (or `cancelled`)
- Staff App: `pending` → `done` (or `cancelled`)
- **CONFLICT:** Staff App uses `done`, Portal uses `delivered`. These are semantically the same but different strings.

**Dependencies:** Kitchen Queue (Staff App), Order History (Guest Portal), Analytics (future)

---

## /nudges

**Writer:** Guest Portal (`guest-portal.html`), Staff App (`ridge-bell-staff-app.html`)
**Reader:** Guest Portal, Staff App, Dashboard (future)
**Purpose:** Lightweight house requests (towels, blankets, water, cleaning, firepit, tea).

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | `nudge_<timestamp>` |
| `room` | string | yes | Room name or `General` |
| `type` | string | yes | Snake_case: `extra_blanket`, `extra_towels`, `water_refill`, `room_cleaning`, `firepit_setup`, `tea_to_room`, `maintenance`, `guest_concern`, `low_stock`, `safety_flag` |
| `message` | string | yes | Human-readable confirmation message |
| `status` | string | yes | `sent` |
| `source` | string | no | `portal`, `staff` |
| `guestToken` | string | no | Present for portal nudges |
| `guestName` | string | no | Guest name for portal nudges |
| `createdAt` | number | yes | Creation timestamp |

**Dependencies:** Staff Nudge tab, Guest Portal "Your Stay" tab

---

## /grievances

**Writer:** Guest Portal (`guest-portal.html`)
**Reader:** Guest Portal, Staff App, Dashboard (future)
**Purpose:** Guest concerns/complaints with severity tracking and resolution workflow.

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | `grievance_<timestamp>` |
| `room` | string | yes | Room name |
| `type` | string | yes | `food`, `room`, `cleanliness`, `water`, `electricity`, `internet`, `noise`, `staff_assistance`, `other` |
| `message` | string | yes | Guest's description |
| `severity` | string | yes | `low`, `medium`, `high`, `urgent` |
| `status` | string | yes | `open`, `acknowledged`, `resolved`, `escalated` |
| `source` | string | yes | `portal` |
| `guestToken` | string | yes | Guest token |
| `guestName` | string | no | Guest name |
| `createdAt` | number | yes | Creation timestamp |
| `updatedAt` | number | yes | Last status change |
| `statusHistory` | array | no | `[{ status, at }]` |
| `acknowledgedBy` | string | no | Staff member name |
| `acknowledgedAt` | number | no | Acknowledgement timestamp |
| `resolvedBy` | string | no | Staff member name |
| `resolvedAt` | number | no | Resolution timestamp |

**Dependencies:** Staff App Grievances tab, Guest Portal "Your Stay" tab

---

## /experiences

**Writer:** Guest Portal (`guest-portal.html`)
**Reader:** Guest Portal
**Purpose:** Guest experience requests (bonfire, local guide, photography, village walk, bird watching, stargazing, transportation, special meal).

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | `exp_<timestamp>` |
| `type` | string | yes | `bonfire`, `local-guide`, `photography`, `village-walk`, `bird-watching`, `stargazing`, `transportation`, `special-meal` |
| `room` | string | yes | Room name |
| `guestToken` | string | yes | Guest token |
| `guestName` | string | no | Guest name |
| `status` | string | yes | `requested` |
| `createdAt` | number | yes | Creation timestamp |
| `updatedAt` | number | yes | Update timestamp |

**Dependencies:** Guest Portal "Your Stay" tab, Experiences panel

---

## /concierge

**Writer:** Guest Portal (`guest-portal.html`)
**Reader:** Guest Portal
**Purpose:** Digital concierge service requests (blankets, cleaning, hot water, laundry, taxi, wake-up call, medical, luggage).

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | `concierge_<timestamp>` |
| `type` | string | yes | Snake_case: `extra_blankets`, `room_cleaning`, `hot_water`, `laundry`, `taxi`, `wake-up_call`, `medical_help`, `luggage_assistance` |
| `room` | string | yes | Room name |
| `guestToken` | string | yes | Guest token |
| `guestName` | string | no | Guest name |
| `status` | string | yes | `requested` |
| `createdAt` | number | yes | Creation timestamp |

**Dependencies:** Guest Portal Concierge panel

---

## /events

**Writer:** Marketing Site (`index.html`), V4 site (`v4/index.html`), V3.5 site (`stars-and-pines-v3.5(1).html`)
**Reader:** None (write-only analytics)
**Purpose:** Conversion tracking events from the marketing website (clicks, scroll depth, section views, WhatsApp sends).

**Current Fields:**
| Field | Type | Required | Notes |
|---|---|---|---|
| `event` | string | yes | Event name (e.g. `whatsapp_form_send`, `scroll_depth`, `section_view`) |
| `ts` | number | yes | Timestamp |
| `...data` | any | no | Additional event-specific fields |

**Dependencies:** Marketing site analytics. Only fires when `whatsappNumber !== 'REPLACE_ME'`.

---

## Schema Summary

| Path | Writers | Readers | Active? |
|---|---|---|---|
| `/guest_access` | Staff App, Guest Entry, Seed Token | Guest Portal, Guest Entry | YES |
| `/orders` | Guest Portal, Staff App | Guest Portal, Staff App | YES |
| `/nudges` | Guest Portal, Staff App | Guest Portal, Staff App | YES |
| `/grievances` | Guest Portal | Guest Portal, Staff App | YES |
| `/experiences` | Guest Portal | Guest Portal | YES |
| `/concierge` | Guest Portal | Guest Portal | YES |
| `/events` | Marketing Site (3 copies) | None | YES (analytics only) |

---

## Missing Paths (Not Yet Implemented)

These paths are needed for the full architecture but do not exist yet:

| Path | Purpose |
|---|---|
| `/rooms` | Room/bed occupancy state |
| `/guests` | Active guest registry (distinct from access tokens) |
| `/inventory` | Kitchen stock levels and thresholds |
| `/menu` | Menu item availability and pricing |
| `/notifications` | System-wide alert/notification stream |
| `/iot/lights` | Lighting zone states |
| `/iot/media` | Music/speaker zone states |
| `/iot/motor` | Water motor control |
| `/iot/sensors` | Sensor readbacks (water level, etc.) |
| `/system/heartbeat` | System health status |
| `/system/status` | Overall system status |
| `/analytics` | Computed analytics (derived from operational data) |
