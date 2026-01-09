#!/bin/bash
set -e

export SQLD_HTTP_LISTEN_ADDR="0.0.0.0:${PORT:-8080}"

# Ensure data directory is owned by the sqld user (for Railway volumes)
chown -R sqld:sqld /var/lib/sqld

# Start sqld in background
gosu sqld /bin/sqld --db-path /var/lib/sqld/data.sqld "$@" &
SQLD_PID=$!

# Wait for sqld to finish its startup logs, then show credentials
sleep 3
if [ -z "$SQLD_AUTH_JWT_KEY" ]; then
    /usr/local/bin/token-gen
fi

# Wait for sqld process
wait $SQLD_PID
