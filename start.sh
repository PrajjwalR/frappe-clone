#!/bin/bash
set -e

echo "🚀 Starting Frappe initialization..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
until pg_isready -h $(echo $DATABASE_URL | sed -E 's/.*@([^:]+).*/\1/') -U postgres; do
  echo "Database not ready, waiting..."
  sleep 2
done

echo "✅ Database is ready!"

# Set up site config directory
SITE_NAME="${FRAPPE_SITE_NAME:-site1.local}"
SITE_DIR="sites/${SITE_NAME}"

# Create site if it doesn't exist
if [ ! -f "${SITE_DIR}/site_config.json" ]; then
  echo "📦 Creating new Frappe site: ${SITE_NAME}"
  
  # Create site with PostgreSQL
  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host $(echo $DATABASE_URL | sed -E 's/.*@([^:]+).*/\1/') \
    --db-name $(echo $DATABASE_URL | sed -E 's/.*\/([^?]+).*/\1/') \
    --admin-password admin \
    --mariadb-root-password root \
    --force
  
  echo "✅ Site created successfully!"
  
  # Install ERPNext if available
  if [ -d "apps/erpnext" ]; then
    echo "📦 Installing ERPNext..."
    bench --site ${SITE_NAME} install-app erpnext
    echo "✅ ERPNext installed!"
  fi
else
  echo "✅ Site already exists: ${SITE_NAME}"
fi

# Configure Redis if URL provided
if [ ! -z "$REDIS_URL" ]; then
  echo "🔧 Configuring Redis..."
  bench --site ${SITE_NAME} set-config redis_cache "redis://default:${REDIS_URL#*://}"
  bench --site ${SITE_NAME} set-config redis_queue "redis://default:${REDIS_URL#*://}"
fi

# Start the web server
echo "🌐 Starting Frappe web server..."
exec bench serve --port ${PORT:-8000} --host 0.0.0.0
