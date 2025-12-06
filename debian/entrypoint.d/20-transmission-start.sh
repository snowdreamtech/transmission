#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [transmission] Starting transmission..."; fi

# transmission
transmission-daemon --config-dir /var/lib/transmission/config

if [ "$DEBUG" = "true" ]; then echo "→ [transmission] Transmission started."; fi
