#!/bin/bash
set -e

# Set HTTP listen address from Railway's PORT
export SQLD_HTTP_LISTEN_ADDR="0.0.0.0:${PORT:-8080}"

# Generate JWT keys if SQLD_AUTH_JWT_KEY is not set
if [ -z "$SQLD_AUTH_JWT_KEY" ]; then
    /usr/local/bin/token-gen
fi

# Call the original docker-wrapper.sh which handles:
# - Creating db directory
# - Setting permissions (chown sqld:sqld)
# - Dropping privileges (gosu sqld)
# - Running sqld via docker-entrypoint.sh
exec /usr/local/bin/docker-wrapper.sh "$@"
