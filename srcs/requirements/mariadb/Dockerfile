FROM debian:bullseye

RUN apt-get update -y \
    && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Basic MariaDB config override (bind to all interfaces inside container)
COPY tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql || true

CMD ["entrypoint.sh"]
