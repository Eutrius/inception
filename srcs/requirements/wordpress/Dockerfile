FROM debian:bullseye

RUN apt-get update -y
RUN apt-get install -y php7.4-fpm php7.4-mysql \
    php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring \
    php7.4-xml php7.4-xmlrpc php7.4-zip curl 
RUN rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
