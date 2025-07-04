#!/bin/sh

set -e

export FTP_PASSWORD=$(cat /run/secrets/ftp_user_password)

echo "ftpuser:$FTP_PASSWORD" | chpasswd

echo "ftpuser" > /etc/vsftpd.userlist

mkdir -p /var/run/vsftpd/empty
mkdir -p /var/log/vsftpd

if [ -d /var/www/wordpress ]; then
    ln -sf /var/www/wordpress/wp-content/uploads /home/ftpuser/ftp/wordpress/uploads 2>/dev/null || true
    chown -h ftpuser:ftpuser /home/ftpuser/ftp/wordpress/uploads 2>/dev/null || true
fi

chown -R ftpuser:ftpuser /home/ftpuser/ftp/files
chown -R ftpuser:ftpuser /home/ftpuser/ftp/wordpress

echo "starting ftp server"
exec "$@"

