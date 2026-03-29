#!/bin/bash
# Seed the persistent volume with database files on first deploy.
# If /app/database is empty (fresh volume), copy seed data into it.
if [ -z "$(ls -A /app/database 2>/dev/null)" ]; then
    echo "📦 Seeding database volume with initial data..."
    cp -r /app/database-seed/* /app/database/
    echo "✅ Database seeded."
else
    echo "✅ Database volume already populated."
fi

exec "$@"
