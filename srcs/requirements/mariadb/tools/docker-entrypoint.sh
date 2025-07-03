#!/bin/bash
set -e

export MARIA_PASSWORD=$(cat /run/secrets/maria_password)
export MARIA_ROOT_PASSWORD=$(cat /run/secrets/maria_root_password)
export MARIA_IP="${WP_HOST%%:*}"
export MARIA_PORT="${WP_HOST#*:}"

mariadbd-safe &

until nc -z $MARIA_IP $MARIA_PORT; do
    echo "waiting for mariadb"
    sleep 1
done

echo "set root password and use native password plugin"
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MARIA_ROOT_PASSWORD}'); FLUSH PRIVILEGES;"

echo "create database table"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MARIA_DB_NAME}\`;"

echo "create user"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MARIA_USER}'@'%' IDENTIFIED BY '${MARIA_PASSWORD}';"

echo "grant privileges to the user"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MARIA_DB_NAME}\`.* TO '${MARIA_USER}'@'%';"

echo "flush privileges"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "shutdown the server"
mariadb-admin -u root -p"${MARIA_ROOT_PASSWORD}" shutdown

echo "starting mariadb"
exec "$@"
