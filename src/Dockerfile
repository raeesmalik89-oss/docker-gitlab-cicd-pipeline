FROM node:20-alpine

# curl is used by the pipeline health checks
RUN apk add --no-cache curl

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force

COPY app.js VERSION ./
COPY test ./test

ENV NODE_ENV=production \
    PORT=3000

# Run as the non-root user provided by the base image
USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["node", "app.js"]
