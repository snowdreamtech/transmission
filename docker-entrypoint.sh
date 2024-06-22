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

# set RPC_PORT
if [ -n "${RPC_PORT}" ]; then
    sed -i "s/\"rpc-port.*/\"rpc-port\"                             : ${RPC_PORT},/g" /var/lib/transmission/config/settings.json
fi

# set PEER_PORT
if [ -n "${PEER_PORT}" ]; then
    sed -i "s/\"peer-port.*/\"peer-port\"                            : ${PEER_PORT},/g" /var/lib/transmission/config/settings.json
fi

# flood
flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --trurl "http://localhost:${RPC_PORT}/transmission/rpc" --truser "${RPC_USER}" --trpass "${RPC_PASS}" > /dev/null 2>&1 &

# transmission
transmission-daemon --foreground --config-dir /var/lib/transmission/config

# exec commands
exec "$@"