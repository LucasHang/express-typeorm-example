FROM node:12-buster-slim AS base

RUN apt-get update && apt-get install --no-install-recommends --yes openssl

ENV PRODUCTION=true

WORKDIR /app

### BUILDER ###
FROM base AS builder

COPY package.json ./

RUN npm install

# Copy source files
COPY . .

# Build
RUN npm run build

### RUNNER ###
FROM base

ENV PORT=3000

# Copy runtime project
COPY --from=builder /app/dist/ ./src/
COPY --from=builder /app/node_modules/ ./node_modules
COPY package.json ./
COPY ormconfig.js ./

USER node

CMD ["node", "src/server.js"]
