FROM golang:1.25-alpine AS token-compiler
WORKDIR /app
COPY main.go .
RUN go mod init token-gen && \
    go get github.com/golang-jwt/jwt/v5 && \
    go build -o /token-gen main.go

# Final Database Stage
FROM ghcr.io/tursodatabase/libsql-server:v0.24.33

USER root
# Install gosu for privilege dropping and clean up cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates gosu && \
    rm -rf /var/lib/apt/lists/*

COPY --from=token-compiler /token-gen /usr/local/bin/token-gen
RUN chmod +x /usr/local/bin/token-gen

RUN mkdir -p /var/lib/sqld
EXPOSE 8080

STOPSIGNAL SIGINT

CMD ["sh", "-c", "\
    export SQLD_HTTP_LISTEN_ADDR=0.0.0.0:${PORT:-8080}; \
    if [ -z \"$SQLD_AUTH_JWT_KEY\" ]; then token-gen; fi; \
    chown -R sqld:sqld /var/lib/sqld; \
    exec gosu sqld /bin/sqld --db-path /var/lib/sqld/data.sqld \
"]