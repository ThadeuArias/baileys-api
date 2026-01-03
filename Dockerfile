FROM node:20-slim

RUN apt-get update && apt-get install -y openssl git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm install --quiet
RUN npm install tsc-alias --save-dev

COPY . .

RUN npx prisma generate

RUN npx tsc --project tsconfig.json || true
RUN npx tsc-alias -p tsconfig.json || true

EXPOSE 3000

CMD npx prisma migrate deploy && node dist/main.js
