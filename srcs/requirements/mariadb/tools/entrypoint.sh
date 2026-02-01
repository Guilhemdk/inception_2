#!/bin/bash
set -e

# Non-secret env
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"

# Secrets from Docker secrets files
ROOT_PW_FILE="/run/secrets/db_root_password"
DB_PW_FILE="/run/secrets/db_password"

if [ ! -f "${ROOT_PW_FILE}" ]; then
  echo "[mariadb] Missing secret file ${ROOT_PW_FILE}" >&2
  exit 1
fi
if [ ! -f "${DB_PW_FILE}" ]; then
  echo "[mariadb] Missing secret file ${DB_PW_FILE}" >&2
  exit 1
fi

DB_ROOT_PASSWORD=$(<"${ROOT_PW_FILE}")
DB_PASSWORD=$(<"${DB_PW_FILE}")

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql || true

MARKER=/var/lib/mysql/.inception_initialized

if [ ! -f "$MARKER" ]; then
  echo "[mariadb] First-time initialization..."

  mysqld_safe --datadir=/var/lib/mysql &
  MYSQL_PID=$!

  # Wait for server to be ready (bounded retries)
  for i in {1..30}; do
    if mysqladmin ping --silent; then
      break
    fi
    sleep 1
  done

  if ! mysqladmin ping --silent; then
    echo "[mariadb] Failed to start server during initialization" >&2
    kill "$MYSQL_PID" || true
    exit 1
  fi

  mysql <<-SQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS \
      \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
SQL

  mysqladmin -uroot -p"${DB_ROOT_PASSWORD}" shutdown
  wait "$MYSQL_PID"

  touch "$MARKER"
  chown mysql:mysql "$MARKER" || true

  echo "[mariadb] Initialization complete."
fi

echo "[mariadb] Starting MariaDB in foreground..."
exec mysqld_safe --datadir=/var/lib/mysql
