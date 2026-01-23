#!/bin/bash
set -e  # Exit on error

echo "======================================"
echo "🚀 Starting Frappe (Login Page Only)"
echo "======================================"
echo ""

# Set up site directory
SITE_NAME="${FRAPPE_SITE_NAME:-site1.local}"
SITE_DIR="sites/${SITE_NAME}"

echo "📋 Configuration:"
echo "  - Site name: $SITE_NAME"
echo "  - Port: ${PORT:-8000}"
echo ""

# Create minimal site directory structure
if [ ! -d "$SITE_DIR" ]; then
  echo "📁 Creating site directory..."
  mkdir -p "$SITE_DIR"
fi

# Create minimal site_config.json (no database, just for UI)
if [ ! -f "${SITE_DIR}/site_config.json" ]; then
  echo "📝 Creating minimal site config..."
  cat > "${SITE_DIR}/site_config.json" << EOF
{
 "db_name": "_demo",
 "db_password": "demo",
 "db_type": "postgres"
}
EOF
  chmod 644 "${SITE_DIR}/site_config.json"
  echo "✅ Site config created!"
fi

# Create sites/currentsite.txt
echo "$SITE_NAME" > sites/currentsite.txt

echo ""
echo "======================================"
echo "🎉 Setup Complete!"
echo "======================================"
echo "ℹ️  Note: This is a demo deployment"
echo "ℹ️  Login page will show but login won't work"
echo "ℹ️  Database is not initialized"
echo ""
echo "🌐 Starting Frappe web server on port ${PORT:-8000}..."
echo "======================================"
echo ""

# Start web server (bench listens on all interfaces by default)
exec bench serve --port ${PORT:-8000}
