#!/bin/bash
set -e

export REDIS_PASSWORD=$(cat /run/secrets/redis_password)

if grep -qE '^(requirepass|user default)' /etc/redis/redis.conf; then
    sed -i -E "s/^(requirepass|user default).*/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
  else
    echo "requirepass $REDIS_PASSWORD" >> /etc/redis/redis.conf
fi
echo "starting redis server"
exec "$@"
