FROM ghcr.io/tursodatabase/libsql-server:latest

USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
USER sqld

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
