FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV FLOOD_PORT=3000 \
    PEER_PORT=51413 \
    RPC_PORT=9091 \
    RPC_USER="" \
    RPC_PASS=""

RUN apk add --no-cache nodejs \
    npm \
    transmission-cli=4.0.5-r2 \
    transmission-daemon=4.0.5-r2 \
    && mkdir -p /var/lib/transmission/config/  \
    && mkdir -p /var/lib/transmission/downloads/  \
    && mkdir -p /var/lib/transmission/incomplete/  \
    && mkdir -p /var/lib/transmission/torrents/  \
    && chown -R  transmission:transmission /var/lib/transmission \
    && npm install --global flood

COPY config /var/lib/transmission/config

EXPOSE 3000 9091 51413/tcp 51413/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]