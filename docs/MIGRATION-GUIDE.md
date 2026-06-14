# Stars & Pines v2 — Migration Guide

**Date:** 2026-06-13
**From:** v1 (Firebase-only) → **To:** v2 (Local-first + Firebase sync)

---

## What Changed

### New Files
| File | Purpose |
|---|---|
| `employee-app.html` | Replaces `ridge-bell-staff-app.html` — booking creation, guest management, WhatsApp onboarding, payments |
| `dashboard.html` | Replaces `stars-and-pines-dashboard.html` — expanded with arrivals, departures, financial overview, outstanding payments |
| `js/local-db.js` | IndexedDB wrapper — local operational database |
| `js/sync-engine.js` | Sync engine — local-first writes, Firebase sync, retry queue |
| `js/payment-engine.js` | Payment engine — Razorpay, QR, pay-later, financial summaries |
| `js/shared-utils.js` | Shared utilities — ID generation, formatting, modals, toasts |

### Modified Files
| File | Changes |
|---|---|
| `guest-portal.html` | Redesigned — dual-factor access (code + phone), running bill, payment center, checkout flow |
| `index.html` | WhatsApp number updated to `917982523582` |
| `js/firebase-config.js` | WhatsApp number updated |
| `database.rules.json` | New paths: `guests`, `bookings`, `payments`, `service_requests`, `checkout_records`, `sync_status` |
| `firebase.json` | Rewrites updated: `/staff` → `employee-app.html`, `/dashboard` → `dashboard.html` |

### Preserved (Backward Compatible)
| File | Status |
|---|---|
| `index.html` | Unchanged functionality |
| `guest-entry.html` | Preserved for backward compatibility |
| `ridge-bell-staff-app.html` | Still on disk, not served (replaced by employee-app.html) |
| `stars-and-pines-dashboard.html` | Still on disk, not served (replaced by dashboard.html) |
| `/guest_access/` Firebase path | Still written to for backward compatibility |
| `/orders/`, `/nudges/`, `/grievances/`, `/experiences/`, `/concierge/` | All preserved |

---

## Deployment

### Option A: Run deploy script on the machine
```bash
ssh starsandpines@10.190.238.183
bash ~/Downloads/stars-pines-extracted/stars-pines-main/deploy-v2.sh
```

### Option B: Deploy from manny machine
```bash
# When remote is reachable:
sshpass -p 'raman' scp -o StrictHostKeyChecking=no \
  ~/Downloads/stars-pines-extracted/stars-pines-main/employee-app.html \
  ~/Downloads/stars-pines-extracted/stars-pines-main/guest-portal.html \
  ~/Downloads/stars-pines-extracted/stars-pines-main/dashboard.html \
  ~/Downloads/stars-pines-extracted/stars-pines-main/index.html \
  ~/Downloads/stars-pines-extracted/stars-pines-main/guest-entry.html \
  ~/Downloads/stars-pines-extracted/stars-pines-main/firebase.json \
  ~/Downloads/stars-pines-extracted/stars-pines-main/database.rules.json \
  starsandpines@10.190.238.183:~/Downloads/stars-pines-main/

sshpass -p 'raman' scp -o StrictHostKeyChecking=no \
  ~/Downloads/stars-pines-extracted/stars-pines-main/js/firebase-config.js \
  ~/Downloads/stars-pines-extracted/stars-pines-main/js/shared-utils.js \
  ~/Downloads/stars-pines-extracted/stars-pines-main/js/local-db.js \
  ~/Downloads/stars-pines-extracted/stars-pines-main/js/sync-engine.js \
  ~/Downloads/stars-pines-extracted/stars-pines-main/js/payment-engine.js \
  starsandpines@10.190.238.183:~/Downloads/stars-pines-main/js/

sshpass -p 'raman' ssh starsandpines@10.190.238.183 'bash ~/Downloads/stars-pines-extracted/stars-pines-main/deploy-v2.sh'
```

---

## New User Flows

### Employee App (`/staff`)
1. **Login** — Tap name (Mona/Harsh)
2. **New Booking** — Enter guest details → generates access code → saves locally → syncs to Firebase
3. **WhatsApp Onboarding** — Tap "Send WhatsApp Link" → opens WhatsApp with pre-filled message containing portal URL + access code
4. **Order Queue** — See pending orders, mark done/cancel
5. **Payments** — View financial summary, outstanding payments, confirm QR payments
6. **Grievances** — Acknowledge and resolve

### Guest Portal (`/portal`)
1. **Access** — Enter access code + last 4 digits of phone (dual-factor)
2. **My Booking** — View booking details, room, dates, deposit status
3. **Running Bill** — Real-time calculation of room + food - deposits
4. **Food Orders** — Browse menu, add to cart, send to kitchen
5. **Service Requests** — House requests, experiences, concierge
6. **Notifications** — View alerts and announcements
7. **Grievances** — Submit concerns, track status
8. **Payment Center** — Pay via Razorpay, QR code, or Pay Later
9. **Checkout** — Request checkout, view invoice, settle balance

### Dashboard (`/dashboard`)
1. **Overview** — Heartbeat bar, stats, live feed, open grievances
2. **Arrivals** — Today's check-ins
3. **In-House** — Current guests with outstanding balances
4. **Departures** — Today's check-outs with checkout action
5. **Outstanding** — Unpaid balances, pay-later records
6. **Grievances** — All grievances sorted by severity
7. **Service Requests** — Nudges, experiences, concierge
8. **Activity Feed** — Real-time activity log
9. **Financial** — Revenue today/month, outstanding, deposits, payment history

---

## Offline Behavior

When internet is unavailable:
- **Employee App:** Booking creation, order management, payment recording all work locally. Changes queue for sync.
- **Guest Portal:** If already loaded, food ordering and requests queue locally. New access requires internet (Firebase validation).
- **Dashboard:** Shows cached data. Sync status indicator shows "Offline".

When internet returns:
- Sync engine automatically processes queue (payments → bookings → orders → notifications)
- All apps update in real-time
- Sync badge turns green

---

## Firebase Schema Additions

New paths (in addition to existing):

| Path | Purpose |
|---|---|
| `/guests/{guestId}` | Guest master records |
| `/bookings/{bookingId}` | Booking records with payment info |
| `/payments/{paymentId}` | Payment transactions |
| `/service_requests/{requestId}` | Unified service requests |
| `/checkout_records/{checkoutId}` | Completed checkouts |
| `/sync_status/{deviceId}` | Device sync status |

---

## Razorpay Setup

1. Create Razorpay account at https://dashboard.razorpay.com
2. Get API keys from Settings → API Keys
3. Replace `REPLACE_WITH_RAZORPAY_KEY_ID` in:
   - `js/payment-engine.js` (line ~14)
   - `guest-portal.html` (search for `REPLACE_WITH_RAZORPAY_KEY_ID`)
   - `employee-app.html` (if Razorpay used there)

---

## QR Payment Setup

1. Generate UPI QR code for Stars & Pines bank account
2. Replace the placeholder in `guest-portal.html` (search for `qr-placeholder`)
3. Staff confirms payment received via Employee App

---

## Rollback

If issues arise, revert to v1:

```bash
ssh starsandpines@10.190.238.183
# Restore nginx rewrites to v1 files
sudo sed -i 's|employee-app.html|ridge-bell-staff-app.html|' /etc/nginx/sites-available/stars-pines
sudo sed -i 's|dashboard.html|stars-and-pines-dashboard.html|' /etc/nginx/sites-available/stars-pines
sudo service nginx reload
```

---

**Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601**
