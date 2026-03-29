#!/bin/bash
# Seed the persistent volume with database files on first deploy.
# Check for a known file (hedge_funds.csv) rather than emptiness,
# since Railway volumes may contain internal metadata even when fresh.
if [ ! -f /app/database/hedge_funds.csv ]; then
    echo "📦 Seeding database volume with initial data..."
    cp -r /app/database-seed/* /app/database/
    echo "✅ Database seeded."
else
    echo "✅ Database volume already populated."
fi

exec "$@"
