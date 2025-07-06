FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y php7.4 php7.4-fpm php7.4-mysql php7.4-mbstring wget && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer && \
    wget "https://www.adminer.org/latest.php" -O /var/www/adminer/adminer.php && \
    chown -R www-data:www-data /var/www/adminer && \
    chmod 644 /var/www/adminer/adminer.php

RUN mkdir -p /run/php/

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY tools/docker-entrypoint.sh tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/healthcheck.sh

WORKDIR /var/www/adminer

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
