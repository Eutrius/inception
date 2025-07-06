#!/bin/bash
set -e

export FTP_USER_PASSWORD=$(cat /run/secrets/ftp_user_password)

if ! id "$FTP_USER" &>/dev/null; then
    useradd -u 1001 -m -d /var/www/wordpress -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_USER_PASSWORD" | chpasswd
    echo "user created successfully"
else
    echo "user already exists"
fi

groupadd -g 1000 webgroup || true

usermod -aG webgroup www-data
usermod -aG webgroup $FTP_USER

chown -R www-data:webgroup /var/www/wordpress
find /var/www/wordpress -type d -exec chmod 775 {} \;
find /var/www/wordpress -type f -exec chmod 664 {} \;

echo "starting vsftpd"
exec "$@"
