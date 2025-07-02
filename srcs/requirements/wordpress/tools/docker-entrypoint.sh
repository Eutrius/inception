#!/bin/bash
set -e

export MARIA_PASSWORD=$(cat /run/secrets/maria_password)
export WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
export WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

until nc -z mariadb 3306; do
	echo "waiting for mariadb"
	sleep 1
done

if [ ! -f wp-config.php ]; then
  wp config create --allow-root \
    --dbname="$MARIA_DB_NAME" \
    --dbuser="$MARIA_USER" \
    --dbpass="$MARIA_PASSWORD" \
    --dbhost="$WP_HOST"
else
  echo "wp-config.php already exists, skipping config creation."
fi

if ! wp core is-installed --allow-root; then
  wp core install --allow-root \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL"
else
  echo "wp core already installed, skipping core install."
fi

if ! wp user get "$WP_USER" --field=ID --allow-root > /dev/null 2>&1; then
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --role=author \
    --user_pass="$WP_USER_PASSWORD" \
    --allow-root
else
  echo "user $WP_USER already exists, skipping user creation."
fi

echo "wordpress ready"
exec "$@"
