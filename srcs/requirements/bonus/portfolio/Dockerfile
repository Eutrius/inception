FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y nodejs npm curl && \
    npm install -g express && \
    apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY src/package.json src/server.js .
COPY src/public ./public
RUN npm install

CMD ["npm", "start"]
