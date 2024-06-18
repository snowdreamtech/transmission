#!/bin/sh
set -e

# transmission
transmission-daemon --foreground --config-dir /var/lib/transmission/config

# exec commands
exec "$@"
