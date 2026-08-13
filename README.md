# Transmission

![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/transmission)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/transmission/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/transmission)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/transmission)

Docker Transmission template providing standardized container foundations with flexible entrypoint systems, multi-architecture support, and consistent configuration patterns across Alpine, Debian, and Rocky Linux distributions.

## Overview

The Docker Transmission template serves as a foundational starting point for building containerized applications. It provides:

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
docker run -d --name=transmission -e TZ=Asia/Shanghai snowdreamtech/transmission:debian

# Or use docker-compose
docker-compose up -d
```

## Distribution Variants

### Debian (Default)

The recommended variant for most use cases, providing wide compatibility and extensive package availability.

```bash
docker run -d \
  --name=transmission \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:debian
```

**Supported Architectures**: 386, amd64, arm32v7, arm64

**Base Image**: `ghcr.io/snowdreamtech/debian:13.6.0`

### Alpine

Lightweight variant optimized for minimal image size and fast startup times.

```bash
docker run -d \
  --name=transmission \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:alpine
```

**Supported Architectures**: i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `ghcr.io/snowdreamtech/alpine:3.24.1`

### Rocky

Enterprise-focused variant based on Rocky Linux, ideal for production environments requiring RHEL compatibility.

```bash
docker run -d \
  --name=transmission \
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
  --platform=linux/386,linux/amd64,linux/arm/v7,linux/arm64 \
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
| `KEEPALIVE` | `0` | Keep container running (1=enabled, 0=disabled) |
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
| `RPC_USER` | - | Transmission Web RPC username |
| `RPC_PASS` | - | Transmission Web RPC password |

**Debian-specific**:

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian package installation mode |

### Custom User Creation

Create a non-root user with specific UID/GID at build time:

```bash
docker build \
  --build-arg PUID=1000 \
  --build-arg PGID=1000 \
  --build-arg USER=appuser \
  -t snowdreamtech/transmission:debian-custom \
  ./docker/debian/
```

Or at runtime (requires rebuilding the image):

```bash
docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=appuser \
  snowdreamtech/transmission:debian
```

**Note**: User creation only occurs when `PUID≠0`, `PGID≠0`, and `USER≠root`.

## Docker Compose Examples

### Simple Configuration

```yaml
services:
  transmission:
    image: snowdreamtech/transmission:debian
    container_name: transmission
    environment:
      - TZ=Asia/Shanghai
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    restart: unless-stopped
```

## Semantic Versioning Tags

Images follow semantic versioning with the format: `{major}.{minor}.{patch}-{variant}`

Examples:

- `snowdreamtech/transmission:<version>-debian`
- `snowdreamtech/transmission:<version>-alpine`
- `snowdreamtech/transmission:<version>-rocky`

This format allows:

- **Full version pinning**: `<version>-debian` (exact version)
- **Variant latest tag**: `latest-debian` (tracks most recent release for Debian)
- **Global latest tag**: `latest` (tracks most recent release, defaults to Debian)

## Architecture Support

Each distribution variant supports multiple CPU architectures for deployment across diverse hardware platforms:

| Variant | Architectures |
|---------|---------------|
| **Debian** | 386, amd64, arm32v7, arm64 |
| **Alpine** | i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x |
| **Rocky** | amd64, arm64, ppc64le, s390x |

Docker automatically selects the appropriate architecture for your platform when pulling images.

## Contact

* Email: <sn0wdr1am@qq.com>
* QQ: 3217680847
* QQ群: 949022145
* WeChat/微信群: sn0wdr1am

## License

MIT
