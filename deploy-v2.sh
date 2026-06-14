#!/bin/bash
# Stars & Pines v2 — Deploy Script
# Run on the starsandpines machine (10.190.238.183)
# Or run from manny machine: sshpass -p 'raman' ssh starsandpines@10.190.238.183 'bash -s' < deploy-v2.sh

set -e

SRC="$HOME/Downloads/stars-pines-extracted/stars-pines-main"
DEST="/var/www/stars-pines"

echo "=== Stars & Pines v2 Deployment ==="
echo "Source: $SRC"
echo "Destination: $DEST"

# Verify source files exist
for f in employee-app.html guest-portal.html dashboard.html index.html guest-entry.html; do
  if [ ! -f "$SRC/$f" ]; then
    echo "ERROR: Missing $SRC/$f"
    exit 1
  fi
done

for f in js/firebase-config.js js/shared-utils.js js/local-db.js js/sync-engine.js js/payment-engine.js; do
  if [ ! -f "$SRC/$f" ]; then
    echo "ERROR: Missing $SRC/$f"
    exit 1
  fi
done

# Deploy HTML files
echo "Deploying HTML files..."
cp "$SRC/employee-app.html" "$DEST/"
cp "$SRC/guest-portal.html" "$DEST/"
cp "$SRC/dashboard.html" "$DEST/"
cp "$SRC/index.html" "$DEST/"
cp "$SRC/guest-entry.html" "$DEST/"

# Deploy JS files
echo "Deploying JS files..."
mkdir -p "$DEST/js"
cp "$SRC/js/firebase-config.js" "$DEST/js/"
cp "$SRC/js/shared-utils.js" "$DEST/js/"
cp "$SRC/js/local-db.js" "$DEST/js/"
cp "$SRC/js/sync-engine.js" "$DEST/js/"
cp "$SRC/js/payment-engine.js" "$DEST/js/"

# Deploy config files
echo "Deploying config files..."
cp "$SRC/database.rules.json" "$DEST/"
cp "$SRC/firebase.json" "$DEST/"

# Set permissions
echo "Setting permissions..."
chown -R www-data:www-data "$DEST"
chmod -R 755 "$DEST"

# Update nginx config
echo "Updating nginx..."
cat > /etc/nginx/sites-available/stars-pines << 'NGINX'
server {
    listen 80;
    server_name _;
    root /var/www/stars-pines;
    index index.html;

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
NGINX

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/stars-pines /etc/nginx/sites-enabled/stars-pines
nginx -t && service nginx reload

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "URLs:"
echo "  Website:     http://$(hostname -I | awk '{print $1')/"
echo "  Employee:    http://$(hostname -I | awk '{print $1')/staff"
echo "  Guest Portal: http://$(hostname -I | awk '{print $1')/portal"
echo "  Dashboard:   http://$(hostname -I | awk '{print $1')/dashboard"
echo "  Guest Entry: http://$(hostname -I | awk '{print $1')/entry"
echo ""
echo "Verify:"
for path in / /staff /portal /dashboard /entry; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost$path")
  echo "  http://localhost$path -> $code"
done
