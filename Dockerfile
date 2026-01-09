FROM golang:1.25-alpine AS token-compiler
WORKDIR /app
COPY main.go .
RUN go mod init token-gen && \
    go get github.com/golang-jwt/jwt/v5 && \
    go build -o /token-gen main.go

# Final Database Stage
FROM ghcr.io/tursodatabase/libsql-server:v0.24.33

COPY --from=token-compiler /token-gen /usr/local/bin/token-gen
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set db path for Railway volume mount
ENV SQLD_DB_PATH=/var/lib/sqld/data.sqld

EXPOSE 8080
STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/sqld"]