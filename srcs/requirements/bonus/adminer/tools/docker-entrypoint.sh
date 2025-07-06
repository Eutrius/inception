#!/bin/bash
set -e

chown -R www-data:www-data /var/www/adminer
chmod -R 755 /var/www/adminer

echo "starting adminer"
exec "$@"
