# Base Image (Rocky Variant)
# Extends snowdreamtech/rocky with additional tooling and configuration.

FROM ghcr.io/snowdreamtech/rocky:10.2.0

# Build-time Configuration
ARG BUILDTIME \
    VERSION \
    REVISION \
    KEEPALIVE=1 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PASSWORDLESS_SUDO=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root \
    TRANSMISSION_VERSION="4.1.3"

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="transmission Image Based On rocky" \
    org.opencontainers.image.description="Docker Images for transmission on rocky. (amd64, arm64, ppc64le, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/transmission" \
    org.opencontainers.image.base.name="ghcr.io/snowdreamtech/rocky:10.2.0" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/transmission" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/transmission"

# Runtime Environment Configuration
ENV KEEPALIVE=${KEEPALIVE} \
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PASSWORDLESS_SUDO=${PASSWORDLESS_SUDO} \
    PGID=${PGID} \
    PUID=${PUID} \
    USER=${USER} \
    WORKDIR=${WORKDIR} \
    TRANSMISSION_VERSION=${TRANSMISSION_VERSION} \
    PEER_PORT=51413 \
    RPC_PORT=9091 \
    RPC_USER="" \
    RPC_PASS=""

RUN echo "ip_resolve=4" >> /etc/dnf/dnf.conf \
    && dnf -y --allowerasing --setopt=*.skip_if_unavailable=true update \
    && dnf -y --allowerasing --setopt=*.skip_if_unavailable=true install --enablerepo=crb epel-release \
    && dnf -y --allowerasing --setopt=*.skip_if_unavailable=true install --enablerepo=crb \
    transmission-cli-${TRANSMISSION_VERSION}* \
    transmission-daemon-${TRANSMISSION_VERSION}* \
    && mkdir -p /var/lib/transmission/config/ \
    && mkdir -p /var/lib/transmission/downloads/ \
    && mkdir -p /var/lib/transmission/incomplete/ \
    && mkdir -p /var/lib/transmission/torrents/ \
    && dnf -y --allowerasing clean all \
    && rm -rf /var/cache/dnf /tmp/* /var/tmp/*

COPY config /var/lib/transmission/config

# Container Orchestration Files
COPY entrypoint.d /usr/local/bin/entrypoint.d

RUN chmod +x /usr/local/bin/entrypoint.d/*

EXPOSE 9091 51413/tcp 51413/udp

# Standard Healthcheck (Verification of core system responsiveness)
HEALTHCHECK NONE

# Process Execution
USER root
WORKDIR /root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]
