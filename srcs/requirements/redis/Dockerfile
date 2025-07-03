FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y redis-server && \
	apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /var/lib/redis /var/log/redis && \
    chown -R redis:redis /var/lib/redis /var/log/redis

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["redis-server", "/etc/redis/redis.conf"]
