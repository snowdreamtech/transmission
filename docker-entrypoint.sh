#!/bin/sh
set -e

# set RPC_USER And RPC_PASS
if [ -n "${RPC_USER}" ] && [ -n "${RPC_PASS}" ]; then
    sed -i "s/\"rpc-authentication-required.*/\"rpc-authentication-required\"          : true,/g" /var/lib/transmission/config/settings.json
    sed -i "s/\"rpc-username.*/\"rpc-username\"                         : \"${RPC_USER}\",/g" /var/lib/transmission/config/settings.json
    sed -i "s/\"rpc-password.*/\"rpc-password\"                         : \"${RPC_PASS}\",/g" /var/lib/transmission/config/settings.json
else
    sed -i "s/\"rpc-authentication-required.*/\"rpc-authentication-required\"          : false,/g" /var/lib/transmission/config/settings.json
fi

# transmission
transmission-daemon --foreground --config-dir /var/lib/transmission/config

# exec commands
exec "$@"
