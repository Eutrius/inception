FROM debian:bullseye

RUN apt update -y && \
    apt install -y wget ca-certificates curl netcat && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data /app && \
    chmod -R 755 /data /app

RUN wget "https://github.com/portainer/portainer/releases/download/2.27.9/portainer-2.27.9-linux-amd64.tar.gz" -O /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /app && \
    rm /tmp/portainer.tar.gz && \
    chmod +x /app/portainer/portainer

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /app

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/app/portainer/portainer", "-H", "unix:///var/run/docker.sock", "--data", "/data"]
