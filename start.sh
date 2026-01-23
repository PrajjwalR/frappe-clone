#!/bin/bash
set -e

echo "======================================"
echo "🚀 Starting Frappe initialization..."
echo "======================================"
echo ""

# Set environment
SITE_NAME="${FRAPPE_SITE_NAME:-frappe-clone.fly.dev}"
SITE_DIR="sites/${SITE_NAME}"

# Parse DATABASE_URL to get credentials
DB_USER=$(echo $DATABASE_URL | sed -E 's|postgres(ql)?://([^:]+):.*|\2|')
DB_PASSWORD=$(echo $DATABASE_URL | sed -E 's|postgres(ql)?://[^:]+:([^@]+)@.*|\2|')
DB_HOST=$(echo $DATABASE_URL | sed -E 's|.*@([^:/]+).*|\1|')
DB_NAME=$(echo $DATABASE_URL | sed -E 's|.*/([^?]+)(\?.*)?$|\1|')
DB_PORT=$(echo $DATABASE_URL | grep -oE ':[0-9]+/' | tr -d ':/' || echo "5432")

echo "📊 Database Configuration:"
echo "  - Host: $DB_HOST"
echo "  - Port: $DB_PORT"
echo "  - Database: $DB_NAME"
echo ""

# Check if site already exists
if [ ! -f "${SITE_DIR}/site_config.json" ]; then
  echo "📦 Creating Frappe site: ${SITE_NAME}"
  echo "  (DROP DATABASE is patched out, so this should work now!)"
  echo ""
  
  # Create site - DROP DATABASE line is now patched out in Frappe source
  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host "$DB_HOST" \
    --db-port "$DB_PORT" \
    --db-name "$DB_NAME" \
    --db-root-username "$DB_USER" \
    --db-root-password "$DB_PASSWORD" \
    --admin-password admin \
    --force || {
      echo "❌ Site creation failed - check logs above"
      exit 1
    }
  
  echo "✅ Site created successfully!"
else
  echo "✅ Site already exists"
fi

echo ""
echo "🌐 Starting web server on port ${PORT:-8000}..."
exec bench serve --port ${PORT:-8000}
