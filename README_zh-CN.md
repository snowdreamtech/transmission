# Transmission

![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/transmission)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/transmission/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/transmission)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/transmission)

Docker Transmission 模板，提供标准化的容器基础，具有灵活的入口点系统、多架构支持以及跨 Alpine、Debian 和 Rocky Linux 发行版的一致配置模式。

## 概述

Docker Transmission 模板作为构建容器化应用程序的基础起点。它提供：

- **标准化的 Dockerfile**，包含 OCI 注释和最佳实践
- **灵活的入口点系统**，支持自定义初始化脚本
- **一致的环境变量配置**，适用于所有变体
- **多架构支持**，适用于多样化的硬件平台
- **用户/组管理**，支持 PUID/PGID 进行权限处理
- **三种发行版变体**：Alpine（轻量级）、Debian（默认/广泛兼容）、Rocky（企业级）

## 快速开始

```bash
# 拉取并运行默认的 Debian 变体
docker pull snowdreamtech/transmission:debian
docker run -d --name=transmission -e TZ=Asia/Shanghai snowdreamtech/transmission:debian

# 或使用 docker-compose
docker-compose up -d
```

## 发行版变体

### Debian（默认）

推荐用于大多数用例的变体，提供广泛的兼容性和丰富的软件包可用性。

```bash
docker run -d \
  --name=transmission \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:debian
```

**支持的架构**：386、amd64、arm32v7、arm64

**基础镜像**：`ghcr.io/snowdreamtech/debian:13.6.0`

### Alpine

轻量级变体，针对最小镜像大小和快速启动时间进行了优化。

```bash
docker run -d \
  --name=transmission \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:alpine
```

**支持的架构**：i386、amd64、arm32v6、arm32v7、arm64、ppc64le、riscv64、s390x

**基础镜像**：`ghcr.io/snowdreamtech/alpine:3.24.1`

<!--
### Rocky

面向企业的变体，基于 Rocky Linux，非常适合需要 RHEL 兼容性的生产环境。

```bash
docker run -d \
  --name=transmission \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/transmission:rocky
```

**支持的架构**：amd64、arm64、ppc64le、s390x

**基础镜像**：`ghcr.io/snowdreamtech/rocky:10.2.0`
-->

## 构建说明

### 单架构构建

```bash
# 构建 Debian 变体
docker build -t snowdreamtech/transmission:debian ./docker/debian/

# 构建 Alpine 变体
docker build -t snowdreamtech/transmission:alpine ./docker/alpine/

# 构建 Rocky 变体
docker build -t snowdreamtech/transmission:rocky ./docker/rocky/
```

### 多架构构建

使用 `docker buildx` 为多个架构构建镜像：

```bash
# 创建并使用 buildx 构建器
docker buildx create --use --name build --node build --driver-opt network=host

# 为多个架构构建 Debian
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v7,linux/arm64 \
  -t snowdreamtech/transmission:debian \
  ./docker/debian/ \
  --push

# 为多个架构构建 Alpine
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/transmission:alpine \
  ./docker/alpine/ \
  --push

# 为多个架构构建 Rocky
docker buildx build \
  --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/transmission:rocky \
  ./docker/rocky/ \
  --push
```

## 环境变量

所有变体都支持以下环境变量进行运行时配置：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `KEEPALIVE` | `0` | 保持容器运行（1=启用，0=禁用）|
| `CAP_NET_BIND_SERVICE` | `0` | 启用绑定到特权端口（<1024）|
| `LANG` | `C.UTF-8` | UTF-8 字符支持的区域设置 |
| `UMASK` | `022` | 默认文件创建掩码 |
| `DEBUG` | `false` | 在入口点脚本中启用调试输出 |
| `PGID` | `0` | 自定义用户创建的主组 ID |
| `PUID` | `0` | 自定义用户创建的用户 ID |
| `USER` | `root` | 自定义用户创建的用户名 |
| `WORKDIR` | `/root` | 工作目录路径 |
| `TZ` | - | 时区（例如 `Asia/Shanghai`、`America/New_York`）|
| `PEER_PORT` | `51413` | Transmission 节点监听端口 |
| `RPC_PORT` | `9091` | Transmission Web RPC 端口 |
| `RPC_USER` | - | Transmission Web RPC 用户名 |
| `RPC_PASS` | - | Transmission Web RPC 密码 |

**Debian 特定**：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian 软件包安装模式 |

### 自定义用户创建

在构建时创建具有特定 UID/GID 的非 root 用户：

```bash
docker build \
  --build-arg PUID=1000 \
  --build-arg PGID=1000 \
  --build-arg USER=appuser \
  -t snowdreamtech/transmission:debian-custom \
  ./docker/debian/
```

或在运行时（需要重新构建镜像）：

```bash
docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=appuser \
  snowdreamtech/transmission:debian
```

**注意**：仅当 `PUID≠0`、`PGID≠0` 且 `USER≠root` 时才会创建用户。

## 语义化版本标签

镜像遵循语义化版本控制，格式为：`{major}.{minor}.{patch}-{variant}`

示例：

- `snowdreamtech/transmission:<version>-debian`
- `snowdreamtech/transmission:<version>-alpine`
- `snowdreamtech/transmission:<version>-rocky`

此格式允许：

- **完整版本固定**：`<version>-debian`（精确版本）
- **变体最新标签**：`latest-debian`（跟踪 Debian 最新版本）
- **全局最新标签**：`latest`（跟踪最新版本，默认指向 Debian）

## 架构支持

每个发行版变体都支持多个 CPU 架构，可在多样化的硬件平台上部署：

| 变体 | 架构 |
|---------|---------------|
| **Debian** | 386、amd64、arm32v7、arm64 |
| **Alpine** | i386、amd64、arm32v6、arm32v7、arm64、ppc64le、riscv64、s390x |
| **Rocky** | amd64、arm64、ppc64le、s390x |

Docker 在拉取镜像时会自动为您的平台选择适当的架构。

## 联系方式

* Email: <sn0wdr1am@qq.com>
* QQ: 3217680847
* QQ群: 949022145
* WeChat/微信群: sn0wdr1am

## 许可证

MIT
