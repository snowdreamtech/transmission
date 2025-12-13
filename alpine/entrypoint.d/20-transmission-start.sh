#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [transmission] Starting transmission..."; fi

# transmission
transmission-daemon --config-dir /var/lib/transmission/config

# flood
if [ "${FLOOD_AUTH}" = "default" ]; then
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth default >/dev/null 2>&1
else
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --trurl "http://localhost:${RPC_PORT}/transmission/rpc" --truser "${RPC_USER}" --trpass "${RPC_PASS}" >/dev/null 2>&1 &
fi

if [ "$DEBUG" = "true" ]; then echo "→ [transmission] Transmission started."; fi
