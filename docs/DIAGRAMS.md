# System Architecture — Stars & Pines

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         FIREBASE REALTIME DATABASE                          │
│                                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  ┌──────────────┐            │
│  │ /orders/ │  │ /nudges/ │  │ /grievances/ │  │ /guest_      │            │
│  │          │  │          │  │              │  │  access/     │            │
│  │ pending  │  │ sent     │  │ open         │  │              │            │
│  │ preparing│  │ resolved │  │ acknowledged │  │ active:true  │            │
│  │ done     │  │          │  │ resolved     │  │ validUntil   │            │
│  │ cancelled│  │          │  │ escalated    │  │ token        │            │
│  └──────────┘  └──────────┘  └──────────────┘  └──────────────┘            │
│                                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐                          │
│  │ /experiences/│  │ /concierge/  │  │ /events/ │                          │
│  │              │  │              │  │          │                          │
│  │ requested    │  │ requested    │  │ (future) │                          │
│  └──────────────┘  └──────────────┘  └──────────┘                          │
└──────┬──────────────────────┬──────────────────────┬────────────────────────┘
       │                      │                      │
       │  reads               │  reads/writes         │  reads/writes
       │                      │                      │
┌──────▼──────┐        ┌──────▼──────┐        ┌──────▼──────┐
│  PUBLIC     │        │  GUEST      │        │  RIDGE BELL │
│  WEBSITE    │        │  PORTAL     │        │  STAFF APP  │
│             │        │             │        │             │
│ index.html  │        │ guest-      │        │ ridge-bell- │
│             │        │ portal.html │        │ staff-app   │
│             │        │             │        │ .html       │
│ Editorial   │        │ Operational │        │ Dispatch    │
│ Atmospheric │        │ Field Guide │        │ Queue       │
│ Story       │        │ Functional  │        │ Log         │
│             │        │             │        │             │
│ Sections:   │        │ Tabs:       │        │ Tabs:       │
│ • Hero      │        │ • Food      │        │ • Queue     │
│ • Why       │        │ • Requests  │        │ • Order     │
│ • Day       │        │ • Concerns  │        │ • Nudge     │
│ • House     │        │ • Guide     │        │ • Concerns  │
│ • Rooms     │        │ • Experiences│       │ • Log       │
│ • Guide     │        │ • Concierge │        │ • Me        │
│ • Reviews   │        │ • Your Stay │        │             │
│ • Book      │        │             │        │ Features:   │
│             │        │ Access:     │        │ • Alerts    │
│ Features:   │        │ • Token URL │        │ • Sound     │
│ • Starfield │        │ • QR scan   │        │ • Vibration │
│ • Easter    │        │             │        │ • Offline   │
│   eggs      │        │             │        │ • Queue     │
│ • Booking   │        │             │        │             │
│   form      │        │             │        │             │
└─────────────┘        └──────┬──────┘        └──────┬──────┘
                              │                      │
                              │  writes               │  writes
                              │                      │
                       ┌──────▼──────┐        ┌──────▼──────┐
                       │  GUEST      │        │  GUEST      │
                       │  ENTRY      │        │  ENTRY      │
                       │             │        │             │
                       │ guest-      │        │ guest-      │
                       │ entry.html  │        │ entry.html  │
                       │             │        │             │
                       │ Staff Flow: │        │ Guest Flow: │
                       │ • Generate  │        │ • Scan QR   │
                       │   QR code   │        │ • Register  │
                       │ • Share WA  │        │ • Welcome   │
                       │             │        │ • Portal    │
                       └─────────────┘        └─────────────┘
```

---

## Data Flow — Guest Places an Order

```
┌─────────────┐
│   GUEST     │
│  Portal     │
│             │
│ 1. Opens    │
│    Food tab │
│             │
│ 2. Browses  │
│    menu     │
│             │
│ 3. Taps     │
│    items    │──────► Cart bar updates (count + total)
│             │
│ 4. Taps     │
│    "Send to │
│    kitchen" │
│             │
│ 5. Modal    │
│    confirms │
│             │
│ 6. Confirms │─────────────────────────────────────────────┐
│             │                                             │
└─────────────┘                                             │
                                                            │
                                                            ▼
┌───────────────────────────────────────────────────────────────────────┐
│                        FIREBASE REALTIME DB                           │
│                                                                       │
│  db.ref('orders').push({                                              │
│    id: "order_1717500000000",                                         │
│    room: "Mountain Double",                                           │
│    items: [{name:"Thukpa",qty:1,price:180},{name:"Butter naan",       │
│           qty:2,price:35}],                                           │
│    total: 250,                                                        │
│    status: "pending",                                                 │
│    source: "portal",                                                  │
│    guestToken: "ABX72K",                                              │
│    guestName: "Priya K.",                                             │
│    createdAt: 1717500000000,                                          │
│    updatedAt: 1717500000000,                                          │
│    notes: "Extra spicy please"                                        │
│  })                                                                   │
│                                                                       │
│  ◄── Write confirmed ────────────────────────────────────────────────►│
└──────────────────────────┬────────────────────────────────────────────┘
                           │
                           │  'value' event fires
                           │  'child_added' event fires
                           │
                           ▼
┌───────────────────────────────────────────────────────────────────────┐
│                        RIDGE BELL STAFF APP                           │
│                                                                       │
│  1. ordersRef.on('value') fires                                       │
│     → renderOrders() re-renders the entire queue                      │
│                                                                       │
│  2. ordersRef.on('child_added') fires                                 │
│     → initialSyncComplete check                                       │
│     → if true: showIncoming() + playAlertSound() + vibrate()          │
│     → banner slides down: "New order — Mountain Double"               │
│     → badge dot appears on queue icon                                 │
│                                                                       │
│  3. Staff sees order in Queue tab                                     │
│     → Room: Mountain Double · Portal                                  │
│     → Items: Thukpa × 1, Butter naan × 2                              │
│     → Notes: "Extra spicy please"                                     │
│     → Time: Just now                                                  │
│     → [Done ✓]  [Cancel]                                              │
│                                                                       │
│  4. Staff taps "Done ✓"                                               │
│     → modal confirms                                                  │
│     → db.ref('orders/{key}').update({status:"done", updatedAt:...})   │
│                                                                       │
└──────────────────────────┬────────────────────────────────────────────┘
                           │
                           │  'value' event fires
                           │
                           ▼
┌───────────────────────────────────────────────────────────────────────┐
│                        GUEST PORTAL                                   │
│                                                                       │
│  1. ordersRef.on('value') fires                                       │
│     → updateStayOrders() called                                       │
│     → filters orders by guestToken                                    │
│     → sorts by createdAt desc                                         │
│     → separates active (pending/preparing/ready) from done            │
│                                                                       │
│  2. "Your Stay" tab updates:                                          │
│     → Active orders: order removed (status = "done")                  │
│     → Order history: order appears with "Delivered" status            │
│                                                                       │
│  3. Guest sees:                                                       │
│     ┌─────────────────────────────────────┐                           │
│     │ Delivered                           │                           │
│     │ Thukpa × 1, Butter naan × 2         │                           │
│     │ ₹250          7:32 PM               │                           │
│     └─────────────────────────────────────┘                           │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

---

## Data Flow — Guest Raises a Concern

```
┌─────────────┐
│   GUEST     │
│  Portal     │
│             │
│ 1. Opens    │
│    Concerns │
│    tab      │
│             │
│ 2. Selects  │
│    type:    │
│    "Water   │
│    issue"   │
│             │
│ 3. Selects  │
│    urgency: │
│    "High"   │
│             │
│ 4. Writes   │
│    message: │
│    "Hot     │
│    water    │
│    not      │
│    working" │
│             │
│ 5. Taps     │
│    "Submit" │─────────────────────────────────────────────────────┐
│             │                                                     │
└─────────────┘                                                     │
                                                                    │
                                                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         FIREBASE REALTIME DB                             │
│                                                                          │
│  db.ref('grievances').push({                                             │
│    id: "grievance_1717500000000",                                        │
│    room: "Mountain Double",                                              │
│    type: "water_issue",                                                  │
│    message: "Hot water not working",                                     │
│    severity: "high",                                                     │
│    status: "open",                                                       │
│    source: "portal",                                                     │
│    guestToken: "ABX72K",                                                 │
│    guestName: "Priya K.",                                                │
│    createdAt: 1717500000000,                                             │
│    updatedAt: 1717500000000,                                             │
│    statusHistory: [{status:"open", at:1717500000000}]                    │
│  })                                                                      │
│                                                                          │
└──────────────────────────┬───────────────────────────────────────────────┘
                           │
                           │  'value' event fires
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         RIDGE BELL STAFF APP                             │
│                                                                          │
│  1. grievancesRef.on('value') fires                                      │
│     → renderGrievances() called                                          │
│                                                                          │
│  2. Grievance appears in Concerns tab:                                   │
│     ┌──────────────────────────────────────────────┐                     │
│     │  🚩  URGENT (red border)                     │                     │
│     │  Mountain Double · Portal                    │                     │
│     │  Water Issue                                 │                     │
│     │  "Hot water not working"                     │                     │
│     │  Just now              open                  │                     │
│     │  [Acknowledge]  [Resolve]                    │                     │
│     └──────────────────────────────────────────────┘                     │
│                                                                          │
│  3. Grievance dot appears on Concerns nav icon                           │
│                                                                          │
│  4. Staff taps "Acknowledge"                                             │
│     → db.ref('grievances/{key}').update({                                │
│         status: "acknowledged",                                          │
│         acknowledgedBy: "Meena",                                         │
│         acknowledgedAt: 1717500000000                                    │
│       })                                                                 │
│                                                                          │
│  5. Staff taps "Resolve"                                                 │
│     → db.ref('grievances/{key}').update({                                │
│         status: "resolved",                                              │
│         resolvedBy: "Meena",                                             │
│         resolvedAt: 1717500000000                                        │
│       })                                                                 │
│                                                                          │
└──────────────────────────┬───────────────────────────────────────────────┘
                           │
                           │  'value' event fires
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         GUEST PORTAL                                     │
│                                                                          │
│  1. grievancesRef.on('value') fires                                      │
│     → updateStayGrievances() called                                      │
│                                                                          │
│  2. "Your Stay" tab updates:                                             │
│     ┌──────────────────────────────────────────────┐                     │
│     │ Acknowledged                                 │                     │
│     │ Water Issue                                  │                     │
│     │ "Hot water not working"                      │                     │
│     │ 5 Jun                                        │                     │
│     └──────────────────────────────────────────────┘                     │
│                                                                          │
│  3. After resolve:                                                       │
│     ┌──────────────────────────────────────────────┐                     │
│     │ Resolved                                     │                     │
│     │ Water Issue                                  │                     │
│     │ "Hot water not working"                      │                     │
│     │ 5 Jun                                        │                     │
│     └──────────────────────────────────────────────┘                     │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Access Token Lifecycle

```
┌─────────────────────────────────────────────────────────────────────┐
│                        TOKEN LIFECYCLE                              │
│                                                                     │
│  ┌─────────────┐                                                    │
│  │  CREATED    │  Staff generates token at check-in                 │
│  │             │  • Ridge Bell Me tab OR guest-entry.html           │
│  │  token:     │  • 6-char alphanumeric: [A-Z0-9]{6}               │
│  │  "ABX72K"   │  • Stored in /guest_access/ABX72K                  │
│  │             │  • active: true                                    │
│  │             │  • validUntil: checkout + 24h                      │
│  └──────┬──────┘                                                    │
│         │                                                           │
│         ▼                                                           │
│  ┌─────────────┐                                                    │
│  │  SHARED     │  Token reaches guest                               │
│  │             │  • QR code scan → auto-fills token                 │
│  │  Ways:      │  • WhatsApp message with link                      │
│  │  • QR code  │  • Verbal (guest types manually)                   │
│  │  • WhatsApp │                                                    │
│  │  • Verbal   │                                                    │
│  └──────┬──────┘                                                    │
│         │                                                           │
│         ▼                                                           │
│  ┌─────────────┐                                                    │
│  │  VALIDATED  │  Guest visits guest-portal.html?token=ABX72K       │
│  │             │  • Checks active === true                          │
│  │  Checks:    │  • Checks Date.now() <= validUntil                 │
│  │  • active   │  • If either fails → elegant access screen         │
│  │  • valid    │                                                    │
│  │  Until      │                                                    │
│  └──────┬──────┘                                                    │
│         │                                                           │
│         ▼                                                           │
│  ┌─────────────┐                                                    │
│  │  ACTIVE     │  Guest uses portal during stay                     │
│  │             │  • Orders food                                     │
│  │  Guest:     │  • Makes requests                                  │
│  │  • Orders   │  • Raises concerns                                 │
│  │  • Requests │  • Explores guide                                  │
│  │  • Concerns │  • Requests experiences                            │
│  │  • Guide    │                                                    │
│  │  • More     │                                                    │
│  └──────┬──────┘                                                    │
│         │                                                           │
│         ▼                                                           │
│  ┌─────────────┐                                                    │
│  │  EXPIRED    │  Token expires after validUntil                    │
│  │             │  • active: false OR validUntil passed              │
│  │  Result:    │  • Guest sees access screen                        │
│  │  • Portal   │  • "That code doesn't match our records"           │
│  │    denied   │  • Must contact desk for new code                  │
│  │             │                                                    │
│  └─────────────┘                                                    │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  MANUAL DEACTIVATION (anytime)                              │   │
│  │  Staff sets active: false in Firebase                       │   │
│  │  → Portal immediately denies access                         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Guest Check-In Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        GUEST CHECK-IN FLOW                                  │
│                                                                             │
│  ┌─────────────────────┐                                                    │
│  │  GUEST ARRIVES      │                                                    │
│  │  at Stars & Pines   │                                                    │
│  └──────────┬──────────┘                                                    │
│             │                                                               │
│             ▼                                                               │
│  ┌─────────────────────┐                                                    │
│  │  STAFF OPENS        │                                                    │
│  │  Ridge Bell App     │                                                    │
│  │  → Me tab           │                                                    │
│  └──────────┬──────────┘                                                    │
│             │                                                               │
│             ▼                                                               │
│  ┌─────────────────────┐                                                    │
│  │  ENTERS:            │                                                    │
│  │  • Guest name       │                                                    │
│  │  • Room             │                                                    │
│  │  • (optional)       │                                                    │
│  │    check-in/out     │                                                    │
│  └──────────┬──────────┘                                                    │
│             │                                                               │
│             ▼                                                               │
│  ┌─────────────────────┐                                                    │
│  │  GENERATES:         │                                                    │
│  │  • 6-char token     │  e.g., ABX72K                                      │
│  │  • QR code          │  Links to guest-portal.html?token=ABX72K           │
│  │  • Firebase record  │  /guest_access/ABX72K                              │
│  └──────────┬──────────┘                                                    │
│             │                                                               │
│        ┌────┴────┐                                                          │
│        ▼         ▼                                                          │
│  ┌──────────┐ ┌──────────────┐                                              │
│  │ OPTION A │ │  OPTION B    │                                              │
│  │ QR Scan  │ │  WhatsApp    │                                              │
│  │          │ │              │                                              │
│  │ Guest    │ │ Staff shares │                                              │
│  │ scans QR │ │ link via WA  │                                              │
│  │ code     │ │              │                                              │
│  └────┬─────┘ └──────┬───────┘                                              │
│       │              │                                                      │
│       ▼              ▼                                                      │
│  ┌─────────────────────────┐                                                │
│  │  GUEST OPENS LINK       │                                                │
│  │  guest-portal.html      │                                                │
│  │  ?token=ABX72K          │                                                │
│  └──────────┬──────────────┘                                                │
│             │                                                               │
│             ▼                                                               │
│  ┌─────────────────────────┐                                                │
│  │  TOKEN VALIDATED        │                                                │
│  │  • active === true      │                                                │
│  │  • validUntil not past  │                                                │
│  └──────────┬──────────────┘                                                │
│             │                                                               │
│             ▼                                                               │
│  ┌─────────────────────────┐                                                │
│  │  PORTAL OPENS           │                                                │
│  │  "Good evening, Priya"  │                                                │
│  │  Mountain Double        │                                                │
│  │  ABX72K                 │                                                │
│  │                         │                                                │
│  │  [Food] [Requests]      │                                                │
│  │  [Concerns] [Guide]     │                                                │
│  │  [Experiences] [Stay]   │                                                │
│  └─────────────────────────┘                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Offline Support Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        OFFLINE SUPPORT                                      │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  ONLINE STATE                                                       │   │
│  │  • Firebase listeners active                                        │   │
│  │  • Writes go directly to Firebase                                   │   │
│  │  • Real-time sync between all apps                                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                             │                                               │
│                             │  Internet drops                               │
│                             ▼                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  OFFLINE DETECTED                                                   │   │
│  │  • navigator.onLine === false                                       │   │
│  │  • Banner: "Offline — changes will sync"                            │   │
│  │  • Firebase listeners still registered (will fire on reconnect)     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                             │                                               │
│                             │  Staff marks order done                       │
│                             ▼                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  WRITE QUEUED                                                       │   │
│  │  • queueWrite() adds to pendingWrites array                         │   │
│  │  • UI updates immediately (optimistic)                              │   │
│  │  • Toast: "Offline — will sync when connected"                      │   │
│  │                                                                     │   │
│  │  pendingWrites: [                                                   │   │
│  │    {                                                                │   │
│  │      path: "orders/-abc123",                                        │   │
│  │      method: "update",                                              │   │
│  │      data: { status: "done", updatedAt: 1717500000000 }             │   │
│  │    }                                                                │   │
│  │  ]                                                                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                             │                                               │
│                             │  Internet returns                             │
│                             ▼                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  RECONNECT DETECTED                                                 │   │
│  │  • navigator.onLine === true                                        │   │
│  │  • Banner: "Back online — syncing..."                               │   │
│  │  • flushQueue() called                                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                             │                                               │
│                             ▼                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  QUEUE FLUSHED                                                      │   │
│  │  • For each pendingWrite:                                           │   │
│  │    - db.ref(path)[method](data)                                     │   │
│  │    - Remove from pendingWrites on success                           │   │
│  │  • Banner: "All changes synced"                                     │   │
│  │  • Firebase listeners fire → all apps update                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Order Status State Machine

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ORDER STATUS FLOW                                    │
│                                                                             │
│                                                                             │
│  ┌──────────┐                                                               │
│  │ PENDING  │ ◄── Order placed (portal, website, or staff)                  │
│  │          │                                                               │
│  │ • Shows  │                                                               │
│  │   in     │                                                               │
│  │   queue  │                                                               │
│  │ • Alert  │                                                               │
│  │   fires  │                                                               │
│  └────┬─────┘                                                               │
│       │                                                                     │
│       │  Staff taps "Preparing" (future)                                    │
│       │  OR stays pending until done                                        │
│       ▼                                                                     │
│  ┌──────────────┐                                                           │
│  │  PREPARING   │ ◄── Optional intermediate state                           │
│  │              │                                                           │
│  │ • Still in   │                                                           │
│  │   queue      │                                                           │
│  │ • Guest sees │                                                           │
│  │   "Preparing"│                                                           │
│  └──────┬───────┘                                                           │
│         │                                                                   │
│         │  Staff taps "Done ✓"                                              │
│         ▼                                                                   │
│  ┌──────────┐                                                               │
│  │   DONE   │ ◄── Order completed                                           │
│  │          │                                                               │
│  │ • Removed│                                                               │
│  │   from   │                                                               │
│  │   queue  │                                                               │
│  │ • Appears│                                                               │
│  │   in     │                                                               │
│  │   history│                                                               │
│  │ • Guest  │                                                               │
│  │   sees   │                                                               │
│  │   "Ready │                                                               │
│  │   for    │                                                               │
│  │   pickup"│                                                               │
│  └──────────┘                                                               │
│                                                                             │
│  ┌──────────┐                                                               │
│  │ CANCELLED│ ◄── Staff taps "Cancel" at any point                          │
│  │          │                                                               │
│  │ • Removed│                                                               │
│  │   from   │                                                               │
│  │   queue  │                                                               │
│  │ • Appears│                                                               │
│  │   in     │                                                               │
│  │   history│                                                               │
│  │ • Not    │                                                               │
│  │   charged│                                                               │
│  └──────────┘                                                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## App Interaction Matrix

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        APP INTERACTION MATRIX                               │
│                                                                             │
│  ┌──────────────────┬──────────┬──────────────┬──────────────┬────────────┐ │
│  │                  │ Website  │ Guest Portal │ Ridge Bell   │ Guest Entry│ │
│  ├──────────────────┼──────────┼──────────────┼──────────────┼────────────┤ │
│  │ Website          │    —     │     —        │     —        │     —      │ │
│  │                  │          │              │              │            │ │
│  │ Guest Portal     │  reads   │     —        │  reads       │  writes    │ │
│  │                  │  orders  │              │  orders      │  tokens    │ │
│  │                  │          │              │  nudges      │            │ │
│  │                  │          │              │  grievances  │            │ │
│  │                  │          │              │  experiences │            │ │
│  │                  │          │              │  concierge   │            │ │
│  ├──────────────────┼──────────┼──────────────┼──────────────┼────────────┤ │
│  │ Ridge Bell       │  writes  │  reads       │     —        │  reads     │ │
│  │                  │  orders  │  writes      │              │  tokens    │ │
│  │                  │          │  orders      │              │            │ │
│  │                  │          │  nudges      │              │            │ │
│  │                  │          │  grievances  │              │            │ │
│  │                  │          │  experiences │              │            │ │
│  │                  │          │  concierge   │              │            │ │
│  │                  │          │  tokens      │              │            │ │
│  ├──────────────────┼──────────┼──────────────┼──────────────┼────────────┤ │
│  │ Guest Entry      │    —     │  redirects   │  generates   │     —      │ │
│  │                  │          │  to portal   │  tokens      │            │ │
│  └──────────────────┴──────────┴──────────────┴──────────────┴────────────┘ │
│                                                                             │
│  Key:                                                                       │
│  • Website writes orders → Firebase → Ridge Bell reads                      │
│  • Guest Portal writes orders/nudges/grievances → Firebase → Ridge Bell     │
│  • Ridge Bell writes orders/nudges → Firebase → Guest Portal reads          │
│  • Guest Entry generates tokens → Firebase → Guest Portal validates         │
│  • Ridge Bell generates tokens → Firebase → Guest Portal validates          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Firebase Collection Relationships

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        FIREBASE COLLECTION RELATIONSHIPS                    │
│                                                                             │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  /guest_access/{token}                                              │   │
│  │                                                                     │   │
│  │  token: "ABX72K"  ◄────────── PRIMARY KEY                           │   │
│  │  guestName: "Priya K."                                              │   │
│  │  room: "Mountain Double"                                            │   │
│  │  active: true                                                       │   │
│  │  validUntil: 1717586400000                                          │   │
│  └──────────────────────────┬──────────────────────────────────────────┘   │
│                             │                                               │
│          guestToken: "ABX72K" (links all guest actions to this token)       │
│                             │                                               │
│         ┌───────────────────┼───────────────────┐                          │
│         ▼                   ▼                   ▼                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                     │
│  │  /orders/    │  │  /nudges/    │  │ /grievances/ │                     │
│  │              │  │              │  │              │                     │
│  │ guestToken:  │  │ guestToken:  │  │ guestToken:  │                     │
│  │ "ABX72K"     │  │ "ABX72K"     │  │ "ABX72K"     │                     │
│  │              │  │              │  │              │                     │
│  │ room:        │  │ room:        │  │ room:        │                     │
│  │ "Mountain    │  │ "Mountain    │  │ "Mountain    │                     │
│  │  Double"     │  │  Double"     │  │  Double"     │                     │
│  │              │  │              │  │              │                     │
│  │ guestName:   │  │ guestName:   │  │ guestName:   │                     │
│  │ "Priya K."   │  │ "Priya K."   │  │ "Priya K."   │                     │
│  └──────────────┘  └──────────────┘  └──────────────┘                     │
│                                                                             │
│         ┌───────────────────┐                  ┌──────────────┐            │
│         ▼                   ▼                  ▼              │            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │            │
│  │ /experiences/│  │ /concierge/  │  │  /events/    │        │            │
│  │              │  │              │  │  (future)    │        │            │
│  │ guestToken:  │  │ guestToken:  │  │              │        │            │
│  │ "ABX72K"     │  │ "ABX72K"     │  │              │        │            │
│  └──────────────┘  └──────────────┘  └──────────────┘        │            │
│                                                               │            │
│  All collections are linked by:                               │            │
│  1. guestToken — identifies which guest performed the action  │            │
│  2. room — identifies which room the action relates to        │            │
│  3. guestName — human-readable guest identifier               │            │
│                                                               │            │
│  Query pattern:                                               │            │
│  Object.values(orders).filter(o => o.guestToken === token)    │            │
│                                                               │            │
└─────────────────────────────────────────────────────────────────────────────┘
```
