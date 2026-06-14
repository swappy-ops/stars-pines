# Stars & Pines — Digital Operations System

A complete guest-to-staff operations system for Stars & Pines, Crank's Ridge, Kasar Devi, Almora.

---

## Quick Start

```bash
git clone https://github.com/swappy-ops/stars-pines.git
cd stars-pines
bash setup.sh
```

The `setup.sh` script detects your OS, installs dependencies, configures Nginx (or falls back to Python), and starts serving.

---

## Documentation

All documentation lives in `docs/`:

| Document | Purpose |
|---|---|
| **[Operations Handbook](docs/OPERATIONS-HANDBOOK.md)** | Complete operations manual — setup, daily use, troubleshooting, recovery |
| [Migration Guide](docs/MIGRATION-GUIDE.md) | v1 → v2 migration: local-first architecture, new user flows |
| [Implementation Report](docs/IMPLEMENTATION-REPORT.md) | What was built, what changed |
| [Audit Report](docs/AUDIT-REPORT.md) | Production readiness audit |
| [Deliverables](docs/DELIVERABLES.md) | System deliverables and architecture |
| [Firebase Schema](docs/firebase-schema.md) | Database path inventory |
| [Architecture](docs/ARCHITECTURE.md) | System architecture diagrams |

**Start here:** [Operations Handbook →](docs/OPERATIONS-HANDBOOK.md)

---

## System Overview

Five connected web applications running from a single laptop:

| Application | URL Path | File | Purpose |
|---|---|---|---|
| Public Website | `/` | `index.html` | Property information and booking enquiries |
| Guest Portal | `/portal` | `guest-portal.html` | Guest self-service (orders, requests, bill, checkout) |
| Employee App | `/staff` | `employee-app.html` | Staff operations (bookings, orders, payments) |
| Dashboard | `/dashboard` | `dashboard.html` | Operations management (monitoring, inventory, tasks) |
| Guest Entry | `/entry` | `guest-entry.html` | Guest access code and QR code generation |

All applications communicate through Firebase Realtime Database.

---

## Quick Reference

- **Database:** Firebase Realtime Database (cloud)
- **Deployment:** Single laptop, on-premise
- **Network:** Local WiFi (optional internet via Cloudflare Tunnel)
- **Firebase Project:** `stars-and-pines-ridge`

---

## Repository Structure

```
stars-pines/
├── index.html                  # Public website
├── guest-portal.html           # Guest Portal
├── employee-app.html           # Employee App (staff)
├── dashboard.html              # Operations Dashboard
├── guest-entry.html            # Guest Entry (QR codes)
├── firebase.json               # Firebase Hosting config
├── database.rules.json         # RTDB security rules
├── deploy-v2.sh                # Deployment script
├── setup.sh                    # Auto-setup script (detects OS)
│
├── js/
│   ├── firebase-config.js      # Shared Firebase configuration
│   ├── shared-utils.js         # Shared utilities
│   ├── local-db.js             # IndexedDB local storage
│   ├── sync-engine.js          # Offline-first sync engine
│   └── payment-engine.js       # Razorpay + QR payment engine
│
├── archive/                    # Previous versions (not served)
│   ├── ridge-bell-staff-app.html
│   ├── stars-and-pines-dashboard.html
│   ├── stars-and-pines-v3.html
│   ├── stars-and-pines-v3.5(1).html
│   ├── stars-and-pines-v5.html
│   └── v4/index.html
│
├── docs/                       # All documentation
│   ├── OPERATIONS-HANDBOOK.md
│   ├── MIGRATION-GUIDE.md
│   ├── IMPLEMENTATION-REPORT.md
│   └── ... (14 documents total)
│
└── dev/                        # Development tools (not for production)
    ├── seed-data.html
    ├── seed-token.html
    └── color-swatches.html
```

---

## Deployment

### Libretto (23.6") — Recommended Setup

```bash
# 1. Clone onto the Libretto
git clone https://github.com/swappy-ops/stars-pines.git ~/stars-pines

# 2. Run the full provisioning installer
cd ~/stars-pines
sudo ./install-stars-pines.sh

# 3. Reboot to apply hostname change
sudo reboot
```

After reboot, Firefox opens automatically to the Operations Dashboard.

### Auto-setup (any machine)
```bash
bash setup.sh
```

### Manual deployment (Lubuntu laptop)
```bash
sudo apt install -y nginx
sudo mkdir -p /var/www/starsandpines/js
cp index.html guest-portal.html employee-app.html dashboard.html guest-entry.html /var/www/starsandpines/
cp js/*.js /var/www/starsandpines/js/
cp firebase.json database.rules.json /var/www/starsandpines/
sudo ln -sf /etc/nginx/sites-available/starsandpines /etc/nginx/sites-enabled/starsandpines
sudo nginx -t && sudo systemctl enable nginx && sudo systemctl start nginx
```

### Deploy to Firebase Hosting
```bash
firebase deploy --only hosting
```

---

## Libretto 23.6" Notes

- **Display:** 1920x1080 — wallpaper spec targets this resolution
- **User:** Log in as Reception (default operator account)
- **Auto-start:** Firefox opens to `http://localhost/dashboard` on login
- **Web server:** Nginx runs on port 80, auto-starts on boot
- **Backup:** Runs daily at 3am, stored in `~/StarsAndPines/Backups/`
- **Storage:** `~/StarsAndPines/` is on the 234GB SSD — plenty of room for guests, reports, media
- **To add a wallpaper:** Download from `provision/branding/wallpaper-spec.md`, place in `~/StarsAndPines/Media/wallpapers/`, set via MX Linux settings

---

## Quick Reference

| App | URL |
|---|---|
| Operations Dashboard | http://localhost/dashboard |
| Guest Portal | http://localhost/portal |
| Staff App | http://localhost/staff |
| Guest Check-In | http://localhost/entry |
| Public Website | http://localhost/ |

| Script | Purpose |
|---|---|
| `install-stars-pines.sh` | Full workstation provisioning (run once, as sudo) |
| `setup.sh` | Start local dev server (run each session) |
| `~/StarsAndPines/Scripts/guest-checkin.sh` | Guest check-in + WhatsApp invite |
| `/usr/local/bin/starsandpines-backup.sh` | Manual backup (runs auto daily) |

---

**Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601**
