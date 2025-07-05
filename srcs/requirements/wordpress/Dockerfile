FROM debian:bullseye
                   
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y php7.4 php7.4-fpm php7.4-mysql php7.4-redis php7.4-ftp \
	wget unzip curl && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    mkdir -p /var/www/wordpress && \
    unzip /tmp/wordpress.zip -d /tmp/ && \
    mv /tmp/wordpress /var/www/ && \
    rm -rf /tmp/wordpress.zip && \
    chown -R root:root /var/www/wordpress

RUN mkdir -p /run/php/

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY tools/docker-entrypoint.sh tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/healthcheck.sh

WORKDIR /var/www/wordpress

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
