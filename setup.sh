#!/bin/bash
# ─────────────────────────────────────────────
# Stars & Pines — Auto Setup Script
# Detects OS, installs deps, configures server
# ─────────────────────────────────────────────
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPLOY_DIR="/var/www/stars-pines"
PORT="${PORT:-8080}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
info() { echo -e "${CYAN}[·]${NC} $1"; }

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Stars & Pines — Setup                 ║${NC}"
echo -e "${CYAN}║   Crank's Ridge, Kasar Devi             ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# ─── Detect OS ───
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
        OSPRETTY=$PRETTY_NAME
    elif [ "$(uname)" = "Darwin" ]; then
        OS="macos"
        OS_VERSION=$(sw_vers -productVersion)
        OSPRETTY="macOS $OS_VERSION"
    else
        OS="unknown"
        OSPRETTY="Unknown"
    fi
    info "Detected: $OSPRETTY"
}

# ─── Check/install dependencies ───
install_deps() {
    case "$OS" in
        ubuntu|debian|linuxmint|pop)
            info "Using apt package manager..."
            sudo apt-get update -qq
            if command -v nginx &>/dev/null; then
                log "Nginx already installed"
            else
                info "Installing Nginx..."
                sudo apt-get install -y -qq nginx
                log "Nginx installed"
            fi
            ;;
        fedora|rhel|centos|rocky|alma)
            info "Using dnf/yum package manager..."
            if command -v nginx &>/dev/null; then
                log "Nginx already installed"
            else
                info "Installing Nginx..."
                sudo dnf install -y nginx 2>/dev/null || sudo yum install -y nginx
                log "Nginx installed"
            fi
            ;;
        arch|manjaro)
            info "Using pacman..."
            if command -v nginx &>/dev/null; then
                log "Nginx already installed"
            else
                info "Installing Nginx..."
                sudo pacman -S --noconfirm nginx
                log "Nginx installed"
            fi
            ;;
        alpine)
            info "Using apk..."
            if command -v nginx &>/dev/null; then
                log "Nginx already installed"
            else
                info "Installing Nginx..."
                sudo apk add nginx
                log "Nginx installed"
            fi
            ;;
        arch*|manjaro*)
            info "Using pacman..."
            sudo pacman -S --noconfirm nginx 2>/dev/null || true
            ;;
        macos)
            if command -v nginx &>/dev/null; then
                log "Nginx already installed"
            elif command -v brew &>/dev/null; then
                info "Installing Nginx via Homebrew..."
                brew install nginx
                log "Nginx installed"
            else
                warn "Homebrew not found. Using Python fallback."
                USE_PYTHON=1
            fi
            ;;
        *)
            warn "Unknown OS. Checking for existing servers..."
            ;;
    esac

    # Fallback: check if nginx or python3 available
    if ! command -v nginx &>/dev/null; then
        if command -v python3 &>/dev/null; then
            warn "Nginx not available. Using Python HTTP server on port $PORT"
            USE_PYTHON=1
        else
            err "Neither Nginx nor Python3 found. Please install one."
            exit 1
        fi
    fi
}

# ─── Validate source files ───
validate() {
    info "Validating source files..."
    local missing=0
    for f in index.html guest-portal.html employee-app.html dashboard.html guest-entry.html; do
        if [ ! -f "$REPO_DIR/$f" ]; then
            err "Missing: $f"
            missing=1
        fi
    done
    for f in js/firebase-config.js js/shared-utils.js js/local-db.js js/sync-engine.js js/payment-engine.js; do
        if [ ! -f "$REPO_DIR/$f" ]; then
            err "Missing: $f"
            missing=1
        fi
    done
    if [ "$missing" -eq 1 ]; then exit 1; fi
    log "All source files present"
}

# ─── Deploy files ───
deploy_files() {
    info "Deploying to $DEPLOY_DIR..."
    sudo mkdir -p "$DEPLOY_DIR/js"

    # HTML
    sudo cp "$REPO_DIR/index.html" "$DEPLOY_DIR/"
    sudo cp "$REPO_DIR/guest-portal.html" "$DEPLOY_DIR/"
    sudo cp "$REPO_DIR/employee-app.html" "$DEPLOY_DIR/"
    sudo cp "$REPO_DIR/dashboard.html" "$DEPLOY_DIR/"
    sudo cp "$REPO_DIR/guest-entry.html" "$DEPLOY_DIR/"

    # JS
    sudo cp "$REPO_DIR/js/firebase-config.js" "$DEPLOY_DIR/js/"
    sudo cp "$REPO_DIR/js/shared-utils.js" "$DEPLOY_DIR/js/"
    sudo cp "$REPO_DIR/js/local-db.js" "$DEPLOY_DIR/js/"
    sudo cp "$REPO_DIR/js/sync-engine.js" "$DEPLOY_DIR/js/"
    sudo cp "$REPO_DIR/js/payment-engine.js" "$DEPLOY_DIR/js/"

    # Config
    sudo cp "$REPO_DIR/firebase.json" "$DEPLOY_DIR/" 2>/dev/null || true
    sudo cp "$REPO_DIR/database.rules.json" "$DEPLOY_DIR/" 2>/dev/null || true

    sudo chown -R www-data:www-data "$DEPLOY_DIR" 2>/dev/null || sudo chown -R nginx:nginx "$DEPLOY_DIR" 2>/dev/null || true
    sudo chmod -R 755 "$DEPLOY_DIR"

    log "Files deployed"
}

# ─── Configure Nginx ───
configure_nginx() {
    info "Configuring Nginx..."

    sudo tee /etc/nginx/sites-available/stars-pines > /dev/null << 'NGINX'
server {
    listen 80;
    server_name _;
    root /var/www/stars-pines;
    index index.html;

    # Clean URL rewrites
    location /portal {
        try_files /guest-portal.html =404;
    }
    location /staff {
        try_files /employee-app.html =404;
    }
    location /dashboard {
        try_files /dashboard.html =404;
    }
    location /entry {
        try_files /guest-entry.html =404;
    }

    # Static asset caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # HTML no-cache
    location ~* \.html$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
}
NGINX

    sudo rm -f /etc/nginx/sites-enabled/default
    sudo ln -sf /etc/nginx/sites-available/stars-pines /etc/nginx/sites-enabled/stars-pines

    if sudo nginx -t 2>/dev/null; then
        sudo systemctl enable nginx 2>/dev/null || true
        sudo systemctl restart nginx 2>/dev/null || sudo service nginx restart 2>/dev/null || true
        log "Nginx configured and running"
    else
        warn "Nginx config test failed, falling back to Python"
        USE_PYTHON=1
    fi
}

# ─── Start Python fallback server ───
start_python_server() {
    info "Starting Python HTTP server on port $PORT..."

    # Kill any existing server on the port
    if lsof -ti :$PORT &>/dev/null; then
        warn "Port $PORT in use, killing existing process..."
        kill $(lsof -ti :$PORT) 2>/dev/null || true
        sleep 1
    fi

    # Create a simple Python server with URL rewriting
    cat > "$REPO_DIR/.serve.py" << 'PYEOF'
#!/usr/bin/env python3
"""Stars & Pines local dev server with URL rewrites."""
import http.server
import os, sys, re, socketserver

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
DIR = os.path.dirname(os.path.abspath(__file__))

REWRITES = {
    '/portal': 'guest-portal.html',
    '/portal/': 'guest-portal.html',
    '/staff': 'employee-app.html',
    '/staff/': 'employee-app.html',
    '/dashboard': 'dashboard.html',
    '/dashboard/': 'dashboard.html',
    '/entry': 'guest-entry.html',
    '/entry/': 'guest-entry.html',
}

class SPHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIR, **kwargs)

    def do_GET(self):
        path = self.path.split('?')[0].rstrip('/')
        if path in REWRITES:
            self.path = '/' + REWRITES[path]
        elif path == '' or path == '/':
            self.path = '/index.html'
        return super().do_GET()

    def log_message(self, format, *args):
        pass  # silent

with socketserver.TCPServer(("", PORT), SPHandler) as httpd:
    print(f"Stars & Pines serving at http://localhost:{PORT}")
    print(f"  Website:     http://localhost:{PORT}/")
    print(f"  Guest Portal: http://localhost:{PORT}/portal")
    print(f"  Employee App: http://localhost:{PORT}/staff")
    print(f"  Dashboard:   http://localhost:{PORT}/dashboard")
    print(f"  Guest Entry: http://localhost:{PORT}/entry")
    print("Press Ctrl+C to stop.")
    httpd.serve_forever()
PYEOF

    cd "$REPO_DIR"
    python3 "$REPO_DIR/.serve.py" "$PORT" &
    SERVER_PID=$!
    sleep 1

    if kill -0 $SERVER_PID 2>/dev/null; then
        log "Server running (PID: $SERVER_PID)"
    else
        err "Failed to start server"
        exit 1
    fi
}

# ─── Verify deployment ───
verify() {
    info "Verifying deployment..."
    local base_url

    if [ "$USE_PYTHON" = "1" ]; then
        base_url="http://localhost:$PORT"
    else
        local ip
        ip=$(hostname -I 2>/dev/null | awk '{print $1}')
        [ -z "$ip" ] && ip="localhost"
        base_url="http://$ip"
    fi

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   Deployment Complete!                   ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo "  URLs:"
    echo -e "    Website:      ${CYAN}${base_url}/${NC}"
    echo -e "    Guest Portal: ${CYAN}${base_url}/portal${NC}"
    echo -e "    Employee App: ${CYAN}${base_url}/staff${NC}"
    echo -e "    Dashboard:    ${CYAN}${base_url}/dashboard${NC}"
    echo -e "    Guest Entry:  ${CYAN}${base_url}/entry${NC}"
    echo ""

    # Quick health check
    local ok=0
    for path in / /portal /staff /dashboard /entry; do
        local code
        code=$(curl -s -o /dev/null -w "%{http_code}" "${base_url}${path}" 2>/dev/null)
        if [ "$code" = "200" ]; then
            echo -e "    ${GREEN}✓${NC} ${path} → ${code}"
            ok=$((ok + 1))
        else
            echo -e "    ${RED}✗${NC} ${path} → ${code}"
        fi
    done
    echo ""

    if [ "$ok" -eq 5 ]; then
        echo -e "  ${GREEN}All 5 apps responding!${NC}"
    else
        echo -e "  ${YELLOW}${ok}/5 apps responding${NC}"
    fi
    echo ""
}

# ─── Main ───
USE_PYTHON=0
detect_os
install_deps
validate

if [ "$USE_PYTHON" = "1" ]; then
    start_python_server
else
    deploy_files
    configure_nginx
fi

verify
