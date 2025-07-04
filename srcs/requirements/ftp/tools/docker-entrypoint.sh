#!/bin/bash
set -e

export FTP_PASSWORD=$(cat /run/secrets/ftp_user_password)

echo "creating user"
useradd -m $FTP_USER || echo "ftp user already exists"
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "setting root dir"
chown -R "$FTP_USER:$FTP_USER" /var/www/wordpress

echo "starting ftp server"
exec "$@"
