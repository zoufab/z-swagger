FROM node:20-alpine AS base

WORKDIR /app

COPY package.json ./
RUN npm install --no-audit --no-fund

COPY openapi ./openapi
COPY README.md ./README.md

CMD ["npm", "run", "bundle"]
