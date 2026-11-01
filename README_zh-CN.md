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

基于 Alpine、Debian 和 Rocky Linux 构建的 Transmission 官方标准 Docker 镜像，具备灵活的初始化系统、多架构平台支持与统一的配置模式。

## 概述

Transmission 容器镜像提供：

- **标准化 Dockerfile**：遵循 OCI 规范与容器最佳实践
- **灵活的初始化入口系统**：支持自定义 entrypoint.d 启动脚本
- **一致的环境变量配置**：全发行版一致的运行时变量支持
- **多架构平台兼容**：适配广泛的硬件架构
- **用户/组权限映射**：支持 PUID/PGID 灵活处理存储权限
- **三大发行版变体**：Alpine（轻量小巧）、Debian（默认/高兼容性）、Rocky（企业级）

## 快速上手

```bash
# 拉取并运行默认 Debian 变体
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

# 或者使用 docker compose
docker compose up -d
```

## 发行版变体

### Debian（默认）

推荐用于绝大多数场景，具备广泛的软硬件兼容性与丰富的软件生态。

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

**支持架构**：amd64, arm32v7, arm64, ppc64le, riscv64, s390x

**基础镜像**：`ghcr.io/snowdreamtech/debian:13.6.0`

### Alpine

经过极限体积优化的轻量变体，占用极低，启动飞快。

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

**支持架构**：linux/386, linux/amd64, linux/arm/v6, linux/arm/v7, linux/arm64, linux/ppc64le, linux/riscv64, linux/s390x

**基础镜像**：`ghcr.io/snowdreamtech/alpine:3.24.1`

### Rocky

基于 Rocky Linux 的企业级变体，适合追求 RHEL 企业生态稳定性的生产环境。

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

**支持架构**：amd64, arm64, ppc64le, s390x

**基础镜像**：`ghcr.io/snowdreamtech/rocky:10.2.0`

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

使用 `docker buildx` 进行多架构并行构建：

```bash
# 创建并启用 buildx 构建器
docker buildx create --use --name build --node build --driver-opt network=host

# 构建 Debian 多架构镜像
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/transmission:debian \
  ./docker/debian/ \
  --push

# 构建 Alpine 多架构镜像
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/transmission:alpine \
  ./docker/alpine/ \
  --push

# 构建 Rocky 多架构镜像
docker buildx build \
  --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/transmission:rocky \
  ./docker/rocky/ \
  --push
```

## 环境变量

所有变体均支持以下通用及专属环境变量：

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `KEEPALIVE` | `1` | 保持容器持续运行（1=开启，0=关闭） |
| `CAP_NET_BIND_SERVICE` | `0` | 允许非 root 绑定 1024 以下特权端口 |
| `LANG` | `C.UTF-8` | 容器默认区域与 UTF-8 字符支持 |
| `UMASK` | `022` | 默认文件创建权限掩码 |
| `DEBUG` | `false` | 开启 entrypoint 脚本的调试日志 |
| `PGID` | `0` | 自定义运行用户的主组 ID |
| `PUID` | `0` | 自定义运行用户的用户 ID |
| `USER` | `root` | 自定义用户名 |
| `WORKDIR` | `/root` | 工作目录路径 |
| `TZ` | - | 容器时区（如 `Asia/Shanghai`、`UTC`） |
| `PEER_PORT` | `51413` | Transmission Peer BT 监听端口 |
| `RPC_PORT` | `9091` | Transmission Web RPC / UI 管理端口 |
| `RPC_USER` | - | Transmission Web 认证用户名（可选） |
| `RPC_PASS` | - | Transmission Web 认证密码（可选） |

## 目录挂载卷

| 容器内路径 | 说明 |
|------------|------|
| `/var/lib/transmission/config` | 配置文件目录（包含 `settings.json`） |
| `/var/lib/transmission/downloads` | 下载完成保存目录 |
| `/var/lib/transmission/incomplete` | 未完成下载临时缓存目录 |
| `/var/lib/transmission/torrents` | 自动监听/存放种子目录 |

## Docker Compose 示例

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

## 多镜像源支持

镜像自动构建并同步分发至全球主流镜像仓库：

- **GitHub Container Registry**: `ghcr.io/snowdreamtech/transmission`
- **DockerHub**: `snowdreamtech/transmission`

可根据网络环境从任一源拉取：

```bash
# 从 GHCR 拉取
docker pull ghcr.io/snowdreamtech/transmission:latest

# 从 DockerHub 拉取
docker pull snowdreamtech/transmission:latest
```

## 联系方式

* 邮箱：<sn0wdr1am@qq.com>
* QQ：3217680847
* QQ交流群：949022145
* 微信：sn0wdr1am

## 许可协议

MIT License
