# Docker Image Tags Reference

This document describes the Docker image tagging strategy for the transmission project.

## Tag Naming Convention

All images use the format: `snowdreamtech/transmission:TAG`

Where `TAG` follows these patterns:

- **Variant-specific tags**: `TAG-variant` (e.g., `nightly-alpine`, `4.1.4-alpine`)
- **Default tags** (Debian only): `TAG` (e.g., `nightly`, `latest`, `4.1.0`)

## Supported Registries

All tags are pushed to two registries:

- **DockerHub**: `snowdreamtech/transmission:TAG`
- **GitHub Container Registry**: `ghcr.io/snowdreamtech/transmission:TAG`

## Tag Scenarios

### 1. Branch Builds (dev/main)

#### Push to `dev` branch

```bash
git push origin dev
```

**Generated tags:**

```
snowdreamtech/transmission:dev-alpine
snowdreamtech/transmission:dev-debian
snowdreamtech/transmission:dev              # ← Debian (default)
snowdreamtech/transmission:dev-rocky
```

#### Push to `main` branch

```bash
git push origin main
```

**Generated tags:**

```
snowdreamtech/transmission:main-alpine
snowdreamtech/transmission:latest-alpine
snowdreamtech/transmission:main-debian
snowdreamtech/transmission:latest-debian
snowdreamtech/transmission:main             # ← Debian (default)
snowdreamtech/transmission:latest           # ← Debian (default)
snowdreamtech/transmission:main-rocky
snowdreamtech/transmission:latest-rocky
```

---

### 2. Release Tags (Semantic Versioning)

#### Alpine Release

```bash
git tag alpine-v4.1.4
git push origin alpine-v4.1.4
```

**Generated tags:**

```
snowdreamtech/transmission:4.1.4-alpine
snowdreamtech/transmission:latest-alpine
```

#### Debian Release

```bash
git tag debian-v4.1.0
git push origin debian-v4.1.0
```

**Generated tags:**

```
snowdreamtech/transmission:4.1.0-debian
snowdreamtech/transmission:latest-debian
snowdreamtech/transmission:4.1.0           # ← Debian (default)
snowdreamtech/transmission:latest          # ← Debian (default)
```

#### Rocky Release

```bash
git tag rocky-v4.1.4
git push origin rocky-v4.1.4
```

**Generated tags:**

```
snowdreamtech/transmission:4.1.4-rocky
snowdreamtech/transmission:latest-rocky
```

---

### 3. Nightly Builds (Scheduled)

**Trigger:** Automatically every day at 17:00 UTC

**Generated tags:**

```
# Alpine
snowdreamtech/transmission:nightly-alpine
snowdreamtech/transmission:20261101-alpine

# Debian (with default tags)
snowdreamtech/transmission:nightly-debian
snowdreamtech/transmission:20261101-debian
snowdreamtech/transmission:nightly          # ← Debian (default)
snowdreamtech/transmission:20261101         # ← Debian (default)

# Rocky
snowdreamtech/transmission:nightly-rocky
snowdreamtech/transmission:20261101-rocky
```

---

## Tag Priority

Tags are generated with the following priority (higher number = higher priority):

| Priority | Type | Example Tags | Trigger |
|----------|------|--------------|---------|
| 1000 | Nightly | `nightly`, `nightly-alpine` | Schedule |
| 900 | Date | `20261101`, `20261101-alpine` | Schedule |
| 800 | Version | `4.1.4-alpine`, `4.1.0` | Tag push |
| 600 | Branch | `dev-alpine`, `main-debian` | Branch push |
| 200 | Latest | `latest`, `latest-alpine` | Main/Tag |

---

## Default Variant (Debian)

Debian is designated as the **default variant** (`is_latest: true`), which means:

✅ **Debian gets BOTH suffixed AND unsuffixed tags:**

```
snowdreamtech/transmission:nightly-debian   # Variant-specific
snowdreamtech/transmission:nightly          # Default (no suffix)

snowdreamtech/transmission:4.1.0-debian    # Variant-specific
snowdreamtech/transmission:4.1.0           # Default (no suffix)

snowdreamtech/transmission:latest-debian    # Variant-specific
snowdreamtech/transmission:latest           # Default (no suffix)
```

❌ **Alpine and Rocky get ONLY suffixed tags:**

```
snowdreamtech/transmission:nightly-alpine   # Variant-specific only
snowdreamtech/transmission:nightly-rocky    # Variant-specific only
```

---

## Usage Examples

### Pull the latest Debian image (default)

```bash
docker pull snowdreamtech/transmission:latest
# or
docker pull snowdreamtech/transmission:latest-debian
```

### Pull the latest Alpine image

```bash
docker pull snowdreamtech/transmission:latest-alpine
```

### Pull the latest Rocky image

```bash
docker pull snowdreamtech/transmission:latest-rocky
```

### Pull a specific version

```bash
# Alpine 4.1.4
docker pull snowdreamtech/transmission:4.1.4-alpine

# Debian 4.1.0 (two ways)
docker pull snowdreamtech/transmission:4.1.0-debian
docker pull snowdreamtech/transmission:4.1.0

# Rocky 4.1.4
docker pull snowdreamtech/transmission:4.1.4-rocky
```

### Pull nightly builds

```bash
# Alpine nightly
docker pull snowdreamtech/transmission:nightly-alpine

# Debian nightly (two ways)
docker pull snowdreamtech/transmission:nightly-debian
docker pull snowdreamtech/transmission:nightly

# Rocky nightly
docker pull snowdreamtech/transmission:nightly-rocky
```

---

## Tag Lifecycle

### Development Flow

```
1. Push to dev → transmission:dev-alpine, transmission:dev-debian, transmission:dev, transmission:dev-rocky
2. Push to main → transmission:main-alpine, transmission:latest-alpine, transmission:main-debian, transmission:latest-debian, transmission:main, transmission:latest, transmission:main-rocky, transmission:latest-rocky
3. Create tag → transmission:VERSION-variant, transmission:latest-variant (+ unsuffixed for Debian)
```

### Release Flow (with Release Please)

```
1. Merge PR to main → Release Please creates release PR
2. Merge release PR → Release Please creates tags (alpine-vX.Y.Z, debian-vX.Y.Z, rocky-vX.Y.Z)
3. Tag push triggers build → Images published with version tags
```

---

## Matrix Configuration

The workflow uses a matrix strategy with three variants:

```yaml
matrix:
  include:
    - variant: alpine
      version: "4.1.4"
      is_latest: false

    - variant: debian
      version: "4.1.0"
      is_latest: true    # ← Default variant

    - variant: rocky
      version: "4.1.4"
      is_latest: false
```

Only the variant with `is_latest: true` receives unsuffixed tags.

---

## Metadata Action Configuration

The key configuration that enables this tagging strategy:

```yaml
images: |
  name=ghcr.io/snowdreamtech/transmission,enable=true
  name=snowdreamtech/transmission,enable=true
flavor: |
  latest=false
  prefix=
  suffix=-${{ matrix.variant }}  # ← Adds variant suffix to all tags
```

For Debian (is_latest), additional rules generate unsuffixed tags:

```yaml
type=raw,enable=${{ matrix.is_latest }},priority=1000,prefix=,suffix=,pattern=nightly
```

This creates both `nightly-debian` (from flavor suffix) and `nightly` (from this rule).
