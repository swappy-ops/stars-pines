# Stars & Pines Operations Handbook

**Version 1.0 — June 2026**

---

## Document Control

| Item | Detail |
|---|---|
| **System** | Stars & Pines Digital Operations System |
| **Version** | 1.0 |
| **Date** | June 2026 |
| **Deployment** | Single Lubuntu laptop, on-premise |
| **Database** | Firebase Realtime Database (cloud) |
| **Property** | Stars & Pines, Crank's Ridge, Kasar Devi, Almora, Uttarakhand 263601 |

### Version History

| Version | Date | Changes |
|---|---|---|
| 1.0 | June 2026 | Initial release — complete operations handbook |

### Intended Audience

This handbook is written for:

- Property owners and managers
- Operations staff and team leads
- Future technical operators
- Anyone responsible for running the Stars & Pines digital system

No technical background is required to operate the system day-to-day. Technical procedures include step-by-step instructions.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [The Five Applications](#2-the-five-applications)
3. [Hardware & Infrastructure](#3-hardware--infrastructure)
4. [Deployment & Setup](#4-deployment--setup)
5. [Network Configuration](#5-network-configuration)
6. [Daily Operations](#6-daily-operations)
7. [Guest Check-In & Check-Out](#7-guest-check-in--check-out)
8. [Security & Access Control](#8-security--access-control)
9. [Data Retention & Privacy](#9-data-retention--privacy)
10. [Reliability & Recovery](#10-reliability--recovery)
11. [Cache & Update Behavior](#11-cache--update-behavior)
12. [Troubleshooting](#12-troubleshooting)
13. [Frequently Asked Questions](#13-frequently-asked-questions)
14. [Full System Recovery](#14-full-system-recovery)
15. [Backup & Restore](#15-backup--restore)
16. [Checklists](#16-checklists)
17. [Quick Reference Card](#17-quick-reference-card)

---

## 1. System Overview

### What This System Does

Stars & Pines operates a digital guest experience system that replaces paper menus, walkie-talkie requests, and front-desk coordination with five connected web applications. Guests use their own phones. Staff use their own phones. Everything runs from a single laptop on the property.

### How It Works

```
Guest scans QR code or enters 6-digit access code
         │
         ▼
┌─────────────────────┐
│   Guest Portal      │  ← Orders food, makes requests, raises concerns
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐     ┌─────────────────────┐
│   Firebase Cloud    │◄───►│   Ridgeline         │
│   Realtime DB       │     │   (Staff App)       │
└─────────┬───────────┘     └─────────────────────┘
          │
          ▼
┌─────────────────────┐
│   Operations        │  ← Live view of everything happening on property
│   Dashboard         │
└─────────────────────┘
```

All applications communicate through Firebase Realtime Database, a cloud service by Google. When a guest places an order, it appears on the staff app and dashboard within seconds. When staff marks an order complete, the guest sees the update immediately.

### What Runs Where

| Component | Location | Purpose |
|---|---|---|
| Web applications (5) | Lubuntu laptop | Served to all devices via local network |
| Real-time database | Google Firebase (cloud) | Stores orders, guests, requests, grievances |
| Laptop | On-premise, plugged in | Runs 24/7, serves all web applications |

### What This System Replaces

| Before | After |
|---|---|
| Paper menus | Digital menu in Guest Portal |
| Walkie-talkie requests | One-tap house requests |
| Verbal order taking | Guest orders directly from phone |
| Paper grievance log | Digital concern tracking with status |
| Memory-based task management | Digital task list with assignments |
| Manual occupancy tracking | Live occupancy dashboard |

---

## 2. The Five Applications

### 2.1 Public Website

**Access:** `http://[laptop-address]/`

**Purpose:** The public-facing website for Stars & Pines. Used by prospective guests to learn about the property, view rooms, read the Kasar Devi guide, and make booking enquiries.

**Features:**
- Property story and philosophy
- Room descriptions and pricing
- Kasar Devi area guide (temples, trails, cafes, sunrise points)
- Guest reviews
- Booking enquiry via WhatsApp

**Who uses it:** Anyone with the link. No access code required.

---

### 2.2 Guest Portal

**Access:** `http://[laptop-address]/portal`

**Purpose:** The self-service portal for checked-in guests. Accessed using a 6-digit code provided at check-in.

**Features:**
- **Food & Drink** — Browse menu, add items to cart, place orders, track order status
- **House Requests** — One-tap requests for blankets, towels, water refill, room cleaning, firepit setup, tea to room
- **Concerns** — Submit grievances with type selection, urgency level, and message. Track resolution status.
- **Ridge Guide** — Local area guide with bookmarkable entries
- **Experiences** — Request bonfire, local guide, photography session, village walk, bird watching, stargazing, transportation, special meals
- **Concierge** — Request extra blankets, room cleaning, hot water, laundry, taxi, wake-up call, medical assistance, luggage help
- **Your Stay** — Personal dashboard showing room info, active orders, order history, requests, concerns, and experiences

**Who uses it:** Checked-in guests only. Requires a valid 6-digit access code.

---

### 2.3 Ridgeline (Staff App)

**Access:** `http://[laptop-address]/staff`

**Purpose:** The staff operations application. Used by team members to receive orders, manage requests, resolve concerns, and generate guest access codes.

**Features:**
- **Queue** — Live list of pending orders. Shows room, items, time elapsed, and guest notes. Staff can mark orders as done or cancelled.
- **Order** — Staff can place orders on behalf of guests. Select room, choose items, send to kitchen.
- **Nudge** — View all guest house requests. Staff can also flag maintenance issues, low stock, or safety concerns.
- **Concerns** — View guest grievances with priority indicators. Acknowledge and resolve workflow.
- **Log** — Complete activity history for the day. All orders, requests, and concerns in one timeline.
- **Me** — Staff profile, guest check-in with QR code generator, property information, WhatsApp contacts.

**Alerts:** When a new order arrives, staff see a banner notification, hear a bell sound, and feel a vibration (on supported devices).

**Who uses it:** All staff members. Each person selects their profile on login.

---

### 2.4 Operations Dashboard

**Access:** `http://[laptop-address]/dashboard`

**Purpose:** The management view of the entire property. Used by managers and supervisors to monitor operations in real time.

**Pages:**

| Page | What It Shows |
|---|---|
| **Overview** | Live heartbeat bar (guest count, available beds, active orders, open grievances, water level, power status, inventory alerts), live activity feed, guest requests panel, occupancy snapshot, today's schedule, open tasks, water tank visual, revenue summary |
| **Occupancy** | Dorm bed grids (occupied/vacant/cleaning), private rooms table, live guest list, check-out controls |
| **Kitchen & Inventory** | Live order queue, inventory by category with stock levels, low stock alerts, restock controls |
| **Menu** | Menu items with availability toggles for each category |
| **Events** | Today's events with registration progress, upcoming events table |
| **Maintenance** | Open tasks with priority, completed tasks, quick task creation |
| **Water** | Tank level, motor status, daily usage history, alert rules |
| **Lighting & Power** | Zone controls, brightness sliders, toggle switches, power summary, scene presets |
| **Music & Ambience** | Now playing display, playlists, speaker zones with volume controls, announcements |
| **Analytics** | Weekly and daily revenue, occupancy rates, order counts, most popular items |

**Who uses it:** Property managers, supervisors, and anyone responsible for overall operations.

---

### 2.5 Guest Entry

**Access:** `http://[laptop-address]/entry`

**Purpose:** The check-in tool used by staff to generate guest access codes and QR codes.

**Features:**
- Guest information form (name, room, check-in/out dates, phone)
- 6-digit access code generation
- QR code display for guest scanning
- WhatsApp sharing of portal link
- Guest registration form (for guests who scan the QR)

**Who uses it:** Front desk staff and anyone responsible for guest check-in.

---

## 3. Hardware & Infrastructure

### 3.1 Server Laptop

The entire system runs from a single laptop running Lubuntu (a lightweight version of Linux).

**Minimum Requirements:**
- Any laptop from 2010 or later
- 2 GB RAM
- 20 GB free disk space
- WiFi or Ethernet connection
- Power adapter (must remain plugged in)

**Recommended:**
- 4 GB RAM
- Solid State Drive (SSD) — faster, quieter, lower power consumption
- Ethernet connection — more reliable than WiFi
- UPS or battery backup — protects against power cuts

**Power Consumption:** Approximately 30–60 watts. Estimated monthly electricity cost: ₹100–200.

### 3.2 What the Laptop Does

- Serves all five web applications to devices on the local network
- Handles all web traffic (HTTP/HTTPS)
- Runs continuously, 24 hours a day
- Uses approximately 50 MB of RAM and 200 MB of disk space for the web server

### 3.3 What Stays in the Cloud

- **Firebase Realtime Database** — stores all operational data (orders, guests, requests, grievances, experiences, concierge requests)
- Hosted by Google on their infrastructure
- Free tier covers the needs of a small property
- Accessible at: https://console.firebase.google.com/project/stars-and-pines-ridge

### 3.4 Network Requirements

- The laptop must be connected to the same network that guests and staff use
- WiFi is sufficient; Ethernet is preferred for reliability
- Internet connection is required for Firebase database communication
- Without internet, the web applications still load but real-time data will not sync

---

## 4. Deployment & Setup

This section covers the initial setup of the Stars & Pines system on a Lubuntu laptop. If the system is already deployed, skip to Section 6 (Daily Operations).

### 4.1 Prepare the Laptop

1. **Install Lubuntu**
   - Download from https://lubuntu.me/downloads/
   - Create a bootable USB drive
   - Boot from USB and follow the installation prompts
   - Create a user account (for example: `starspines`)

2. **Connect to the Network**
   - Connect to the property WiFi via the network icon in the system tray
   - Or connect an Ethernet cable

3. **Update the System**
   Open the terminal (Ctrl + Alt + T) and run:
   ```
   sudo apt update && sudo apt upgrade -y
   ```
   Enter the user password when prompted. This installs the latest system updates.

4. **Install Required Software**
   ```
   sudo apt install -y nginx curl wget
   ```
   This installs Nginx (the web server) and supporting tools.

### 4.2 Prevent the Laptop from Sleeping

The laptop must remain awake at all times.

1. Open **Power Management** from the application menu
2. Set "When laptop lid is closed" to **Do nothing**
3. Set "Turn off screen after" to **Never** (or a preferred time — the screen can turn off, but the system must not sleep)
4. Set "Suspend after" to **Never**

Alternatively, run these commands in the terminal:
```
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

### 4.3 Deploy the Application Files

1. **Create the web directory:**
   ```
   sudo mkdir -p /var/www/stars-pines/js
   ```

2. **Copy the application files** to `/var/www/stars-pines/`. The required files are:

   | File | Purpose |
   |---|---|
   | `index.html` | Public website |
   | `guest-portal.html` | Guest Portal |
   | `ridge-bell-staff-app.html` | Ridgeline (Staff App) |
   | `stars-and-pines-dashboard.html` | Operations Dashboard |
   | `guest-entry.html` | Guest Entry |
   | `js/firebase-config.js` | Firebase configuration |

   Files can be copied from a USB drive, downloaded from the project repository, or transferred over the network.

3. **Set correct permissions:**
   ```
   sudo chown -R www-data:www-data /var/www/stars-pines
   sudo chmod -R 755 /var/www/stars-pines
   ```

### 4.4 Configure the Web Server

1. **Create the site configuration:**
   ```
   sudo nano /etc/nginx/sites-available/stars-pines
   ```

2. **Paste the following configuration:**
   ```
   server {
       listen 80;
       server_name _;

       root /var/www/stars-pines;
       index index.html;

       location /portal {
           try_files /guest-portal.html =404;
       }

       location /staff {
           try_files /ridge-bell-staff-app.html =404;
       }

       location /dashboard {
           try_files /stars-and-pines-dashboard.html =404;
       }

       location /entry {
           try_files /guest-entry.html =404;
       }

       location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
           expires 30d;
           add_header Cache-Control "public, immutable";
       }

       location ~* \.html$ {
           add_header Cache-Control "no-cache, no-store, must-revalidate";
       }

       gzip on;
       gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
   }
   ```

3. **Save and exit** (Ctrl + O, Enter, Ctrl + X)

4. **Enable the site:**
   ```
   sudo rm -f /etc/nginx/sites-enabled/default
   sudo ln -s /etc/nginx/sites-available/stars-pines /etc/nginx/sites-enabled/
   ```

5. **Test the configuration:**
   ```
   sudo nginx -t
   ```
   Expected output: "syntax is ok" and "test is successful"

6. **Start the web server:**
   ```
   sudo systemctl enable nginx
   sudo systemctl start nginx
   ```

### 4.5 Verify the Deployment

1. Open a web browser on the laptop
2. Visit each URL and confirm it loads:

   | URL | Expected Result |
   |---|---|
   | `http://localhost/` | Stars & Pines public website |
   | `http://localhost/portal` | Guest Portal access code screen |
   | `http://localhost/staff` | Ridgeline staff login screen |
   | `http://localhost/dashboard` | Operations Dashboard |
   | `http://localhost/entry` | Guest Entry QR generator |

3. **Find the laptop's network address:**
   ```
   hostname -I
   ```
   Note the first IP address shown (for example: `192.168.1.100`). This is the address staff and guests will use.

4. **Test from another device** (phone, tablet, or another computer on the same network):
   - Open a browser and visit `http://[laptop-address]/`
   - All five applications should be accessible

### 4.6 Deployment Notes

- **Lubuntu version:** These instructions apply to Lubuntu 22.04 LTS and 24.04 LTS. Earlier versions may have different power management settings.
- **Network configuration:** If the laptop uses NetworkManager (default in Lubuntu), the WiFi connection is managed through the system tray. For static IP configuration, edit the connection settings through the NetworkManager GUI rather than command-line netplan files.
- **Nginx version:** The configuration provided is compatible with Nginx 1.18 and later, which is included in all supported Lubuntu releases.
- **Firewall:** If the Ubuntu firewall (ufw) is enabled, allow HTTP traffic:
  ```
  sudo ufw allow 80/tcp
  ```

---

## 5. Network Configuration

### 5.1 Local Network Access (Default)

The system is designed to work on the property's local network. All devices (staff phones, guest phones, the laptop) must be connected to the same WiFi network.

**To find the laptop's address:**
```
hostname -I
```

Share this address with staff. Guests access the system through QR codes or links that include this address.

### 5.2 Setting a Fixed Address

It is recommended to assign a fixed address to the laptop so it does not change after a reboot or router restart.

**Method 1 — Router DHCP Reservation (Recommended):**
1. Log into the property router (usually `192.168.1.1` or `192.168.0.1`)
2. Find the DHCP or LAN settings section
3. Add a reservation for the laptop's MAC address with a fixed IP (for example: `192.168.1.100`)
4. Save and restart the router

**Method 2 — Laptop Static IP:**
1. Open NetworkManager (click the network icon in the system tray)
2. Select "Edit Connections"
3. Select the active connection (WiFi or Ethernet) and click "Edit"
4. Go to the "IPv4 Settings" tab
5. Change "Method" from "Automatic (DHCP)" to "Manual"
6. Add an address (for example: `192.168.1.100/24`) and gateway (`192.168.1.1`)
7. Set DNS servers to `8.8.8.8, 8.8.4.4`
8. Save and reconnect

### 5.3 Internet Access (Optional)

To make the system accessible from outside the property network:

**Option A — Cloudflare Tunnel (Recommended):**
Cloudflare Tunnel provides secure remote access without opening ports on the router.

1. Create a free Cloudflare account at https://dash.cloudflare.com
2. Install the Cloudflare tunnel agent on the laptop:
   ```
   sudo curl -L -o /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
   sudo chmod +x /usr/local/bin/cloudflared
   ```
3. Authenticate:
   ```
   cloudflared tunnel login
   ```
   This opens a browser window. Log in to Cloudflare and authorize the tunnel.
4. Create a tunnel:
   ```
   cloudflared tunnel create stars-pines
   ```
5. Configure the tunnel by editing `~/.cloudflared/config.yml`:
   ```
   tunnel: [TUNNEL_ID_FROM_STEP_4]
   credentials-file: /home/[USERNAME]/.cloudflared/[TUNNEL_ID].json

   ingress:
     - hostname: [YOUR_DOMAIN]
       service: http://localhost:80
     - service: http_status:404
   ```
6. Route DNS:
   ```
   cloudflared tunnel route dns stars-pines [YOUR_DOMAIN]
   ```
7. Run as a service:
   ```
   sudo cloudflared service install
   sudo systemctl enable cloudflared
   sudo systemctl start cloudflared
   ```

**Option B — Port Forwarding:**
1. Log into the property router
2. Find the Port Forwarding section
3. Forward port 80 to the laptop's IP address
4. Forward port 443 to the laptop's IP address (if using HTTPS)
5. Save the configuration

**Note:** Port forwarding exposes the laptop directly to the internet. A firewall and HTTPS are strongly recommended if using this method.

---

## 6. Daily Operations

### 6.1 Morning Startup (2 minutes)

Each morning, the person responsible for operations should verify the system is running:

1. **Check the laptop is powered on** — the power indicator light should be on. The screen may be off.
2. **Verify the web server is running:**
   ```
   sudo systemctl status nginx
   ```
   Look for "active (running)" in green text.
3. **Verify internet connectivity:**
   ```
   ping -c 3 google.com
   ```
   Three replies should appear. If not, check the network connection.
4. **Test one application** — open `http://localhost/staff` in the laptop's browser to confirm it loads.

### 6.2 During the Day

No routine action is required. The system operates automatically:

- Guest orders appear on Ridgeline and the Dashboard in real time
- Staff order updates are visible to guests immediately
- House requests, grievances, experiences, and concierge requests flow through the system automatically
- The Dashboard provides a live view of all property operations

### 6.3 Evening Review (5 minutes)

Before the end of the day, the manager or supervisor should:

1. **Open the Dashboard** at `http://localhost/dashboard`
2. **Review the Overview page:**
   - Confirm all pending orders have been completed
   - Check for any open grievances that need attention
   - Review guest requests (experiences and concierge)
3. **Check the Kitchen & Inventory page:**
   - Note any low-stock items for tomorrow's procurement
4. **Check the Occupancy page:**
   - Review expected check-outs for the next day
   - Ensure rooms are marked correctly (occupied, vacant, cleaning)

### 6.4 Weekly Maintenance (10 minutes)

Once per week, preferably on a quiet day:

1. **Update the system:**
   ```
   sudo apt update && sudo apt upgrade -y
   ```
2. **Check disk space:**
   ```
   df -h
   ```
   Ensure at least 50% of disk space is free.
3. **Review Nginx error log:**
   ```
   sudo tail -20 /var/log/nginx/error.log
   ```
   If errors appear, note them and consult the Troubleshooting section.
4. **Restart the web server:**
   ```
   sudo systemctl restart nginx
   ```
   This clears any stale connections and applies any configuration changes.

### 6.5 Monthly Maintenance (15 minutes)

Once per month:

1. **Check Firebase usage:**
   - Visit https://console.firebase.google.com/project/stars-and-pines-ridge
   - Review the Realtime Database usage
   - Confirm the account is within the free tier limits
2. **Create a backup** (see Section 15)
3. **Reboot the laptop:**
   ```
   sudo reboot
   ```
   This clears accumulated memory and applies any pending system updates.
4. **Verify the system after reboot** using the Morning Startup checklist (Section 6.1)

---

## 7. Guest Check-In & Check-Out

### 7.1 Check-In Procedure

1. **Open Ridgeline** on a staff phone or the laptop:
   - Phone: `http://[laptop-address]/staff`
   - Laptop: `http://localhost/staff`

2. **Select your profile** by tapping your name on the login screen.

3. **Navigate to the "Me" tab** and find the "Guest Check-In" section.

4. **Enter the guest's information:**
   - Guest name
   - Room type (Six-Bed Dorm, Mountain Double, Deluxe Twin)
   - Check-in date
   - Check-out date
   - Phone number (optional, for WhatsApp sharing)

5. **Tap "Generate Access Code"**
   - A 6-character code is created (for example: `ABX72K`)
   - A QR code is displayed on screen

6. **Share the access with the guest:**
   - **Option A:** Show the QR code — the guest scans it with their phone camera
   - **Option B:** Tap "Share via WhatsApp" — sends the portal link directly
   - **Option C:** Tell the guest their 6-digit code — they enter it manually at `http://[laptop-address]/portal`

7. **The guest opens their portal** and can immediately:
   - Browse the menu and place orders
   - Make house requests
   - View the area guide
   - Request experiences and concierge services

### 7.2 Check-Out Procedure

1. **Open the Dashboard** at `http://localhost/dashboard`

2. **Navigate to the Occupancy page**

3. **Find the guest** in the live guest list

4. **Tap "Check Out"** next to the guest's name

5. **Confirm the check-out** — the guest's access code is deactivated

6. **The guest's portal** will no longer work. Their access code cannot be reused.

### 7.3 Re-activating a Guest Code

If a guest needs access after check-out (for example, they left something behind and need to contact staff):

1. Open Ridgeline
2. Go to the "Me" tab
3. Generate a new access code for the guest
4. Share the new code via WhatsApp

---

## 8. Security & Access Control

### 8.1 Device Access

| Device | Access Level | Responsibility |
|---|---|---|
| Server laptop | Full system access | Property owner or designated manager |
| Staff phones | Ridgeline app only | Individual staff members |
| Guest phones | Guest Portal only (with valid code) | Individual guests |

**Laptop Security:**
- The laptop should be kept in a secure location (office, manager's room, or locked cabinet)
- Physical access to the laptop grants full control over the system
- The laptop user account should have a strong password
- Do not share the laptop password with staff who do not need it

### 8.2 Password Management

| Account | Where | Who Manages |
|---|---|---|
| Lubuntu user account | Laptop login | Property owner or manager |
| Firebase account | https://console.firebase.google.com | Property owner or designated technical contact |
| Cloudflare account (if used) | https://dash.cloudflare.com | Property owner or designated technical contact |
| Router admin | Router web interface | Property owner or network administrator |

**Recommendations:**
- Use strong, unique passwords for each account
- Store passwords in a secure password manager
- Do not write passwords on paper near the laptop
- Change passwords if a staff member leaves the property

### 8.3 Firebase Access Ownership

The Firebase project (`stars-and-pines-ridge`) contains all operational data. Access to this project should be limited to:

- Property owner (owner role)
- Designated technical contact (editor role)

**To manage Firebase access:**
1. Visit https://console.firebase.google.com/project/stars-and-pines-ridge/settings/iam
2. Review the list of users with access
3. Remove any users who no longer need access
4. Add new users only when necessary

### 8.4 Administrative Responsibilities

| Responsibility | Assigned To | Notes |
|---|---|---|
| Laptop physical security | Property owner | Keep laptop secure and powered |
| Firebase account ownership | Property owner | Primary account holder |
| Cloudflare account (if used) | Property owner | Domain and tunnel management |
| Daily system verification | Duty manager | Morning startup checklist |
| Weekly maintenance | Designated staff | System updates and health check |
| Monthly backup | Designated staff | File backup and verification |
| Staff access code generation | Front desk staff | Guest check-in process |
| Guest grievance resolution | Manager | Review and respond to concerns |

### 8.5 What Happens If Credentials Are Compromised

**Laptop password compromised:**
1. Change the laptop password immediately
2. Review any recent changes to the system
3. Check Firebase access logs for unusual activity

**Firebase account compromised:**
1. Change the Firebase account password immediately
2. Enable two-factor authentication on the Google account
3. Review Firebase IAM settings and remove unknown users
4. Review database rules to ensure they have not been modified

**Cloudflare account compromised (if used):**
1. Change the Cloudflare account password immediately
2. Enable two-factor authentication
3. Review DNS settings and tunnel configurations
4. Regenerate tunnel credentials if necessary

---

## 9. Data Retention & Privacy

### 9.1 What Data Is Collected

| Data Type | Where Stored | Purpose |
|---|---|---|
| Guest access codes | Firebase `/guest_access` | Authenticate guests to the portal |
| Food orders | Firebase `/orders` | Process and track guest orders |
| House requests | Firebase `/nudges` | Dispatch staff for guest needs |
| Guest grievances | Firebase `/grievances` | Track and resolve guest concerns |
| Experience requests | Firebase `/experiences` | Manage activity bookings |
| Concierge requests | Firebase `/concierge` | Manage guest service requests |
| Website analytics | Firebase `/events` | Understand website usage |
| Activity log | Firebase `/activity_feed` | System audit trail |

### 9.2 Data Retention Periods

| Data Type | Retention Period | Cleanup Method |
|---|---|---|
| Guest access codes | Duration of stay + 24 hours | Automatically expire; manual deactivation at check-out |
| Food orders | Indefinite (stored in Firebase) | Manual cleanup recommended quarterly |
| House requests | Indefinite (stored in Firebase) | Manual cleanup recommended quarterly |
| Guest grievances | Indefinite (stored in Firebase) | Retain for property records; do not delete |
| Experience requests | Indefinite (stored in Firebase) | Manual cleanup recommended quarterly |
| Concierge requests | Indefinite (stored in Firebase) | Manual cleanup recommended quarterly |
| Website analytics | Indefinite (stored in Firebase) | Low volume; no cleanup needed |
| Activity log | Indefinite (stored in Firebase) | Manual cleanup recommended quarterly |

### 9.3 Recommended Quarterly Cleanup

To prevent unnecessary data accumulation in Firebase:

1. Visit https://console.firebase.google.com/project/stars-and-pines-ridge/database
2. Navigate to the Realtime Database
3. Review the following paths and remove entries older than 90 days:
   - `/orders` — remove completed and cancelled orders older than 90 days
   - `/nudges` — remove fulfilled requests older than 90 days
   - `/experiences` — remove completed requests older than 90 days
   - `/concierge` — remove completed requests older than 90 days
   - `/activity_feed` — remove entries older than 90 days
4. **Do not delete** entries in `/grievances` — these are property records

**Note:** Firebase's free tier provides 1 GB of storage. For a small property, data accumulation is unlikely to approach this limit. Cleanup is recommended as a best practice rather than a necessity.

### 9.4 Guest Privacy

- Guest access codes are single-use and expire after check-out
- Guest data (name, room, phone) is stored only for the duration of their stay
- Orders and requests are associated with the guest's access code, not their personal identity
- No guest data is shared with third parties
- Guests can request deletion of their data by contacting the property manager

---

## 10. Reliability & Recovery

### 10.1 Power Outage

**What happens:** The laptop shuts down. The web server stops. Guests cannot access the portal. Staff cannot use Ridgeline.

**What to do:**
1. When power returns, the laptop should be turned on manually (unless auto-boot is configured in BIOS)
2. The web server (Nginx) is configured to start automatically on boot
3. Verify the system is running using the Morning Startup checklist (Section 6.1)
4. Firebase data is unaffected — it is stored in the cloud

**Expected recovery time:** 2–5 minutes after power is restored.

**Prevention:**
- Configure the laptop BIOS to power on automatically when AC power is restored
- Use a UPS (uninterruptible power supply) for brief outages
- Keep the laptop plugged in at all times

### 10.2 Internet Outage

**What happens:** The web applications continue to load (they are served locally). However, real-time data will not sync with Firebase. New orders placed by guests will not appear on Ridgeline until the internet returns.

**What to do:**
1. The system continues to function for local operations
2. Staff can still use Ridgeline to view previously loaded data
3. When the internet returns, all queued data syncs automatically
4. No data is lost

**Expected recovery time:** Automatic sync within 30 seconds of internet restoration.

### 10.3 Laptop Hardware Failure

**What happens:** The web server is unavailable. No applications are accessible.

**What to do:**
1. Firebase data is safe — it is stored in the cloud
2. Application files can be restored from backup or re-downloaded from the project repository
3. Set up a replacement laptop following the Deployment & Setup section (Section 4)
4. Copy the application files to the new laptop
5. Configure Nginx as described in Section 4.4

**Expected recovery time:** 30–60 minutes depending on hardware availability and internet connectivity.

### 10.4 Firebase Service Disruption

**What happens:** Firebase is a Google service. In the rare event of a Firebase outage, real-time data sync will be unavailable. The web applications will still load but will not display live data.

**What to do:**
1. Check the Firebase status page: https://status.firebase.google.com
2. Operations can continue manually (paper orders, verbal requests) until the service is restored
3. When Firebase returns, all queued data syncs automatically

**Expected recovery time:** Dependent on Google's service restoration. Typically resolved within 1–2 hours.

### 10.5 Device Replacement

If the server laptop needs to be replaced:

1. Obtain a replacement laptop (any laptop meeting the requirements in Section 3.1)
2. Install Lubuntu (Section 4.1)
3. Deploy the application files (Section 4.3)
4. Configure the web server (Section 4.4)
5. Set the network address to match the previous laptop's address (Section 5.2)
6. Verify the deployment (Section 4.5)

All Firebase data is preserved. No data migration is required.

---

## 11. Cache & Update Behavior

### 11.1 What Is Cached

| Resource | Cache Duration | Location |
|---|---|---|
| JavaScript files | 30 days | Browser cache on each device |
| CSS files | 30 days | Browser cache on each device |
| Images and fonts | 30 days | Browser cache on each device |
| HTML pages | Not cached | Always fetched fresh from the server |

### 11.2 After Making Changes

If you update a menu item, fix a bug, or modify any application file:

1. **The change takes effect immediately** for new visitors
2. **Existing visitors** may see the old version due to browser caching of JavaScript and CSS files
3. **To force a refresh** on any device:
   - On a computer: Press Ctrl + Shift + R (or Cmd + Shift + R on Mac)
   - On a phone: Close the browser tab completely and reopen it, or clear the browser cache

### 11.3 Nginx Server Cache

Nginx does not cache HTML pages. Every request for an HTML page is served fresh from the disk. JavaScript, CSS, and image files are served with a 30-day cache header to improve loading speed.

### 11.4 Firebase Data Cache

Firebase Realtime Database maintains its own connection and caching layer. Data is synchronized in real time across all connected devices. There is no manual cache management required for Firebase data.

---

## 12. Troubleshooting

### 12.1 Common Issues

| Problem | Likely Cause | Solution |
|---|---|---|
| "This site can't be reached" | Nginx is not running | Run `sudo systemctl start nginx` |
| Pages load but show "Loading..." | No internet connection | Check WiFi/Ethernet; run `ping -c 3 google.com` |
| 404 error on `/portal` or `/staff` | Nginx configuration issue | Run `sudo nginx -t` to check config; verify files exist in `/var/www/stars-pines/` |
| Guest says portal doesn't work | Guest is on a different network | Confirm guest is on the same WiFi as the laptop |
| Dashboard shows no data | No data in Firebase yet | This is normal for a new setup; data appears when guests start using the system |
| WiFi keeps disconnecting | WiFi power management | Disable WiFi power save: edit `/etc/NetworkManager/conf.d/default-wifi-powersave-on.conf` and set `wifi.powersave = 2` |
| Laptop runs slowly | Low disk space or memory | Run `df -h` and `free -h`; clear cache with `sudo apt clean`; reboot if needed |
| Order alerts not sounding | Browser notification permissions | Ensure the browser has permission to play sound; check device volume |

### 12.2 Step-by-Step Diagnostics

If the system is not working and the cause is unclear:

1. **Is the laptop on?**
   - Check the power indicator light
   - If off, press the power button

2. **Is Nginx running?**
   ```
   sudo systemctl status nginx
   ```
   - If not running: `sudo systemctl start nginx`

3. **Is there internet?**
   ```
   ping -c 3 google.com
   ```
   - If no replies: check WiFi/Ethernet connection

4. **Are the files in place?**
   ```
   ls -la /var/www/stars-pines/
   ```
   - Should show all five HTML files and the `js/` directory

5. **Is the Nginx configuration valid?**
   ```
   sudo nginx -t
   ```
   - Should report "syntax is ok" and "test is successful"

6. **Can you access the site locally?**
   - Open `http://localhost/` in the laptop's browser
   - If it works locally but not from other devices: check the network connection and firewall

7. **Can other devices access the site?**
   - On a phone, open `http://[laptop-address]/`
   - If it doesn't work: check that the phone is on the same WiFi network

### 12.3 When to Seek Help

Contact your technical support if:
- The laptop does not boot after a power cycle
- Nginx fails to start with configuration errors you cannot resolve
- Firebase data appears to be missing or corrupted
- The network configuration is beyond your comfort level
- You need to set up HTTPS/SSL and are unsure of the process

---

## 13. Frequently Asked Questions

### General

**Q: Do I need to keep the laptop screen on?**
A: No. The screen can be turned off. Only the laptop itself needs to remain powered on. You can close the laptop lid if the power settings are configured to not suspend when the lid is closed.

**Q: What happens if the internet goes down?**
A: The web applications continue to load from the laptop. However, real-time data (new orders, status updates) will not sync until the internet connection is restored. When the connection returns, all queued data syncs automatically.

**Q: Can I use this system without internet?**
A: Partially. The web applications load locally without internet. However, the Firebase database requires an internet connection. Without internet, guests can view the portal but cannot place orders that reach the staff.

**Q: How many guests can use the system at the same time?**
A: The system can handle hundreds of simultaneous users. Nginx supports thousands of concurrent connections. Firebase's free tier supports 100 simultaneous database connections. For a small property, this is more than sufficient.

**Q: How much electricity does the laptop use?**
A: Approximately 30–60 watts. The estimated monthly cost on Indian electricity rates is ₹100–200.

### Operations

**Q: Can I turn off the laptop at night?**
A: You can, but guests will not be able to place orders or make requests during that time. It is recommended to keep the laptop running 24 hours a day.

**Q: Can multiple staff members use Ridgeline at the same time?**
A: Yes. Each staff member opens the Ridgeline app on their own phone. They select their profile and begin working. All staff see the same real-time data.

**Q: What happens when a guest's access code expires?**
A: The Guest Portal stops working and displays an error message. Staff can generate a new code if the guest needs continued access.

**Q: How do I add a new staff member?**
A: No setup is required. The new staff member opens Ridgeline on their phone and selects their profile from the login screen.

**Q: How do I update the menu?**
A: Menu items are defined within the Guest Portal and Ridgeline application files. To update the menu:
1. Edit the relevant HTML file on the laptop
2. Modify the menu items in the code
3. Save the file
4. Users will see the updated menu on their next page load (they may need to refresh their browser)

**Q: How do I change the WhatsApp number?**
A: Edit the file `/var/www/stars-pines/js/firebase-config.js` and update the `whatsappNumber` value.

### Technical

**Q: How do I know if the system is working?**
A: Check the Dashboard. If it loads and displays data, the system is operational. You can also verify by running `sudo systemctl status nginx` (should show "active") and `ping -c 3 google.com` (should show replies).

**Q: Can I access the Dashboard from my phone?**
A: Yes. Open `http://[laptop-address]/dashboard` on any device connected to the same network.

**Q: What if the laptop hard drive fails?**
A: All operational data is stored in Firebase (cloud) and is not affected by laptop hardware failure. The application files can be restored from backup or re-downloaded. See Section 14 (Full System Recovery) for detailed steps.

**Q: Is the system secure?**
A: The system runs on a local network, which provides a basic level of security. The laptop should be kept in a secure location. Firebase data is protected by Google's infrastructure. For internet-facing deployments, HTTPS and a firewall are recommended.

---

## 14. Full System Recovery

This section describes how to rebuild the entire system from scratch. Use this if the laptop is lost, stolen, or suffers a complete hardware failure.

**Typical recovery time:** 30–60 minutes depending on hardware availability and internet connectivity.

### 14.1 What You Need

- A replacement laptop (any laptop meeting the requirements in Section 3.1)
- A USB drive containing the Stars & Pines application files, or access to the project repository
- An internet connection
- This handbook

### 14.2 Recovery Steps

**Step 1 — Install Lubuntu (10–15 minutes)**
1. Download Lubuntu from https://lubuntu.me/downloads/
2. Create a bootable USB drive
3. Install Lubuntu on the replacement laptop
4. Create a user account
5. Connect to the property WiFi or Ethernet

**Step 2 — Install Required Software (5 minutes)**
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y nginx curl wget
```

**Step 3 — Prevent Sleep (2 minutes)**
```
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
Also configure Power Management settings as described in Section 4.2.

**Step 4 — Deploy Application Files (5 minutes)**
```
sudo mkdir -p /var/www/stars-pines/js
```
Copy the application files to `/var/www/stars-pines/` from your USB drive or repository.

```
sudo chown -R www-data:www-data /var/www/stars-pines
sudo chmod -R 755 /var/www/stars-pines
```

**Step 5 — Configure Nginx (5 minutes)**
Follow the steps in Section 4.4 to create and enable the Nginx configuration.

**Step 6 — Set Network Address (5 minutes)**
Configure the laptop's network address to match the previous laptop's address (Section 5.2). This ensures existing QR codes and links continue to work.

**Step 7 — Verify (5 minutes)**
Follow the verification steps in Section 4.5.

**Step 8 — Notify Staff**
Inform staff that the system is back online. Share the laptop's network address if it has changed.

### 14.3 What Is Preserved

- **All Firebase data** — orders, guests, requests, grievances — is stored in the cloud and is unaffected by laptop replacement
- **Guest access codes** — remain valid (unless they have expired)
- **Order history** — preserved in Firebase

### 14.4 What Must Be Reconfigured

- Nginx web server configuration
- Network address (if different from the previous laptop)
- Power management settings
- Any custom domain or Cloudflare tunnel configuration

---

## 15. Backup & Restore

### 15.1 What to Back Up

| Item | Location | Why |
|---|---|---|
| Application files | `/var/www/stars-pines/` | The five web applications |
| Nginx configuration | `/etc/nginx/sites-available/stars-pines` | Web server settings |
| Network configuration | NetworkManager settings | Network address and WiFi credentials |

**Note:** Firebase data is stored in Google's cloud and does not require local backup.

### 15.2 Automated Backup

Create a backup script:

1. Create the script file:
   ```
   nano /home/starspines/backup.sh
   ```

2. Paste the following:
   ```
   #!/bin/bash
   BACKUP_DIR="/home/starspines/backups"
   DATE=$(date +%Y-%m-%d)
   mkdir -p $BACKUP_DIR

   tar -czf $BACKUP_DIR/stars-pines-$DATE.tar.gz /var/www/stars-pines/ /etc/nginx/sites-available/stars-pines

   ls -t $BACKUP_DIR/stars-pines-*.tar.gz | tail -n +8 | xargs rm -f

   echo "Backup complete: $BACKUP_DIR/stars-pines-$DATE.tar.gz"
   ```

3. Make it executable:
   ```
   chmod +x /home/starspines/backup.sh
   ```

4. Schedule it to run daily at 2:00 AM:
   ```
   (crontab -l 2>/dev/null; echo "0 2 * * * /home/starspines/backup.sh") | crontab -
   ```

This keeps the last 7 backups and automatically removes older ones.

### 15.3 Manual Backup to USB

1. Insert a USB drive
2. Mount it:
   ```
   sudo mkdir -p /media/usb
   sudo mount /dev/sdb1 /media/usb
   ```
   (Replace `sdb1` with the correct device name for your USB drive.)

3. Copy the files:
   ```
   cp -r /var/www/stars-pines/ /media/usb/
   cp /etc/nginx/sites-available/stars-pines /media/usb/
   ```

4. Unmount:
   ```
   sudo umount /media/usb
   ```

### 15.4 Restore from Backup

1. List available backups:
   ```
   ls -la /home/starspines/backups/
   ```

2. Restore:
   ```
   sudo tar -xzf /home/starspines/backups/stars-pines-YYYY-MM-DD.tar.gz -C /
   ```

3. Restart Nginx:
   ```
   sudo systemctl restart nginx
   ```

### 15.5 Backup Verification

Once per month, verify that backups are usable:

1. List the contents of the most recent backup:
   ```
   tar -tzf /home/starspines/backups/stars-pines-$(date +%Y-%m).tar.gz | head -20
   ```
2. Confirm the expected files are present
3. If a backup is corrupted, create a new one immediately

---

## 16. Checklists

### 16.1 Daily Checklist

Print this and keep it at the operations desk.

```
DAILY OPERATIONS CHECKLIST
Date: __________    Checked by: __________

MORNING (2 minutes)
[ ] Laptop power light is ON
[ ] Nginx is running: sudo systemctl status nginx → "active (running)"
[ ] Internet is connected: ping -c 3 google.com → replies received
[ ] Test: http://localhost/staff loads on laptop browser

EVENING (5 minutes)
[ ] Dashboard reviewed: http://localhost/dashboard
[ ] All pending orders completed
[ ] Open grievances noted and assigned
[ ] Guest requests reviewed (experiences + concierge)
[ ] Low-stock items noted for tomorrow
[ ] Expected check-outs reviewed for tomorrow

SIGN-OFF
Manager signature: __________
```

### 16.2 Weekly Checklist

```
WEEKLY MAINTENANCE CHECKLIST
Week of: __________    Checked by: __________

[ ] System updated: sudo apt update && sudo apt upgrade -y
[ ] Disk space checked: df -h → at least 50% free
[ ] Nginx error log reviewed: sudo tail -20 /var/log/nginx/error.log
[ ] Nginx restarted: sudo systemctl restart nginx
[ ] All five applications tested from a phone on the same network
[ ] Staff informed of any issues or changes

SIGN-OFF
Manager signature: __________
```

### 16.3 Monthly Checklist

```
MONTHLY MAINTENANCE CHECKLIST
Month: __________    Checked by: __________

[ ] Firebase usage reviewed: console.firebase.google.com → within free tier
[ ] Backup created and verified
[ ] Laptop rebooted: sudo reboot
[ ] System verified after reboot (Daily Checklist)
[ ] Data retention review: remove old entries from Firebase (older than 90 days)
  [ ] /orders — completed/cancelled orders older than 90 days
  [ ] /nudges — fulfilled requests older than 90 days
  [ ] /experiences — completed requests older than 90 days
  [ ] /concierge — completed requests older than 90 days
  [ ] /activity_feed — entries older than 90 days
  [ ] /grievances — DO NOT DELETE (property records)
[ ] Staff access review: confirm only current staff have Ridgeline access
[ ] Firebase access review: confirm only authorized users have project access

SIGN-OFF
Manager signature: __________
```

### 16.4 Emergency Recovery Checklist

```
EMERGENCY RECOVERY CHECKLIST
Date: __________    Incident: __________

IMMEDIATE ACTIONS
[ ] Assess the situation (power outage, hardware failure, network issue, other)
[ ] Notify the property manager
[ ] Switch to manual operations (paper orders, verbal requests) if needed

RECOVERY STEPS
[ ] If power outage: wait for power, turn on laptop, verify Nginx auto-started
[ ] If internet outage: verify local apps still load; wait for internet to return
[ ] If laptop failure: begin Full System Recovery (Section 14)
[ ] If Firebase issue: check status.firebase.google.com; operate manually until resolved

POST-RECOVERY
[ ] Run Daily Checklist (Section 16.1)
[ ] Test all five applications from a phone
[ ] Verify Firebase data is syncing correctly
[ ] Notify staff that the system is back online
[ ] Document the incident and recovery steps

INCIDENT REPORT
What happened: ________________________________________________
Cause: ________________________________________________
Recovery time: ________________________________________________
Lessons learned: ________________________________________________

Manager signature: __________
```

### 16.5 New Staff Onboarding Checklist

```
NEW STAFF ONBOARDING CHECKLIST
Staff name: __________    Role: __________    Date: __________

SYSTEM ACCESS
[ ] Staff phone is connected to the property WiFi
[ ] Staff can open http://[laptop-address]/staff on their phone
[ ] Staff profile is visible on the Ridgeline login screen
[ ] Staff has selected their profile and logged in

TRAINING
[ ] Staff understands the six tabs in Ridgeline:
    [ ] Queue — view and manage pending orders
    [ ] Order — place orders on behalf of guests
    [ ] Nudge — view guest requests and flag issues
    [ ] Concerns — acknowledge and resolve guest grievances
    [ ] Log — view activity history
    [ ] Me — profile, guest check-in, QR generator
[ ] Staff knows how to mark an order as done or cancelled
[ ] Staff knows how to acknowledge and resolve a grievance
[ ] Staff knows how to generate a guest access code
[ ] Staff knows how to share the access code (QR, WhatsApp, verbal)
[ ] Staff knows who to contact if the system is not working

GUEST INTERACTION
[ ] Staff understands the guest check-in process (Section 7.1)
[ ] Staff understands the guest check-out process (Section 7.2)
[ ] Staff knows the laptop's network address
[ ] Staff knows the system runs 24/7 and does not need to be turned on

SIGN-OFF
Staff signature: __________
Trainer signature: __________
```

---

## 17. Quick Reference Card

Print this and keep it next to the laptop.

```
┌─────────────────────────────────────────────────────────────────┐
│              STARS & PINES — QUICK REFERENCE                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  LAPTOP ADDRESS: ____________________ (find with: hostname -I)  │
│                                                                  │
│  APPLICATIONS                                                    │
│  • Website:     http://[address]/                                │
│  • Guest Portal: http://[address]/portal                         │
│  • Ridgeline:   http://[address]/staff                           │
│  • Dashboard:   http://[address]/dashboard                       │
│  • Guest Entry: http://[address]/entry                           │
│                                                                  │
│  DAILY CHECK                                                     │
│  1. Laptop power light ON                                        │
│  2. sudo systemctl status nginx → "active (running)"             │
│  3. ping -c 3 google.com → replies received                      │
│                                                                  │
│  IF SOMETHING IS WRONG                                           │
│  1. sudo systemctl restart nginx                                 │
│  2. sudo reboot                                                  │
│  3. See Troubleshooting section (Section 12)                     │
│                                                                  │
│  FIREBASE CONSOLE                                                │
│  https://console.firebase.google.com/project/stars-and-pines-ridge│
│                                                                  │
│  FIREBASE STATUS                                                 │
│  https://status.firebase.google.com                              │
│                                                                  │
│  EMERGENCY CONTACT                                               │
│  Technical support: ___________________________________          │
│  Property manager: ___________________________________           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Support

For technical assistance:

- **Project Repository:** https://github.com/swappy-ops/stars-pines
- **Firebase Console:** https://console.firebase.google.com/project/stars-and-pines-ridge
- **Firebase Status:** https://status.firebase.google.com
- **This Handbook:** Keep a printed copy with the laptop

---

**Stars & Pines · Crank's Ridge · Kasar Devi · Almora · Uttarakhand · 263601**
