# Transmission

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/transmission/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/transmission/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/transmission/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/transmission/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/transmission/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/transmission/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/transmission/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/transmission)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/transmission/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/transmission)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/transmission)

[English](README.md) | [简体中文](README_zh-CN.md)

Docker image for Transmission providing standardized container foundations with flexible entrypoint systems, multi-architecture support, and consistent configuration patterns across Alpine, Debian, and Rocky Linux distributions.

## Overview

The Transmission container provides:

- **Standardized Dockerfiles** with OCI annotations and best practices
- **Flexible entrypoint system** supporting custom initialization scripts
- **Consistent environment variable configuration** across all variants
- **Multi-architecture support** for diverse hardware platforms
- **User/group management** with PUID/PGID support for permission handling
- **Three distribution variants**: Alpine (lightweight), Debian (default/widely-compatible), Rocky (enterprise)

## Quick Start

```bash
# Pull and run the default Debian variant
docker pull snowdreamtech/transmission:debian
docker run -d \
  --name=transmission \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/config:/var/lib/transmission/config \
  -v /path/to/downloads:/var/lib/transmission/downloads \
  -e TZ=Asia/Shanghai \
  snowdreamtech/transmission:debian

# Or use docker compose
docker compose up -d
```

## Distribution Variants

### Debian (Default)

The recommended variant for most use cases, providing wide compatibility and extensive package availability.

```bash
docker run -d \
  --name=transmission \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:debian
```

**Supported Architectures**: amd64, arm32v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `ghcr.io/snowdreamtech/debian:13.6.0`

### Alpine

Lightweight variant optimized for minimal image size and fast startup times.

```bash
docker run -d \
  --name=transmission \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:alpine
```

**Supported Architectures**: linux/386, linux/amd64, linux/arm/v6, linux/arm/v7, linux/arm64, linux/ppc64le, linux/riscv64, linux/s390x

**Base Image**: `ghcr.io/snowdreamtech/alpine:3.24.1`

### Rocky

Enterprise-focused variant based on Rocky Linux, ideal for production environments requiring RHEL compatibility.

```bash
docker run -d \
  --name=transmission \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:rocky
```

**Supported Architectures**: amd64, arm64, ppc64le, s390x

**Base Image**: `ghcr.io/snowdreamtech/rocky:10.2.0`

## Build Instructions

### Single Architecture Build

```bash
# Build Debian variant
docker build -t snowdreamtech/transmission:debian ./docker/debian/

# Build Alpine variant
docker build -t snowdreamtech/transmission:alpine ./docker/alpine/

# Build Rocky variant
docker build -t snowdreamtech/transmission:rocky ./docker/rocky/
```

### Multi-Architecture Build

Build images for multiple architectures using `docker buildx`:

```bash
# Create and use a buildx builder
docker buildx create --use --name build --node build --driver-opt network=host

# Build Debian for multiple architectures
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/transmission:debian \
  ./docker/debian/ \
  --push

# Build Alpine for multiple architectures
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/transmission:alpine \
  ./docker/alpine/ \
  --push

# Build Rocky for multiple architectures
docker buildx build \
  --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/transmission:rocky \
  ./docker/rocky/ \
  --push
```

## Environment Variables

All variants support the following environment variables for runtime configuration:

| Variable | Default | Description |
|----------|---------|-------------|
| `KEEPALIVE` | `1` | Keep container running (1=enabled, 0=disabled) |
| `CAP_NET_BIND_SERVICE` | `0` | Enable binding to privileged ports (<1024) |
| `LANG` | `C.UTF-8` | Locale setting for UTF-8 character support |
| `UMASK` | `022` | Default file creation mask |
| `DEBUG` | `false` | Enable debug output in entrypoint scripts |
| `PGID` | `0` | Primary group ID for custom user creation |
| `PUID` | `0` | User ID for custom user creation |
| `USER` | `root` | Username for custom user creation |
| `WORKDIR` | `/root` | Working directory path |
| `TZ` | - | Timezone (e.g., `Asia/Shanghai`, `America/New_York`) |
| `PEER_PORT` | `51413` | Transmission peer listening port |
| `RPC_PORT` | `9091` | Transmission Web RPC port |
| `RPC_USER` | - | Transmission Web RPC username (optional) |
| `RPC_PASS` | - | Transmission Web RPC password (optional) |

## Volume Mounts

| Container Path | Description |
|----------------|-------------|
| `/var/lib/transmission/config` | Configuration directory containing `settings.json` |
| `/var/lib/transmission/downloads` | Completed download destination |
| `/var/lib/transmission/incomplete` | Incomplete download cache |
| `/var/lib/transmission/torrents` | Watched / stored torrent files |

## Docker Compose Examples

```yaml
services:
  transmission:
    image: snowdreamtech/transmission:debian
    container_name: transmission
    environment:
      - TZ=Asia/Shanghai
      - RPC_USER=admin
      - RPC_PASS=adminpassword
      - PEER_PORT=51413
      - RPC_PORT=9091
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    volumes:
      - ./config:/var/lib/transmission/config
      - ./downloads:/var/lib/transmission/downloads
      - ./incomplete:/var/lib/transmission/incomplete
      - ./torrents:/var/lib/transmission/torrents
    restart: unless-stopped
```

## Multi-Registry Support

Images are automatically built and published to multiple container registries:

- **GitHub Container Registry**: `ghcr.io/snowdreamtech/transmission`
- **DockerHub**: `snowdreamtech/transmission`

Pull from your preferred registry:

```bash
# Pull from GHCR
docker pull ghcr.io/snowdreamtech/transmission:latest

# Pull from DockerHub
docker pull snowdreamtech/transmission:latest
```

## Contact

* Email: <sn0wdr1am@qq.com>
* QQ: 3217680847
* QQ Group: 949022145
* WeChat: sn0wdr1am

## License

MIT
