#!/bin/bash
set -e

export MARIA_PASSWORD=$(cat /run/secrets/maria_password)
export WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
export WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export MARIA_IP="${WP_HOST%%:*}"
export MARIA_PORT="${WP_HOST#*:}"
export REDIS_IP="${REDIS_HOST%%:*}"
export REDIS_PORT="${REDIS_HOST#*:}"

until nc -z $MARIA_IP $MARIA_PORT; do
	echo "waiting for mariadb"
	sleep 1
done

until nc -z $REDIS_IP $REDIS_PORT; do
	echo "waiting for redis"
	sleep 1
done

if [ ! -f wp-config.php ]; then
  wp config create --allow-root \
    --dbname="$MARIA_DB_NAME" \
    --dbuser="$MARIA_USER" \
    --dbpass="$MARIA_PASSWORD" \
    --dbhost="$WP_HOST"
    
  wp config set WP_REDIS_HOST "$REDIS_IP" --allow-root
  wp config set WP_REDIS_PORT "$REDIS_PORT" --allow-root
  wp config set WP_REDIS_DATABASE 0 --allow-root
  wp config set WP_CACHE true --allow-root
  
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

if ! wp plugin is-installed redis-cache --allow-root; then
  wp plugin install redis-cache --allow-root
  wp plugin activate redis-cache --allow-root
  wp redis enable --allow-root
else
  echo "redis plugin is already installed and activated."
fi

echo "wordpress ready"
exec "$@"
