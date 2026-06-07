# Stars & Pines — Digital Operations System

A complete guest-to-staff operations system for Stars & Pines, Crank's Ridge, Kasar Devi, Almora.

---

## Documentation

| Document | Purpose |
|---|---|
| **[Operations Handbook](OPERATIONS-HANDBOOK.md)** | Complete operations manual — setup, daily use, troubleshooting, recovery |
| [Audit Report](AUDIT-REPORT.md) | Production readiness audit and revision notes |
| [Deliverables](DELIVERABLES.md) | System deliverables and architecture overview |
| [Firebase Schema](firebase-schema.md) | Firebase database path inventory |
| [Integration Audit](integration-audit.md) | System integration audit findings |

**Start here:** [Operations Handbook →](OPERATIONS-HANDBOOK.md)

---

## System Overview

Five connected web applications running from a single Lubuntu laptop:

| Application | URL Path | Purpose |
|---|---|---|
| Public Website | `/` | Property information and booking enquiries |
| Guest Portal | `/portal` | Guest self-service (orders, requests, concerns) |
| Ridgeline | `/staff` | Staff operations (order dispatch, guest check-in) |
| Dashboard | `/dashboard` | Operations management (live monitoring, inventory, tasks) |
| Guest Entry | `/entry` | Guest access code and QR code generation |

All applications communicate through Firebase Realtime Database.

---

## Quick Reference

- **Laptop OS:** Lubuntu (Linux)
- **Web Server:** Nginx
- **Database:** Firebase Realtime Database (cloud)
- **Deployment:** Single laptop, on-premise
- **Network:** Local WiFi (optional internet access via Cloudflare Tunnel)

---

## Repository Contents

### Application Files
- `index.html` — Public website
- `guest-portal.html` — Guest Portal
- `ridge-bell-staff-app.html` — Ridgeline (Staff App)
- `stars-and-pines-dashboard.html` — Operations Dashboard
- `guest-entry.html` — Guest Entry
- `js/firebase-config.js` — Shared Firebase configuration

### Configuration
- `firebase.json` — Firebase Hosting configuration
- `database.rules.json` — Firebase Realtime Database security rules

### Documentation
- `OPERATIONS-HANDBOOK.md` — Complete operations manual
- `AUDIT-REPORT.md` — Production readiness audit
- `DELIVERABLES.md` — System deliverables
- `firebase-schema.md` — Database schema
- `integration-audit.md` — Integration audit

### Development Tools (not for production)
- `seed-data.html` — Database seeding utility
- `seed-token.html` — Test token generator

---

## Deployment

See the [Operations Handbook](OPERATIONS-HANDBOOK.md) for complete deployment instructions.

Quick deploy:
```bash
sudo apt install -y nginx
sudo mkdir -p /var/www/stars-pines/js
# Copy application files to /var/www/stars-pines/
# Configure Nginx (see handbook Section 4.4)
sudo systemctl enable nginx && sudo systemctl start nginx
```

---

**Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601**
