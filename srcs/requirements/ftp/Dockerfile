FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y vsftpd libpam-modules && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ftpuser && \
    mkdir -p /home/ftpuser/ftp && \
    chown nobody:nogroup /home/ftpuser/ftp && \
    chmod a-w /home/ftpuser/ftp && \
    mkdir -p /home/ftpuser/ftp/files && \
    chown ftpuser:ftpuser /home/ftpuser/ftp/files

# Create uploads directory that maps to WordPress
RUN mkdir -p /home/ftpuser/ftp/wordpress && \
    chown ftpuser:ftpuser /home/ftpuser/ftp/wordpress

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY conf/vsftpd.pam /etc/pam.d/vsftpd
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh


# Create log directory
RUN mkdir -p /var/log/vsftpd && \
    chown ftpuser:ftpuser /var/log/vsftpd

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["vsftpd", "/etc/vsftpd.conf"]
