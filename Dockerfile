FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV TRANSMISSION_WEB_CONTROL_VERSION 1.6.1-update1

RUN apk add --no-cache transmission-cli \
    transmission-daemon \
    && mkdir -p /var/lib/transmission/config/ \
    && mkdir -p /var/lib/transmission/downloads/ \
    && mkdir -p /var/lib/transmission/incomplete/ \
    && mkdir -p /var/lib/transmission/torrents/ \
    && chown -R  transmission:transmission /var/lib/transmission \
    && mv /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.original.html \ 
    && wget https://github.com/ronggang/transmission-web-control/archive/refs/tags/v${TRANSMISSION_WEB_CONTROL_VERSION}.tar.gz \
    && tar zxvf v${TRANSMISSION_WEB_CONTROL_VERSION}.tar.gz \ 
    && cp -rfv transmission-web-control-${TRANSMISSION_WEB_CONTROL_VERSION}/src/*  /usr/share/transmission/public_html \ 
    && rm -rfv v${TRANSMISSION_WEB_CONTROL_VERSION}.tar.gz \
    && rm -rfv transmission-web-control-${TRANSMISSION_WEB_CONTROL_VERSION}

COPY config /var/lib/transmission/config

EXPOSE 9091 51413/tcp 51413/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]