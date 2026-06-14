# Flowcharts — Stars & Pines

## Complete Guest Journey

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        COMPLETE GUEST JOURNEY                               │
│                                                                             │
│                                                                             │
│  DISCOVERY PHASE                                                            │
│  ═══════════════════                                                        │
│                                                                             │
│  [Guest searches "mountain stay Almora"]                                    │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │   Finds Website       │                                      │
│              │   index.html          │                                      │
│              └───────────┬───────────┘                                      │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │   Reads:              │                                      │
│              │   • Hero (starfield)  │                                      │
│              │   • Why People Come   │                                      │
│              │   • A Day Here        │                                      │
│              │   • The House         │                                      │
│              │   • Rooms             │                                      │
│              │   • The Guide         │                                      │
│              │   • Reviews           │                                      │
│              └───────────┬───────────┘                                      │
│                          │                                                  │
│                    Interested?                                               │
│                    /         \                                               │
│                  Yes          No                                             │
│                  /              \                                            │
│                 ▼                ▼                                           │
│    ┌──────────────────┐  [Leaves site]                                      │
│    │  Books via:      │                                                     │
│    │  • WhatsApp      │                                                     │
│    │  • Instagram     │                                                     │
│    │  • Booking.com   │                                                     │
│    │  • Email         │                                                     │
│    │  • Quick form    │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│  BOOKING PHASE                                                              │
│  ═══════════════════                                                        │
│                                                                             │
│    ┌──────────────────┐                                                     │
│    │  Direct booking  │                                                     │
│    │  with property   │                                                     │
│    │  (WhatsApp/call) │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│    ┌──────────────────┐                                                     │
│    │  Booking         │                                                     │
│    │  confirmed       │                                                     │
│    │  Dates set       │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│  ARRIVAL PHASE                                                              │
│  ═══════════════════                                                        │
│                                                                             │
│    ┌──────────────────┐                                                     │
│    │  Guest arrives   │                                                     │
│    │  at property     │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│    ┌──────────────────┐                                                     │
│    │  Staff opens     │                                                     │
│    │  Ridge Bell app  │                                                     │
│    │  → Me tab        │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│    ┌──────────────────┐                                                     │
│    │  Staff enters:   │                                                     │
│    │  • Guest name    │                                                     │
│    │  • Room          │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│    ┌──────────────────┐                                                     │
│    │  Token generated │                                                     │
│    │  (6-char code)   │                                                     │
│    │  e.g., ABX72K    │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│        ┌────┴────┐                                                          │
│        ▼         ▼                                                          │
│  ┌──────────┐ ┌──────────────┐                                              │
│  │ QR Code  │ │ WhatsApp    │                                               │
│  │ shown    │ │ link sent   │                                               │
│  └────┬─────┘ └──────┬───────┘                                              │
│       │              │                                                      │
│       └──────┬───────┘                                                      │
│              │                                                               │
│              ▼                                                               │
│  STAY PHASE                                                                 │
│  ═══════════════════                                                        │
│                                                                             │
│    ┌──────────────────────────────────────────────────────────────────┐    │
│    │  GUEST OPENS PORTAL                                              │    │
│    │  guest-portal.html?token=ABX72K                                  │    │
│    │                                                                  │    │
│    │  "Good evening, Priya"                                           │    │
│    │  Mountain Double · ABX72K                                        │    │
│    └──────────────────────────────────────────────────────────────────┘    │
│              │                                                               │
│         ┌────┴────┐                                                          │
│         ▼         ▼                                                          │
│    ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐       │
│    │  Food  │ │Requests│ │Concerns│ │ Guide  │ │  Exp.  │ │  Stay  │       │
│    └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘       │
│        │          │          │          │          │          │             │
│        ▼          ▼          ▼          ▼          ▼          ▼             │
│   ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐       │
│   │Browse  │ │One-tap │ │Select  │ │Browse  │ │Request │ │View    │       │
│   │menu    │ │requests│ │type +  │ │places  │ │bonfire,│ │orders, │       │
│   │        │ │blanket,│ │write   │ │trails, │ │guide,  │ │requests│       │
│   │Add to  │ │towels, │ │message │ │cafes,  │ │bird    │ │concerns│       │
│   │cart    │ │water,  │ │submit  │ │contacts│ │watch,  │ │        │       │
│   │        │ │cleaning│ │        │ │        │ │stargaze│ │        │       │
│   │Send to │ │tea     │ │        │ │Bookmark│ │taxi    │ │        │       │
│   │kitchen │ │        │ │        │ │places  │ │        │ │        │       │
│   └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘       │
│       │          │          │          │          │          │             │
│       ▼          ▼          ▼          ▼          ▼          ▼             │
│   ┌──────────────────────────────────────────────────────────────────┐    │
│   │  ALL ACTIONS WRITE TO FIREBASE IN REAL-TIME                      │    │
│   │  /orders/  /nudges/  /grievances/  /experiences/  /concierge/    │    │
│   └──────────────────────────────────────────────────────────────────┘    │
│              │                                                               │
│              ▼                                                               │
│    ┌──────────────────────────────────────────────────────────────────┐    │
│    │  STAFF APP RECEIVES EVERYTHING INSTANTLY                         │    │
│    │                                                                  │    │
│    │  Queue tab:    New orders appear with alert + sound + vibration  │    │
│    │  Nudge tab:    Requests appear for staff to action               │    │
│    │  Concerns tab: Grievances appear with priority indicators        │    │
│    │  Log tab:      Full activity history                             │    │
│    └──────────────────────────────────────────────────────────────────┘    │
│              │                                                               │
│              ▼                                                               │
│    ┌──────────────────────────────────────────────────────────────────┐    │
│    │  STAFF ACTIONS                                                   │    │
│    │                                                                  │    │
│    │  • Mark orders done/cancel                                       │    │
│    │  • Fulfill requests (bring blankets, clean room, etc.)           │    │
│    │  • Acknowledge → resolve grievances                              │    │
│    │  • Arrange experiences (bonfire, guide, taxi)                    │    │
│    │  • Place orders on behalf of guests                              │    │
│    └──────────────────────────────────────────────────────────────────┘    │
│              │                                                               │
│              ▼                                                               │
│    ┌──────────────────────────────────────────────────────────────────┐    │
│    │  GUEST SEES UPDATES IN REAL-TIME                                 │    │
│    │                                                                  │    │
│    │  • Order status: Pending → Preparing → Ready → Delivered         │    │
│    │  • Request status: Noted                                         │    │
│    │  • Grievance status: Open → Acknowledged → Resolved              │    │
│    │  • Experience status: Requested                                  │    │
│    └──────────────────────────────────────────────────────────────────┘    │
│              │                                                               │
│              ▼                                                               │
│  CHECKOUT PHASE                                                             │
│  ═══════════════════                                                        │
│                                                                             │
│    ┌──────────────────┐                                                     │
│    │  Guest checks    │                                                     │
│    │  out             │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│    ┌──────────────────┐                                                     │
│    │  Staff sets      │                                                     │
│    │  active: false   │                                                     │
│    │  in Firebase     │                                                     │
│    └────────┬─────────┘                                                     │
│             │                                                               │
│             ▼                                                               │
│    ┌──────────────────┐                                                     │
│    │  Token expires   │                                                     │
│    │  Portal denied   │                                                     │
│    │  on next visit   │                                                     │
│    └──────────────────┘                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Order Placement Flow (Detailed)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ORDER PLACEMENT FLOW                                 │
│                                                                             │
│                                                                             │
│  GUEST PORTAL                                                               │
│  ═══════════════════                                                        │
│                                                                             │
│  [Guest opens Food tab]                                                     │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Kitchen status    │                                                      │
│  │ check:            │                                                      │
│  │                   │                                                      │
│  │ 7-10 AM: Open     │                                                      │
│  │ 10-12:30: Closed  │                                                      │
│  │ 12:30-3: Open     │                                                      │
│  │ 3-7: Closed       │                                                      │
│  │ 7-9:30: Open      │                                                      │
│  │ 9:30-7: Closed    │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Browse menu       │                                                      │
│  │ • Search bar      │                                                      │
│  │ • Category filters│                                                      │
│  │ • Today's specials│                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  [Guest taps menu item]                                                      │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Item added to     │                                                      │
│  │ cart              │                                                      │
│  │ • qty++           │                                                      │
│  │ • item.selected   │                                                      │
│  │ • qty badge shows │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Cart bar slides   │                                                      │
│  │ up from bottom    │                                                      │
│  │ • "2 items · ₹300"│                                                      │
│  │ • Item names      │                                                      │
│  │ • [Send to        │                                                      │
│  │   kitchen →]      │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  [Guest taps "Send to kitchen"]                                              │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Confirmation      │                                                      │
│  │ modal appears     │                                                      │
│  │ • Items listed    │                                                      │
│  │ • Total shown     │                                                      │
│  │ • Notes field     │                                                      │
│  │ • [Go back]       │                                                      │
│  │ • [Confirm & send]│                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│      ┌────┴────┐                                                             │
│      ▼         ▼                                                             │
│  [Go back]  [Confirm & send]                                                 │
│      │              │                                                        │
│      ▼              ▼                                                        │
│  [Modal     ┌───────────────────┐                                            │
│   closes]   │ db.ref('orders')  │                                            │
│             │ .push(orderData)  │                                            │
│             └────────┬──────────┘                                            │
│                      │                                                       │
│                 Success?                                                     │
│                 /         \                                                  │
│               Yes          No                                                │
│               /              \                                               │
│              ▼                ▼                                              │
│  ┌──────────────────┐  ┌──────────────────┐                                 │
│  │ Cart cleared     │  │ Toast:           │                                 │
│  │ Menu items reset │  │ "Could not send  │                                 │
│  │ Toast:           │  │  order. Please   │                                 │
│  │ "Order sent to   │  │  try again."     │                                 │
│  │  the kitchen"    │  │ Cart preserved   │                                 │
│  └──────────────────┘  └──────────────────┘                                 │
│                                                                             │
│  STAFF APP (simultaneous)                                                   │
│  ═══════════════════════                                                    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Firebase 'child_added' event fires                                 │   │
│  │                                                                     │   │
│  │  1. initialSyncComplete check → true (not initial load)             │   │
│  │  2. source === 'portal' AND status === 'pending' → YES              │   │
│  │  3. showIncoming(room, items)                                       │   │
│  │     → Banner: "New order — Mountain Double"                         │   │
│  │     → playAlertSound() (two-tone bell)                              │   │
│  │     → vibrate([50,50,100,50,150])                                   │   │
│  │     → Badge dot appears                                             │   │
│  │     → Auto-dismiss after 8 seconds                                  │   │
│  │                                                                     │   │
│  │  4. Firebase 'value' event fires                                    │   │
│  │     → renderOrders() re-renders entire queue                        │   │
│  │     → New order appears at top                                      │   │
│  │     → Room: Mountain Double · Portal                                │   │
│  │     → Items: Thukpa × 1, Butter naan × 2                            │   │
│  │     → Time: Just now                                                │   │
│  │     → [Done ✓]  [Cancel]                                            │   │
│  │                                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Grievance Resolution Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        GRIEVANCE RESOLUTION FLOW                            │
│                                                                             │
│                                                                             │
│  GUEST PORTAL                                                               │
│  ═══════════════════                                                        │
│                                                                             │
│  [Guest opens Concerns tab]                                                 │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Select grievance  │                                                      │
│  │ type:             │                                                      │
│  │                   │                                                      │
│  │ • Food            │                                                      │
│  │ • Room            │                                                      │
│  │ • Cleanliness     │                                                      │
│  │ • Water           │                                                      │
│  │ • Electricity     │                                                      │
│  │ • Internet        │                                                      │
│  │ • Noise           │                                                      │
│  │ • Staff assist.   │                                                      │
│  │ • Other           │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Select urgency:   │                                                      │
│  │                   │                                                      │
│  │ • Low    (grey)   │                                                      │
│  │ • Medium (amber)  │                                                      │
│  │ • High   (orange) │                                                      │
│  │ • Urgent (red)    │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Write message     │                                                      │
│  │ (required)        │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Submit button     │                                                      │
│  │ enabled when:     │                                                      │
│  │ • type selected   │                                                      │
│  │ • message > 0     │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  [Guest taps Submit]                                                         │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Write to Firebase │                                                      │
│  │ /grievances/      │                                                      │
│  │                   │                                                      │
│  │ status: "open"    │                                                      │
│  │ statusHistory:    │                                                      │
│  │   [{open, now}]   │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Toast:            │                                                      │
│  │ "Your concern has │                                                      │
│  │  been noted.      │                                                      │
│  │  We'll take care  │                                                      │
│  │  of it."          │                                                      │
│  └───────────────────┘                                                      │
│                                                                             │
│  STAFF APP (simultaneous)                                                   │
│  ═══════════════════════                                                    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  grievancesRef.on('value') fires                                    │   │
│  │                                                                     │   │
│  │  renderGrievances() called                                          │   │
│  │                                                                     │   │
│  │  Grievance appears in Concerns tab:                                 │   │
│  │  ┌──────────────────────────────────────────────┐                   │   │
│  │  │  🚩  [URGENT if high/urgent]                 │                   │   │
│  │  │  Mountain Double · Portal                    │                   │   │
│  │  │  Water Issue                                 │                   │   │
│  │  │  "Hot water not working"                     │                   │   │
│  │  │  Just now              open                  │                   │   │
│  │  │  [Acknowledge]  [Resolve]                    │                   │   │
│  │  └──────────────────────────────────────────────┘                   │   │
│  │                                                                     │   │
│  │  Grievance dot appears on Concerns nav icon                         │   │
│  │                                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│           │                                                                 │
│           ▼                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  STAFF ACTIONS                                                      │   │
│  │                                                                     │   │
│  │  Option A: Acknowledge                                              │   │
│  │  ─────────────────                                                  │   │
│  │  • Staff taps "Acknowledge"                                         │   │
│  │  • db.ref('grievances/{key}').update({                              │   │
│  │      status: "acknowledged",                                        │   │
│  │      acknowledgedBy: "Meena",                                       │   │
│  │      acknowledgedAt: now                                            │   │
│  │    })                                                               │   │
│  │  • Toast: "Grievance acknowledged"                                  │   │
│  │  • Log entry added                                                  │   │
│  │                                                                     │   │
│  │  Option B: Resolve directly                                         │   │
│  │  ─────────────────────                                              │   │
│  │  • Staff taps "Resolve"                                             │   │
│  │  • db.ref('grievances/{key}').update({                              │   │
│  │      status: "resolved",                                            │   │
│  │      resolvedBy: "Meena",                                           │   │
│  │      resolvedAt: now                                                │   │
│  │    })                                                               │   │
│  │  • Toast: "Grievance resolved"                                      │   │
│  │  • Log entry added                                                  │   │
│  │                                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│           │                                                                 │
│           ▼                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  GUEST PORTAL UPDATES (real-time)                                   │   │
│  │                                                                     │   │
│  │  updateStayGrievances() called                                      │   │
│  │                                                                     │   │
│  │  "Your Stay" tab shows:                                             │   │
│  │  ┌──────────────────────────────────────────────┐                   │   │
│  │  │ Acknowledged                                 │                   │   │
│  │  │ Water Issue                                  │                   │   │
│  │  │ "Hot water not working"                      │                   │   │
│  │  │ 5 Jun                                        │                   │   │
│  │  └──────────────────────────────────────────────┘                   │   │
│  │                                                                     │   │
│  │  After resolve:                                                     │   │
│  │  ┌──────────────────────────────────────────────┐                   │   │
│  │  │ Resolved                                     │                   │   │
│  │  │ Water Issue                                  │                   │   │
│  │  │ "Hot water not working"                      │                   │   │
│  │  │ 5 Jun                                        │                   │   │
│  │  └──────────────────────────────────────────────┘                   │   │
│  │                                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Staff App — Tab Decision Trees

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        STAFF APP TAB DECISION TREES                         │
│                                                                             │
│                                                                             │
│  QUEUE TAB                                                                  │
│  ═══════════                                                                │
│                                                                             │
│  [Staff opens Queue tab]                                                    │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Any pending       │                                                      │
│  │ orders?           │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│      ┌────┴────┐                                                             │
│      ▼         ▼                                                             │
│    Yes         No                                                             │
│    /            \                                                            │
│   ▼              ▼                                                           │
│ ┌──────────┐  ┌──────────────────┐                                          │
│ │ Render   │  │ "No orders yet.  │                                          │
│ │ order    │  │  The ridge is    │                                          │
│ │ cards:   │  │  quiet."         │                                          │
│ │          │  └──────────────────┘                                          │
│ │ • Room   │                                                                │
│ │ • Items  │                                                                │
│ │ • Notes  │                                                                │
│ │ • Time   │                                                                │
│ │ • [Done] │                                                                │
│ │ • [Cancel│                                                                │
│ └────┬─────┘                                                                │
│      │                                                                      │
│      ▼                                                                      │
│  [Staff taps Done]                                                          │
│      │                                                                      │
│      ▼                                                                      │
│  ┌───────────────────┐                                                      │
│  │ Modal:            │                                                      │
│  │ "Mark as done?"   │                                                      │
│  │ [Go back] [Done]  │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Update Firebase:  │                                                      │
│  │ status: "done"    │                                                      │
│  │ updatedAt: now    │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Log entry:        │                                                      │
│  │ "Order done"      │                                                      │
│  │ Toast: "Done"     │                                                      │
│  └───────────────────┘                                                      │
│                                                                             │
│                                                                             │
│  NUDGE TAB                                                                  │
│  ═══════════                                                                │
│                                                                             │
│  [Staff opens Nudge tab]                                                    │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Two sections:     │                                                      │
│  │                   │                                                      │
│  │ 1. Guest requests │                                                      │
│  │    (from portal)  │                                                      │
│  │                   │                                                      │
│  │ 2. Staff flags    │                                                      │
│  │    (initiated     │                                                      │
│  │     by staff)     │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│      ┌────┴────┐                                                             │
│      ▼         ▼                                                             │
│  Guest      Staff                                                             │
│  requests   flags                                                             │
│      │         │                                                             │
│      ▼         ▼                                                             │
│  ┌──────────┐ ┌──────────────────┐                                          │
│  │ One-tap  │ │ Select type:     │                                          │
│  │ cards:   │ │ • Maintenance    │                                          │
│  │ • Blanket│ │ • Guest concern  │                                          │
│  │ • Towels │ │ • Low stock      │                                          │
│  │ • Water  │ │ • Safety         │                                          │
│  │ • Clean  │ │                  │                                          │
│  │ • Firepit│ │ Write message    │                                          │
│  │ • Tea    │ │                  │                                          │
│  │          │ │ [Flag it]        │                                          │
│  └────┬─────┘ └────────┬─────────┘                                          │
│       │                │                                                    │
│       ▼                ▼                                                    │
│  ┌──────────────────────────────────┐                                       │
│  │ Write to /nudges/                │                                       │
│  │ status: "sent"                   │                                       │
│  │ Toast: "[Type] noted"            │                                       │
│  │ Card shows "sent" animation      │                                       │
│  └──────────────────────────────────┘                                       │
│                                                                             │
│                                                                             │
│  ME TAB — QR GENERATOR                                                      │
│  ═══════════════════════                                                    │
│                                                                             │
│  [Staff opens Me tab]                                                       │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Staff profile     │                                                      │
│  │ • Name, role      │                                                      │
│  │ • Property info   │                                                      │
│  │ • WhatsApp contacts│                                                     │
│  │ • QR generator    │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  [Staff enters guest name + room]                                            │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Tap "Generate     │                                                      │
│  │ Access Code"      │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ generateToken()   │                                                      │
│  │ → 6-char code     │                                                      │
│  │ → e.g., ABX72K    │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Write to Firebase │                                                      │
│  │ /guest_access/    │                                                      │
│  │ ABX72K            │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Display:          │                                                      │
│  │ • Code: ABX72K    │                                                      │
│  │ • QR code         │                                                      │
│  │ • Portal link     │                                                      │
│  │                   │                                                      │
│  │ [Share via WA]    │                                                      │
│  │ [Copy link]       │                                                      │
│  │ [New guest]       │                                                      │
│  └───────────────────┘                                                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Website Booking Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        WEBSITE BOOKING FLOW                                 │
│                                                                             │
│                                                                             │
│  [Guest scrolls to "Book Your Stay" section]                                │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │  Four channels:       │                                      │
│              │                       │                                      │
│              │  1. WhatsApp          │                                      │
│              │  2. Instagram         │                                      │
│              │  3. Booking.com       │                                      │
│              │  4. Email             │                                      │
│              └───────────┬───────────┘                                      │
│                          │                                                  │
│                    Chooses channel                                          │
│                    /       |       \                                        │
│                  WA       IG      Booking.com/Email                         │
│                  /          |          \                                    │
│                 ▼           ▼           ▼                                   │
│    ┌────────────────┐ ┌──────────┐ ┌────────────────┐                      │
│    │ Opens WA chat  │ │ Opens IG │ │ Opens external │                      │
│    │ with property  │ │ profile  │ │ site           │                      │
│    │ number         │ │          │ │                │                      │
│    └────────────────┘ └──────────┘ └────────────────┘                      │
│                                                                             │
│  ─── OR ───                                                                 │
│                                                                             │
│  [Guest uses Quick WhatsApp Enquiry form]                                   │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │  Fill in:             │                                      │
│              │  • Check-in date      │                                      │
│              │  • Check-out date     │                                      │
│              │  • Room type          │                                      │
│              │  • No. of guests      │                                      │
│              │  • Name               │                                      │
│              │  • Note (optional)    │                                      │
│              └───────────┬───────────┘                                      │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │  Live message preview │                                      │
│              │  updates as you type  │                                      │
│              └───────────┬───────────┘                                      │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │  Tap "Send to         │                                      │
│              │  WhatsApp"            │                                      │
│              └───────────┬───────────┘                                      │
│                          │                                                  │
│                          ▼                                                  │
│              ┌───────────────────────┐                                      │
│              │  Opens WhatsApp with  │                                      │
│              │  pre-filled message:  │                                      │
│              │                       │                                      │
│              │  "Hi — I'd like to    │                                      │
│              │  enquire about        │                                      │
│              │  staying at Stars &   │                                      │
│              │  Pines.               │                                      │
│              │                       │                                      │
│              │  Name: Priya          │                                      │
│              │  Check-in: 5 June     │                                      │
│              │  Check-out: 8 June    │                                      │
│              │  Room: Mountain Double│                                      │
│              │  Guests: 2            │                                      │
│              │                       │                                      │
│              │  Looking forward to   │                                      │
│              │  hearing from you."   │                                      │
│              └───────────────────────┘                                      │
│                                                                             │
│  TRACKING (background)                                                      │
│  ═══════════════════════                                                    │
│                                                                             │
│  • track('whatsapp_click') — when WA link tapped                            │
│  • track('instagram_click') — when IG link tapped                           │
│  • track('booking_click') — when Booking.com link tapped                    │
│  • track('email_click') — when email link tapped                            │
│  • track('whatsapp_form_send') — when form submitted                        │
│  • track('scroll_depth') — at 25%, 50%, 75%, 100%                           │
│  • track('section_view') — when each section enters viewport                │
│  • track('easter_egg_*') — when easter eggs discovered                      │
│                                                                             │
│  All events written to Firebase /events/                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Error Handling Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ERROR HANDLING FLOW                                  │
│                                                                             │
│                                                                             │
│  FIREBASE WRITE FAILS                                                       │
│  ═══════════════════════                                                    │
│                                                                             │
│  db.ref('orders').push(data)                                                │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ .then()           │  .catch()                                            │
│  │ Success path      │  Error path                                          │
│  │                   │                                                      │
│  │ • Cart cleared    │  • Toast:                                            │
│  │ • Menu reset      │    "Could not send                                   │
│  │ • Toast:          │     order. Please                                    │
│  │   "Order sent"    │     try again."                                      │
│  │                   │  • Cart preserved                                    │
│  │                   │  • Guest can retry                                   │
│  └───────────────────┘                                                      │
│                                                                             │
│                                                                             │
│  TOKEN VALIDATION FAILS                                                     │
│  ═══════════════════════                                                    │
│                                                                             │
│  validateToken(token)                                                       │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Checks:           │                                                      │
│  │                   │                                                      │
│  │ 1. Data exists?   │── No ──► "That code doesn't match                    │
│  │                   │            our records. Check with                    │
│  │ 2. active ===     │── No ──►  the desk."                                 │
│  │    true?          │                                                      │
│  │                   │                                                      │
│  │ 3. validUntil     │── No ──► "This access code is                        │
│  │    not passed?    │            no longer valid."                          │
│  │                   │                                                      │
│  │ All pass?         │── Yes ──► Enter portal                               │
│  └───────────────────┘                                                      │
│                                                                             │
│                                                                             │
│  OFFLINE DETECTED                                                           │
│  ═══════════════════════                                                    │
│                                                                             │
│  navigator.onLine === false                                                 │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Banner:           │                                                      │
│  │ "Offline —        │                                                      │
│  │  changes will     │                                                      │
│  │  sync"            │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  [Staff marks order done]                                                    │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ queueWrite()      │                                                      │
│  │ adds to           │                                                      │
│  │ pendingWrites     │                                                      │
│  │                   │                                                      │
│  │ UI updates        │                                                      │
│  │ immediately       │                                                      │
│  │ (optimistic)      │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  navigator.onLine === true                                                   │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ Banner:           │                                                      │
│  │ "Back online —    │                                                      │
│  │  syncing..."      │                                                      │
│  └────────┬──────────┘                                                      │
│           │                                                                  │
│           ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ flushQueue()      │                                                      │
│  │ writes all        │                                                      │
│  │ pending to        │                                                      │
│  │ Firebase          │                                                      │
│  │                   │                                                      │
│  │ Banner:           │                                                      │
│  │ "All changes      │                                                      │
│  │  synced"          │                                                      │
│  └───────────────────┘                                                      │
│                                                                             │
│                                                                             │
│  QR CODE GENERATION FAILS                                                   │
│  ═══════════════════════                                                    │
│                                                                             │
│  db.ref('guest_access/' + code).set(data)                                   │
│          │                                                                  │
│          ▼                                                                  │
│  ┌───────────────────┐                                                      │
│  │ .then()           │  .catch()                                            │
│  │ Success path      │  Error path                                          │
│  │                   │                                                      │
│  │ • QR displayed    │  • Toast:                                            │
│  │ • Code shown      │    "Could not save                                   │
│  │ • Link ready      │     code. Check                                      │
│  │                   │     connection."                                     │
│  └───────────────────┘                                                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```
