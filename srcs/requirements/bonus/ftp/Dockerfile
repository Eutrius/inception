FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y vsftpd netcat && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /var/log/vsftpd /var/run/vsftpd/empty

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["vsftpd", "/etc/vsftpd.conf"]
