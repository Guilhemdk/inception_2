FROM debian:bullseye

RUN apt-get update -y \
    && apt-get install -y php-fpm php-mysql curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Configure php-fpm to listen on TCP port 9000 for NGINX fastcgi_pass
RUN find /etc/php -type f -name www.conf -path "*/fpm/*" -exec sed -i 's|^listen = .*|listen = 9000|' {} \;

RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www

WORKDIR /var/www/html

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

CMD ["entrypoint.sh"]
