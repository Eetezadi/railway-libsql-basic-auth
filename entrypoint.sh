#!/bin/bash
# Set defaults if variables are missing
USER=${DB_USER:-root}
PASS=${DB_PASSWORD}

if [ -n "$PASS" ]; then
    # Create the 'user:pass' string and base64 encode it
    AUTH_STR=$(echo -n "$USER:$PASS" | base64 | tr -d '\n')
    export SQLD_HTTP_AUTH="basic:$AUTH_STR"
    echo "Auth configured for user: $USER"
else
    echo "WARNING: No DB_PASSWORD found. Server is PUBLIC."
fi

# Start the libSQL server
exec /bin/sqld "$@"
