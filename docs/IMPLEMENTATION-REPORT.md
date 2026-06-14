# Stars & Pines — v2 Implementation Report

**Date:** 2026-06-13
**Author:** Senior Product Architect
**Project:** Stars & Pines Hospitality Management System v2

---

## 1. ARCHITECTURAL DECISIONS

### 1.1 Local-First Architecture

**Decision:** Use IndexedDB as the local operational database, not SQLite.

**Rationale:**
- The system is browser-based (static HTML served by nginx). There is no server-side runtime.
- IndexedDB is the browser's native persistent storage — available in every modern browser, no dependencies.
- SQLite would require sql.js (WASM, ~600KB), adding complexity and load time.
- IndexedDB supports transactions, indexes, cursors, and stores gigabytes of data.
- The sync engine treats IndexedDB as the authoritative local store; Firebase is the sync target.

**Persistence Model:**
```
User Action → Write to IndexedDB (immediate, always succeeds)
            → Queue sync operation
            → Attempt Firebase push
            → If online: push succeeds, mark syncStatus = "synced"
            → If offline: queue persists, retry on reconnect
```

### 1.2 Sync Engine Design

**Decision:** Implement a queue-based sync engine with automatic retry and conflict resolution.

**Components:**
- `LocalDB` — IndexedDB wrapper with typed stores for each entity
- `SyncQueue` — FIFO queue of pending operations (create, update, delete)
- `SyncEngine` — Orchestrates sync, handles connectivity events, resolves conflicts
- `SyncStatus` — Real-time indicator shown in all apps

**Conflict Resolution Strategy:**
- Last-write-wins for simple fields (status, timestamps)
- Merge strategy for arrays (orders, items)
- Guest records are immutable after creation (no conflicts possible)
- Booking records: staff edits override guest-side changes

**Connectivity Detection:**
- `navigator.onLine` events
- Periodic heartbeat ping to Firebase
- Visual sync status indicator (green = synced, yellow = syncing, red = offline)

### 1.3 Firebase Role Change

**Before:** Firebase was the primary database. All reads/writes went directly to Firebase.

**After:** Firebase is a synchronization layer. The local IndexedDB is authoritative for the device. Firebase enables:
- Cross-device data sharing (staff phone ↔ dashboard laptop)
- Guest portal access from any device
- Backup and recovery

**Data Flow:**
```
Employee App (phone) → IndexedDB → SyncQueue → Firebase
                                                    ↓
Dashboard (laptop) ← IndexedDB ← SyncQueue ← Firebase
                                                    ↓
Guest Portal (phone) ← IndexedDB ← Firebase (read-through cache)
```

### 1.4 Guest Access Flow Redesign

**Before:** 6-character token alone grants access. No phone verification.

**After:** Dual-factor access:
- Access code (6 characters) + last 4 digits of registered phone number
- Both must match the booking record
- Prevents unauthorized access if code is shared

**Flow:**
```
Employee creates booking → generates access code → sends WhatsApp message
Guest receives WhatsApp → clicks link → enters code + last 4 of phone → access granted
```

### 1.5 Payment Architecture

**Decision:** Support both Razorpay (online) and QR code (manual) payment methods.

**Razorpay Integration:**
- Razorpay Checkout integration for online payments
- Payment ID stored in payment record
- Webhook handler (future: requires backend)
- For now: client-side payment confirmation

**QR Code Payment:**
- Static QR placeholder (UPI QR code image)
- Employee manually confirms payment received
- Payment recorded with manual confirmation flag

**Pay Later:**
- Creates outstanding balance record
- Dashboard notification generated
- Tracked in Financial Overview

### 1.6 Running Bill Architecture

**Decision:** Real-time bill calculation from multiple charge sources.

**Charge Sources:**
- Room charges (daily rate × nights)
- Food orders (from /orders)
- Service requests (from /experiences, /concierge)
- Additional charges (manual entry by staff)

**Calculation:**
```
Room Charges:    ₹4,200 (Mountain Double × 2 nights)
Food Orders:     ₹1,280 (all delivered orders)
Services:        ₹500  (bonfire request)
Taxes:           ₹0    (not applicable for now)
────────────────────────
Subtotal:        ₹5,980
Deposits:       -₹2,000
────────────────────────
Outstanding:     ₹3,980
```

### 1.7 Checkout Flow

**Decision:** Checkout requires payment settlement.

**Flow:**
```
Guest requests checkout → System generates itemized invoice
→ Guest pays (Razorpay / QR / Pay Later)
→ If paid: checkout_status = "completed"
→ If unpaid: checkout_status = "awaiting_payment"
→ Guest access code deactivated
→ Record archived to checkout_records
```

---

## 2. DATABASE SCHEMA (IndexedDB + Firebase)

### 2.1 IndexedDB Stores

| Store | Key | Indexes | Purpose |
|---|---|---|---|
| `guests` | `guestId` | `accessCode`, `phone`, `syncStatus` | Guest records |
| `bookings` | `bookingId` | `guestId`, `room`, `status`, `syncStatus` | Booking records |
| `rooms` | `roomId` | `type`, `status` | Room definitions |
| `payments` | `paymentId` | `bookingId`, `guestId`, `status`, `syncStatus` | Payment records |
| `menu_orders` | `orderId` | `guestId`, `room`, `status`, `syncStatus` | Food orders |
| `service_requests` | `requestId` | `guestId`, `type`, `status`, `syncStatus` | Service requests |
| `notifications` | `notificationId` | `guestId`, `read`, `syncStatus` | Notifications |
| `grievances` | `grievanceId` | `guestId`, `status`, `syncStatus` | Grievances |
| `activity_feed` | `activityId` | `type`, `timestamp` | Activity log |
| `checkout_records` | `checkoutId` | `guestId`, `status`, `syncStatus` | Checkout records |
| `sync_queue` | `queueId` (auto) | `status`, `priority`, `createdAt` | Pending sync operations |

### 2.2 Record Format (All Entities)

Every record includes:
```javascript
{
  id: string,           // Primary key
  createdAt: number,    // Timestamp (ms)
  updatedAt: number,    // Timestamp (ms)
  syncStatus: string    // "pending" | "syncing" | "synced" | "failed"
}
```

### 2.3 Firebase Schema (v2)

New paths added to existing schema:

| Path | Purpose |
|---|---|
| `/guests/{guestId}` | Guest master records |
| `/bookings/{bookingId}` | Booking records with payment info |
| `/payments/{paymentId}` | Payment transactions |
| `/checkout_records/{checkoutId}` | Completed checkout records |
| `/sync_status/{deviceId}` | Device sync status |

Existing paths preserved:
- `/orders/` → now also written to `menu_orders` locally
- `/nudges/` → now also written to `service_requests` locally
- `/grievances/` → now also written locally
- `/guest_access/` → preserved for backward compatibility
- `/experiences/` → now also written to `service_requests` locally
- `/concierge/` → now also written to `service_requests` locally
- `/activity_feed/` → preserved
- `/notifications/` → preserved

---

## 3. USER FLOWS (v2)

### 3.1 Booking Creation (Employee App)

```
Employee logs in → "New Booking"
→ Enters: Guest Name, Phone, Room, Check-in, Check-out, Deposit Amount
→ System validates: room available, dates valid
→ System generates: Guest ID (SP-G-XXXXXX), Access Code (6-char)
→ System creates: Guest Record, Booking Record
→ Saves to IndexedDB (immediate)
→ Queues Firebase sync
→ Employee can: "Send WhatsApp Link" or "Print Receipt"
```

### 3.2 WhatsApp Onboarding

```
Employee taps "Send Guest Access Link"
→ System opens: https://wa.me/{phone}?text={message}
→ Message includes: Guest Portal URL + Access Code
→ Guest clicks link → Portal opens with code pre-filled
→ Guest enters last 4 of phone → Access granted
```

### 3.3 Guest Portal Access

```
Guest visits: /portal?code=ABX72K
→ If code in URL: pre-fill code field
→ Guest enters: Access Code + Last 4 of Phone
→ System validates against local DB + Firebase
→ If match: show portal
→ If no match: show error
```

### 3.4 Running Bill View

```
Guest opens "Running Bill" tab
→ System calculates:
  - Room charges (from booking)
  - Food charges (from delivered orders)
  - Service charges (from completed requests)
  - Deposits (from payments)
→ Shows: Subtotal, Deposits, Outstanding
→ "Pay Now" button → Payment Center
```

### 3.5 Payment Flow

```
Guest opens "Payment Center"
→ Shows: Outstanding Amount
→ Options:
  A. "Pay with Razorpay" → Razorpay checkout → Payment recorded
  B. "Scan QR to Pay" → QR code displayed → Employee confirms
  C. "Pay Later" → Creates outstanding record → Dashboard notified
→ Payment recorded in IndexedDB → Synced to Firebase
→ Running bill updated
```

### 3.6 Checkout Flow

```
Guest opens "Checkout" tab
→ Taps "Request Checkout"
→ System generates itemized invoice:
  - Room charges
  - Food charges
  - Services
  - Deposits
  - Total due
→ Payment options:
  A. Razorpay → Pay → Checkout complete
  B. QR Code → Pay → Employee confirms → Checkout complete
  C. Pay Later → checkout_status = "awaiting_payment"
→ Access code deactivated
→ Record archived
```

### 3.7 Dashboard Operations

```
Manager opens Dashboard
→ Overview: heartbeat bar with sync status
→ Arrivals: today's check-ins
→ In-House: current guests with running bills
→ Departures: today's check-outs
→ Outstanding Payments: unpaid balances
→ Pending Checkouts: awaiting payment
→ Grievances: open/in-progress/resolved
→ Service Requests: pending/completed
→ Activity Feed: real-time log
→ Financial Overview: revenue, outstanding, deposits
```

---

## 4. FILE STRUCTURE (v2)

```
/var/www/stars-pines/
├── index.html                          # Public website (unchanged)
├── employee-app.html                   # Employee app (replaces ridge-bell-staff-app.html)
├── guest-portal.html                   # Guest portal (redesigned)
├── dashboard.html                      # Dashboard (expanded)
├── guest-entry.html                    # Guest entry (preserved for backward compat)
├── js/
│   ├── firebase-config.js              # Shared Firebase config
│   ├── local-db.js                     # IndexedDB wrapper
│   ├── sync-engine.js                  # Sync engine
│   ├── payment-engine.js               # Razorpay + QR payments
│   └── shared-utils.js                 # Shared utilities
├── database.rules.json                 # Updated security rules
└── firebase.json                       # Hosting config (updated rewrites)
```

---

## 5. MIGRATION STRATEGY

### Phase 1: Core Infrastructure
1. Deploy `local-db.js`, `sync-engine.js`, `payment-engine.js`, `shared-utils.js`
2. Update `firebase-config.js` with new config structure
3. Update `database.rules.json` with new paths

### Phase 2: Employee App
1. Deploy `employee-app.html` (replaces `ridge-bell-staff-app.html`)
2. Update nginx rewrite: `/staff` → `employee-app.html`
3. Preserve existing `/guest_access/` writes for backward compatibility

### Phase 3: Guest Portal
1. Deploy new `guest-portal.html`
2. New access flow: code + phone verification
3. Preserve existing order/nudge/grievance writes

### Phase 4: Dashboard
1. Deploy new `dashboard.html`
2. Add new modules: Arrivals, Departures, Financial Overview, Outstanding Payments
3. Preserve existing modules

### Phase 5: Data Migration
1. Existing `/guest_access/` records remain valid
2. Existing `/orders/` records remain valid
3. New records use dual-write (local + Firebase)
4. Old records gradually migrated as they are accessed

---

## 6. OFFLINE-FIRST BEHAVIOR

### When Online:
- All writes go to IndexedDB → immediately synced to Firebase
- Real-time listeners active
- Sync status: green

### When Offline:
- All writes go to IndexedDB → queued for sync
- Real-time listeners paused
- Sync status: red
- All operations continue normally
- Queue persists across page reloads

### When Reconnecting:
- Sync engine detects connectivity
- Processes queue in priority order (payments > bookings > orders > notifications)
- Updates sync status to green
- Real-time listeners resume

---

## 7. SECURITY CONSIDERATIONS

### Current Limitations (Preserved):
- Firebase API key exposed in client code (unavoidable for RTDB)
- No Firebase Auth (token-based access only)

### Improvements:
- Dual-factor guest access (code + phone)
- Server-side validation via database rules
- Activity logging for all major events
- Sync status tracking for audit

### Future Improvements (Out of Scope):
- Firebase Auth integration
- Role-based access control
- HTTPS/TLS for local network
- Rate limiting

---

## 8. DEPLOYMENT

### Prerequisites:
- Nginx installed and running
- Firebase project `stars-and-pines-ridge` active
- Internet connection for Firebase sync

### Deploy Steps:
```bash
# Copy files to web root
sudo cp *.html /var/www/stars-pines/
sudo cp js/*.js /var/www/stars-pines/js/
sudo cp database.rules.json /var/www/stars-pines/
sudo cp firebase.json /var/www/stars-pines/
sudo chown -R www-data:www-data /var/www/stars-pines

# Update Firebase rules
firebase deploy --only database

# Reload nginx
sudo service nginx reload
```

---

**Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601**
