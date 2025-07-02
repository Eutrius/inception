#!/bin/bash

mariadbd-safe &

sleep 5

echo "create database table"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MARIA_DB_NAME}\`;"

echo "create user"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MARIA_USER}\`@'localhost' IDENTIFIED BY '${MARIA_PASSWORD}';"

echo "grant privileges to the user"
mariadb -u root -p"${MARIA_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MARIA_DB_NAME}\`.* TO \`${MARIA_USER}\`@'%' IDENTIFIED BY '${MARIA_PASSWORD}';"

echo "flush privileges"
mariadb -u root -p${MARIA_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

echo "shutdown the server"
mariadb-admin -u root -p"${MARIA_ROOT_PASSWORD}" shutdown

echo "starting maraidb"
exec mariadbd-safe
