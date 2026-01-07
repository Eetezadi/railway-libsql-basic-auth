#!/bin/bash
set -e

# 1. Configuration
USER_NAME="root"
PASS=${DB_PASSWORD}
export SQLD_HTTP_LISTEN_ADDR="0.0.0.0:${PORT:-8080}"

# 2. Fix Permissions at Runtime
# Railway mounts volumes as root. We force them to be owned by sqld (UID 1000).
mkdir -p /var/lib/sqld
chown -R sqld:sqld /var/lib/sqld

# 3. Auth Logic
if [ -n "$PASS" ]; then
    AUTH_STR=$(echo -n "$USER_NAME:$PASS" | base64 | tr -d '\n')
    export SQLD_HTTP_AUTH="basic:$AUTH_STR"
    echo "Auth configured for user: $USER_NAME"
fi

echo "Permissions fixed. Starting libSQL as 'sqld' user..."

# 4. Use gosu to drop from root to the 'sqld' user (UID 1000)
# This preserves environment variables like SQLD_HTTP_AUTH
exec gosu sqld /bin/sqld --db-path /var/lib/sqld/data.sqld "$@"
