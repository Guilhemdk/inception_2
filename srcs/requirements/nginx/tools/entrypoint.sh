#!/bin/bash
set -e

: "${DOMAIN_NAME:?DOMAIN_NAME is required}"
: "${CERT_PATH:?CERT_PATH is required}"
: "${KEY_PATH:?KEY_PATH is required}"

CERT_DIR=$(dirname "${CERT_PATH}")
KEY_DIR=$(dirname "${KEY_PATH}")

mkdir -p "${CERT_DIR}" "${KEY_DIR}"

if [ ! -f "${CERT_PATH}" ] || [ ! -f "${KEY_PATH}" ]; then
  echo "[nginx] Generating self-signed TLS certificate for ${DOMAIN_NAME}..."
  openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -keyout "${KEY_PATH}" -out "${CERT_PATH}" \
    -subj "/CN=${DOMAIN_NAME}"
fi

cat > /etc/nginx/sites-available/default << NGINXCONF
server {
    listen 443 ssl http2;
    server_name ${DOMAIN_NAME};

    root /var/www/html;
    index index.php index.html index.htm;

    ssl_certificate     ${CERT_PATH};
    ssl_certificate_key ${KEY_PATH};
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
    }
}
NGINXCONF

nginx -t

echo "[nginx] Starting nginx..."
exec nginx -g 'daemon off;'
