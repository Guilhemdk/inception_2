#!/bin/bash
set -e

# Required environment variables
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${DB_HOST:?DB_HOST is required}"
: "${DOMAIN_NAME:?DOMAIN_NAME is required}"
: "${WP_TITLE:?WP_TITLE is required}"
: "${WP_ADMIN_USR:?WP_ADMIN_USR is required}"
: "${WP_ADMIN_PWD:?WP_ADMIN_PWD is required}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL is required}"
: "${WP_USER:?WP_USER is required}"
: "${WP_USER_PWD:?WP_USER_PWD is required}"
: "${WP_USER_EMAIL:?WP_USER_EMAIL is required}"

cd /var/www/html

# Wait for MariaDB to be ready (bounded retries)
for i in {1..30}; do
  if mariadb -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
    break
  fi
  echo "[wordpress] Waiting for MariaDB (${i}/30)..."
  sleep 1
done

if ! mariadb -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
  echo "[wordpress] Cannot connect to MariaDB at ${DB_HOST} with provided credentials" >&2
  exit 1
fi

# Install wp-cli if missing
if [ ! -x /usr/local/bin/wp ]; then
  echo "[wordpress] Installing wp-cli..."
  curl -sS -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x /usr/local/bin/wp
fi

# Install and configure WordPress on first run
if [ ! -f wp-config.php ]; then
  echo "[wordpress] Setting up WordPress..."

  wp core download --path=/var/www/html --allow-root

  wp config create \
    --path=/var/www/html \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${DB_HOST}" \
    --skip-check \
    --allow-root

  wp core install \
    --url="https://${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USR}" \
    --admin_password="${WP_ADMIN_PWD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PWD}" \
    --role=author \
    --allow-root

  chown -R www-data:www-data /var/www/html
fi

echo "[wordpress] Starting php-fpm..."
exec php-fpm -F
