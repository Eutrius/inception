FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y mariadb-server netcat

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /run/mysqld && \
    chown -R root:root /run/mysqld

CMD ["docker-entrypoint.sh"]
