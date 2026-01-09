FROM golang:1.25-alpine AS token-compiler
WORKDIR /app
COPY main.go .
RUN go mod init token-gen && \
    go get github.com/golang-jwt/jwt/v5 && \
    go build -o /token-gen main.go

# Final Database Stage
FROM ghcr.io/tursodatabase/libsql-server:v0.24.33

USER root
RUN apk add --no-cache ca-certificates

COPY --from=token-compiler /token-gen /usr/local/bin/token-gen

RUN mkdir -p /var/lib/sqld
EXPOSE 8080

STOPSIGNAL SIGINT

CMD sh -c '\
    if [ -z "$SQLD_AUTH_JWT_KEY" ]; then \
        token-gen; \
    fi; \
    sqld --http-listen-addr 0.0.0.0:${PORT:-8080} --db-path /var/lib/sqld/data.sqld'