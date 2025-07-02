#!/bin/bash
set -e

sleep 10

echo "wordpress create config"
wp config create --allow-root \
				 --dbname=$MARIA_DB_NAME \
				 --dbuser=$MARIA_USER \
				 --dbpass=$MARIA_PASSWORD \
				 --dbhost=$WP_HOST

echo "wordpress install core"
wp eval 'add_filter("wp_mail", "__return_false");'
wp core install --allow-root \
	            --url="$WP_URL" \
				--title="$WP_TITLE" \
				--admin_user="$WP_ADMIN_USER" \
				--admin_password="$WP_ADMIN_PASSWORD" \
				--admin_email="$WP_ADMIN_EMAIL"

echo "wordpress create user"
wp user create "$WP_USER" "$WP_USER_EMAIL" \
	            --role=author \
	            --user_pass="$WP_USER_PASSWORD" \
			    --allow-root

echo "wordpress ready"
exec "$@"
