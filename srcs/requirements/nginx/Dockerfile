FROM debian:bullseye

RUN apt-get update -y \
    && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

CMD ["entrypoint.sh"]
