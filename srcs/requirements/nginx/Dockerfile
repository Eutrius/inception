FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y nginx openssl

COPY conf/default /etc/nginx/sites-available/.
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
