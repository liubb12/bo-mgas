FROM node:20-alpine

WORKDIR /app

COPY index.js index.html package.json ./

RUN apk add --no-cache openssl curl gcompat iproute2 coreutils bash && \
    chmod +x index.js && \
    npm install

EXPOSE 3000

CMD ["node", "index.js"]
