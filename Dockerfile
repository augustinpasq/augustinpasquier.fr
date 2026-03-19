FROM node:24-slim AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:1.29-alpine-slim

LABEL org.opencontainers.image.source=https://github.com/augustinpasq/augustinpasquier.fr

WORKDIR /app

COPY --from=builder /app/dist /usr/share/nginx/html/

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]