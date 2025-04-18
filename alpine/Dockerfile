FROM snowdreamtech/alpine:3.21.3

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Transmission Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Transmission on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/transmission" \
    org.opencontainers.image.base.name="snowdreamtech/transmission:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/transmission" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="4.0.6" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/transmission"

# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 

ENV TRANSMISSION_VERSION=4.0.6-r0 \
    PEER_PORT= \
    RPC_PORT= \
    RPC_USER="" \
    RPC_PASS=""

ARG GID=1000 \
    UID=1000  \
    USER=transmission \
    WORKDIR=/var/lib/transmission

# Create a user with UID and GID
RUN if [ "${USER}" != "root" ]; then \
    addgroup -g ${GID} ${USER}; \
    adduser -h ${WORKDIR} -u ${UID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    apk add --no-cache libcap; \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi

COPY config /var/lib/transmission/config

RUN apk add --no-cache transmission-cli=${TRANSMISSION_VERSION} \
    transmission-daemon=${TRANSMISSION_VERSION} \
    && mkdir -p /var/lib/transmission/config/  \
    && mkdir -p /var/lib/transmission/downloads/  \
    && mkdir -p /var/lib/transmission/incomplete/  \
    && mkdir -p /var/lib/transmission/torrents/  \
    && find / -name "*transmission*" -exec chown -Rv ${USER}:${USER} {} \; 

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 9091 51413/tcp 51413/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]