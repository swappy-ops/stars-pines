#!/bin/bash
# ─────────────────────────────────────────────────────────
# Stars & Pines — Workstation Provisioning System
# Main Installer Script
#
# Single command installation:
#   chmod +x install-stars-pines.sh && ./install-stars-pines.sh
#
# Run as: sudo ./install-stars-pines.sh
# ─────────────────────────────────────────────────────────
set -e

# ── Globals ──
INSTALLER_DIR="$(cd "$(dirname "$0")" && pwd)"
PROVISION_DIR="$INSTALLER_DIR/provision"
SCRIPT_USER="${SUDO_USER:-$USER}"
SCRIPT_HOME=$(getent passwd "$SCRIPT_USER" | cut -d: -f6)
LOG_DIR="/var/log/starsandpines"
WEB_DIR="/var/www/starsandpines"

# ── Colors ──
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

# ── Helpers ──
log()   { echo -e "  ${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[!]${NC} $1"; }
err()   { echo -e "  ${RED}[✗]${NC} $1"; }
info()  { echo -e "  ${CYAN}[·]${NC} $1"; }
step()  { echo -e "\n${CYAN}━━━ $1 ━━━${NC}"; }

# ── Banner ──
banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║  Stars & Pines — Workstation Provisioning System     ║"
    echo "║  Crank's Ridge · Kasar Devi · Uttarakhand            ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ── Detect OS ──
detect_os() {
    step "System Detection"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS="$ID"; OSPRETTY="$PRETTY_NAME"
    else
        OS="unknown"; OSPRETTY="Unknown Linux"
    fi
    info "OS: $OSPRETTY ($OS)"
    info "User: $SCRIPT_USER (home: $SCRIPT_HOME)"
    info "Installer dir: $INSTALLER_DIR"

    case "$OS" in
        ubuntu|debian|linuxmint|pop)
            PKG_MGR="apt"; PKG_UPDATE="apt-get update -qq"; PKG_INSTALL="apt-get install -y -qq"
            ;;
        fedora|rhel|centos|rocky|alma)
            PKG_MGR="dnf"; PKG_UPDATE=""; PKG_INSTALL="dnf install -y"
            ;;
        arch|manjaro)
            PKG_MGR="pacman"; PKG_UPDATE="pacman -Sy"; PKG_INSTALL="pacman -S --noconfirm"
            ;;
        *)
            warn "Unknown OS. Will try apt then dnf."
            PKG_MGR="apt"; PKG_UPDATE="apt-get update -qq"; PKG_INSTALL="apt-get install -y -qq"
            ;;
    esac
    log "Package manager: $PKG_MGR"
}

# ── Install Dependencies ──
install_deps() {
    step "Installing Dependencies"
    info "Updating package lists..."
    $PKG_UPDATE 2>/dev/null || true

    PKGS="nginx apache2-utils curl wget tar gzip ufw fail2ban"
    if command -v ufw &>/dev/null; then
        PKGS="$PKGS ufw"
    fi
    if ! command -v logrotate &>/dev/null; then
        PKGS="$PKGS logrotate"
    fi

    info "Installing: $PKGS"
    $PKG_INSTALL $PKGS 2>/dev/null || {
        warn "Some packages failed, continuing..."
    }
    log "Dependencies installed"
}

# ── Hostname ──
set_hostname() {
    step "Setting Hostname"
    current_hostname=$(hostname)
    if [ "$current_hostname" != "stars-pines-ops" ]; then
        info "Current hostname: $current_hostname"
        info "Setting to: stars-pines-ops"
        hostnamectl set-hostname "stars-pines-ops" 2>/dev/null || {
            echo "stars-pines-ops" > /etc/hostname
            sed -i "s/$current_hostname/stars-pines-ops/" /etc/hosts 2>/dev/null || true
        }
        log "Hostname updated. Reboot required for full effect."
    else
        log "Hostname already set to stars-pines-ops"
    fi
}

# ── Directory Structure ──
create_dirs() {
    step "Creating Directory Structure"
    info "Creating ~/StarsAndPines/..."
    mkdir -p "$SCRIPT_HOME/StarsAndPines"/{Operations/{logs,cache,temp},Reservations,Guests,Reports,Finance,Vendors,Media/{photos,videos,promo},Marketing,Backups/{daily,weekly,monthly},Documents/{manuals,policies,contacts},Templates}

    mkdir -p "$SCRIPT_HOME/StarsAndPines/Operations/logs"
    touch "$SCRIPT_HOME/StarsAndPines/Operations/logs/backup.log"
    touch "$SCRIPT_HOME/StarsAndPines/Operations/logs/system.log"

    chown -R "$SCRIPT_USER:$SCRIPT_USER" "$SCRIPT_HOME/StarsAndPines"
    chmod -R 755 "$SCRIPT_HOME/StarsAndPines"
    log "Directory structure created"
}

# ── Web Server ──
setup_webserver() {
    step "Configuring Web Server"

    info "Creating web root at $WEB_DIR"
    mkdir -p "$WEB_DIR/js"

    # Copy HTML files from repo
    if [ -f "$INSTALLER_DIR/index.html" ]; then
        cp "$INSTALLER_DIR/index.html" "$WEB_DIR/"
        cp "$INSTALLER_DIR/guest-portal.html" "$WEB_DIR/"
        cp "$INSTALLER_DIR/employee-app.html" "$WEB_DIR/"
        cp "$INSTALLER_DIR/dashboard.html" "$WEB_DIR/"
        cp "$INSTALLER_DIR/guest-entry.html" "$WEB_DIR/"
        log "HTML files deployed"
    else
        warn "No HTML files found in $INSTALLER_DIR — skipping"
    fi

    # Copy JS files
    if [ -d "$INSTALLER_DIR/js" ]; then
        cp "$INSTALLER_DIR/js/"*.js "$WEB_DIR/js/" 2>/dev/null || true
        log "JS files deployed"
    fi

    # Copy config
    [ -f "$INSTALLER_DIR/firebase.json" ] && cp "$INSTALLER_DIR/firebase.json" "$WEB_DIR/"
    [ -f "$INSTALLER_DIR/database.rules.json" ] && cp "$INSTALLER_DIR/database.rules.json" "$WEB_DIR/"

    # Install nginx config
    if [ -f "$PROVISION_DIR/nginx/starsandpines" ]; then
        cp "$PROVISION_DIR/nginx/starsandpines" /etc/nginx/sites-available/starsandpines
        ln -sf /etc/nginx/sites-available/starsandpines /etc/nginx/sites-enabled/starsandpines
        rm -f /etc/nginx/sites-enabled/default
        log "Nginx config installed"
    fi

    # Test and reload nginx
    if nginx -t 2>&1 | grep -q "syntax is ok"; then
        systemctl enable nginx 2>/dev/null || true
        systemctl restart nginx 2>/dev/null || service nginx restart 2>/dev/null || true
        log "Nginx started"
    else
        err "Nginx config test failed"
        nginx -t 2>&1 | grep -i error || true
    fi

    chown -R www-data:www-data "$WEB_DIR" 2>/dev/null || true
    chmod -R 755 "$WEB_DIR"
}

# ── Systemd Services ──
setup_services() {
    step "Configuring Systemd Services"

    # Backup script
    if [ -f "$PROVISION_DIR/backup/starsandpines-backup.sh" ]; then
        cp "$PROVISION_DIR/backup/starsandpines-backup.sh" /usr/local/bin/
        chmod +x /usr/local/bin/starsandpines-backup.sh
        log "Backup script installed"
    fi

    # Systemd service + timer
    if [ -f "$PROVISION_DIR/systemd/starsandpines-backup.service" ]; then
        cp "$PROVISION_DIR/systemd/starsandpines-backup.service" /etc/systemd/system/
        cp "$PROVISION_DIR/systemd/starsandpines-backup.timer" /etc/systemd/system/
        systemctl daemon-reload
        systemctl enable starsandpines-backup.timer 2>/dev/null || true
        log "Backup timer enabled"
    fi

    # Web service
    if [ -f "$PROVISION_DIR/systemd/starsandpines-web.service" ]; then
        cp "$PROVISION_DIR/systemd/starsandpines-web.service" /etc/systemd/system/
        systemctl daemon-reload
        systemctl enable starsandpines-web 2>/dev/null || true
        log "Web service enabled"
    fi
}

# ── Desktop Launchers ──
setup_launchers() {
    step "Creating Desktop Launchers"

    mkdir -p "$SCRIPT_HOME/Desktop"
    mkdir -p "$SCRIPT_HOME/.local/share/applications"

    LAUNCHER_DIR="$PROVISION_DIR/launchers"
    for f in "$LAUNCHER_DIR"/*.desktop; do
        if [ -f "$f" ]; then
            fname=$(basename "$f")
            cp "$f" "$SCRIPT_HOME/Desktop/$fname"
            cp "$f" "$SCRIPT_HOME/.local/share/applications/$fname"
            chmod +x "$SCRIPT_HOME/Desktop/$fname"
            log "Launcher: $fname"
        fi
    done

    # Also copy scripts
    if [ -d "$PROVISION_DIR/scripts" ]; then
        mkdir -p "$SCRIPT_HOME/StarsAndPines/Scripts"
        cp "$PROVISION_DIR/scripts/"*.sh "$SCRIPT_HOME/StarsAndPines/Scripts/" 2>/dev/null || true
        chmod +x "$SCRIPT_HOME/StarsAndPines/Scripts/"*.sh 2>/dev/null || true
    fi

    chown -R "$SCRIPT_USER:$SCRIPT_USER" "$SCRIPT_HOME/Desktop"
    chown -R "$SCRIPT_USER:$SCRIPT_USER" "$SCRIPT_HOME/.local/share/applications"
    log "Launchers installed"
}

# ── Firefox Setup ──
setup_firefox() {
    step "Configuring Firefox"

    if ! command -v firefox &>/dev/null; then
        warn "Firefox not found. Skipping Firefox setup."
        return
    fi

    if [ -f "$PROVISION_DIR/firefox/setup-firefox.sh" ]; then
        bash "$PROVISION_DIR/firefox/setup-firefox.sh"
    else
        warn "Firefox setup script not found"
    fi

    log "Firefox configured"
}

# ── Autostart ──
setup_autostart() {
    step "Configuring Autostart"

    if [ -f "$PROVISION_DIR/scripts/autostart.sh" ]; then
        bash "$PROVISION_DIR/scripts/autostart.sh"
    fi

    # Also add to ~/.config/autostart for MX Linux
    AUTOSTART_DIR="$SCRIPT_HOME/.config/autostart"
    mkdir -p "$AUTOSTART_DIR"

    cat > "$AUTOSTART_DIR/starsandpines-web.desktop" << 'AU'
[Desktop Entry]
Type=Application
Name=Stars & Pines Web Server
Exec=sudo systemctl start starsandpines-web || true
X-GNOME-Autostart-enabled=true
AU

    cat > "$AUTOSTART_DIR/starsandpines-dashboard.desktop" << 'AU'
[Desktop Entry]
Type=Application
Name=Stars & Pines Dashboard
Exec=firefox --new-window "http://localhost/dashboard"
X-GNOME-Autostart-enabled=true
AU

    chown -R "$SCRIPT_USER:$SCRIPT_USER" "$AUTOSTART_DIR"
    log "Autostart configured"
}

# ── Branding ──
setup_branding() {
    step "Applying Branding"

    # Wallpaper spec
    WALLPAPER_SPEC="$PROVISION_DIR/branding/wallpaper-spec.md"
    if [ ! -f "$WALLPAPER_SPEC" ]; then
        mkdir -p "$(dirname "$WALLPAPER_SPEC")"
        cat > "$WALLPAPER_SPEC" << 'SPEC'
# Stars & Pines — Wallpaper & Branding Specification

## Desktop Wallpaper
- Resolution: 1920x1080 (primary), 1366x768 (secondary)
- Style: Minimal luxury hospitality
- Mood: Mountain retreat, boutique Himalayan lodge

## Color Palette
- Forest Green: #1D2C1B
- Warm Beige: #F8F5F0
- Off White: #FCFAF6
- Dark Charcoal: #0B0D0B
- Gold Accent: #D6B26E

## Visual Elements
- Himalayan mountain range silhouette (subtle, dark)
- Pine forest lower third
- Stars scattered in night areas
- Stars & Pines wordmark (bottom center, subtle)
- Earth tones throughout
- Dark green accents
- NO corporate clip art
- NO bright neon colors

## Sources
- Use: Unsplash (free), Pexels, or custom photography
- Suggested: "himalayan mountains fog" "pine forest" "mountain lodge"
- Place in: ~/StarsAndPines/Media/wallpapers/

## Login Screen (LightDM)
- Use same visual as desktop wallpaper
- Add subtle Stars & Pines logo overlay
- Configure via: lightdm-gtk-greeter
SPEC
        fi
    log "Branding spec written to $WALLPAPER_SPEC"

    # GTK theme config for MX Linux
    mkdir -p "$SCRIPT_HOME/.config/gtk-3.0"
    cat > "$SCRIPT_HOME/.config/gtk-3.0/settings.ini" << 'GTK'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
GTK

    # Copy branding docs
    mkdir -p "$SCRIPT_HOME/StarsAndPines/Documents/branding"
    cp -r "$PROVISION_DIR/branding/"* "$SCRIPT_HOME/StarsAndPines/Documents/branding/" 2>/dev/null || true

    chown -R "$SCRIPT_USER:$SCRIPT_USER" "$SCRIPT_HOME/.config"
    log "Branding configured"
}

# ── Verify ──
verify() {
    step "Verification"

    local base_url="http://localhost"
    local ok=0

    for path in / /portal /staff /dashboard /entry; do
        local code
        code=$(curl -s -o /dev/null -w "%{http_code}" "$base_url$path" 2>/dev/null || echo "000")
        if [ "$code" = "200" ]; then
            log "$path → 200 OK"
            ok=$((ok + 1))
        else
            err "$path → $code"
        fi
    done

    echo ""
    if [ "$ok" -eq 5 ]; then
        log "All 5 web apps responding!"
    else
        warn "$ok/5 web apps responding"
    fi
}

# ── Done ──
done_msg() {
    step "Installation Complete!"
    echo ""
    echo -e "${GREEN}  Stars & Pines Operations Terminal ready!${NC}"
    echo ""
    echo "  URLs:"
    echo -e "    Website:      ${CYAN}http://localhost/${NC}"
    echo -e "    Guest Portal: ${CYAN}http://localhost/portal${NC}"
    echo -e "    Staff App:    ${CYAN}http://localhost/staff${NC}"
    echo -e "    Dashboard:    ${CYAN}http://localhost/dashboard${NC}"
    echo -e "    Guest Entry:  ${CYAN}http://localhost/entry${NC}"
    echo ""
    echo "  Files:"
    echo "    ~/StarsAndPines/          — Operations directory"
    echo "    ~/StarsAndPines/Scripts/  — Automation scripts"
    echo "    ~/Desktop/*.desktop       — App launchers"
    echo ""
    echo "  After reboot:"
    echo "    Dashboard opens automatically"
    echo ""
}

# ── Main ──
main() {
    banner

    if [ "$EUID" -ne 0 ]; then
        err "Run as: sudo ./install-stars-pines.sh"
        exit 1
    fi

    detect_os
    install_deps
    set_hostname
    create_dirs
    setup_webserver
    setup_services
    setup_launchers
    setup_firefox
    setup_autostart
    setup_branding
    verify
    done_msg
}

main "$@"