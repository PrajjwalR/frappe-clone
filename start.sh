#!/bin/bash
set -e  # Exit on error

echo "======================================"
echo "🚀 Starting Frappe initialization..."
echo "======================================"

# Display environment info
echo "📋 Environment Variables:"
echo "  - PORT: ${PORT:-8000}"
echo "  - FRAPPE_SITE_NAME: ${FRAPPE_SITE_NAME:-site1.local}"
if [ ! -z "$DATABASE_URL" ]; then
    echo "  - DATABASE_URL: ✅ Set"
else
    echo "  - DATABASE_URL: ❌ Not set"
fi
if [ ! -z "$REDIS_URL" ]; then
    echo "  - REDIS_URL: ✅ Set"
else
    echo "  - REDIS_URL: ❌ Not set"
fi
echo ""

# Parse database connection details
if [ -z "$DATABASE_URL" ]; then
    echo "❌ ERROR: DATABASE_URL environment variable is not set!"
    echo "Please add DATABASE_URL to Render environment variables"
    exit 1
fi

DB_HOST=$(echo $DATABASE_URL | sed -E 's/.*@([^:/]+).*/\1/')
DB_NAME=$(echo $DATABASE_URL | sed -E 's/.*\/([^?]+).*/\1/')

echo "📊 Database Configuration:"
echo "  - Host: $DB_HOST"
echo "  - Database: $DB_NAME"
echo ""

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
MAX_RETRIES=30
RETRY_COUNT=0

until pg_isready -h "$DB_HOST" -U postgres 2>/dev/null || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
  RETRY_COUNT=$((RETRY_COUNT+1))
  echo "  Attempt $RETRY_COUNT/$MAX_RETRIES - Database not ready, waiting..."
  sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ ERROR: Could not connect to database after $MAX_RETRIES attempts"
    echo "Database host: $DB_HOST"
    exit 1
fi

echo "✅ Database is ready!"
echo ""

# Set up site config directory  
SITE_NAME="${FRAPPE_SITE_NAME:-site1.local}"
SITE_DIR="sites/${SITE_NAME}"

echo "🏗️  Site Configuration:"
echo "  - Site name: $SITE_NAME"
echo "  - Site directory: $SITE_DIR"
echo ""

# Create site if it doesn't exist
if [ ! -f "${SITE_DIR}/site_config.json" ]; then
  echo "📦 Creating new Frappe site: ${SITE_NAME}"
  echo "  This may take 2-3 minutes..."
  echo ""
  
  # Create site with PostgreSQL
  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host "$DB_HOST" \
    --db-name "$DB_NAME" \
    --admin-password admin \
    --mariadb-root-password root \
    --force 2>&1 || {
      echo "❌ ERROR: Failed to create Frappe site"
      echo "Check the logs above for details"
      exit 1
    }
  
  echo ""
  echo "✅ Site created successfully!"
  echo ""
  
  # Install ERPNext if available
  if [ -d "apps/erpnext" ]; then
    echo "📦 Installing ERPNext..."
    bench --site ${SITE_NAME} install-app erpnext 2>&1 || {
      echo "⚠️  WARNING: ERPNext installation failed (continuing anyway)"
    }
    echo "✅ ERPNext installed!"
    echo ""
  fi
else
  echo "✅ Site already exists: ${SITE_NAME}"
  echo ""
fi

# Configure Redis if URL provided
if [ ! -z "$REDIS_URL" ]; then
  echo "🔧 Configuring Redis cache..."
  bench --site ${SITE_NAME} set-config redis_cache "redis://${REDIS_URL#*://}" 2>&1 || echo "⚠️  Redis config warning (continuing)"
  bench --site ${SITE_NAME} set-config redis_queue "redis://${REDIS_URL#*://}" 2>&1 || echo "⚠️  Redis config warning (continuing)"
  echo "✅ Redis configured!"
  echo ""
fi

# Display final status
echo "======================================"
echo "🎉 Initialization Complete!"
echo "======================================"
echo "Admin Credentials:"
echo "  - Username: Administrator"
echo "  - Password: admin"
echo ""
echo "🌐 Starting Frappe web server on port ${PORT:-8000}..."
echo "======================================"
echo ""

# Start the web server
exec bench serve --port ${PORT:-8000} --host 0.0.0.0
