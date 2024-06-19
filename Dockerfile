FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV FLOOD_PORT=3000 \
    PEER_PORT=51413 \
    RPC_PORT=9091 \
    RPC_USER="" \
    RPC_PASS=""

RUN apk add --no-cache nodejs \
    npm \
    transmission-cli \
    transmission-daemon \
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