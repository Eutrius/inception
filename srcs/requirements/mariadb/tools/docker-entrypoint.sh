#!/bin/bash
set -e

INIT_MARKER="/var/lib/mysql/.mariadb_initialized"

if [ ! -f "$INIT_MARKER" ]; then
export MARIA_PASSWORD=$(cat /run/secrets/maria_password)
export MARIA_ROOT_PASSWORD=$(cat /run/secrets/maria_root_password)
export MARIA_IP="${WP_HOST%%:*}"
export MARIA_PORT="${WP_HOST#*:}"

mariadbd-safe &

until nc -z $MARIA_IP $MARIA_PORT; do
    echo "waiting for mariadb"
    sleep 1
done

echo "set root password and auth plugin"
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MARIA_ROOT_PASSWORD}'); FLUSH PRIVILEGES;"

echo "create database and user"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MARIA_DB_NAME}\`;"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MARIA_USER}'@'%' IDENTIFIED BY '${MARIA_PASSWORD}';"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MARIA_DB_NAME}\`.* TO '${MARIA_USER}'@'%';"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "shutdown for clean restart"
mariadb-admin -u root -p"${MARIA_ROOT_PASSWORD}" shutdown

touch "$INIT_MARKER"
else
    echo "database already exist"
fi

echo "starting mariadb"
exec "$@"
