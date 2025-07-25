#!/bin/bash
set -e

mkdir -p /etc/ssl/private /etc/ssl/certs
if [ ! -f /etc/ssl/certs/nginx.crt ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx.key \
        -out /etc/ssl/certs/nginx.crt \
        -subj "/C=IT/ST=Lazio/L=Rome/O=42Roma/CN=jyriarte.42.fr"
fi

echo "starting nginx"
exec "$@"
