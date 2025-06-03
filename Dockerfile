# Use Bun as the base image for building
FROM oven/bun:latest AS builder

ARG NICKJMOSS_NPM_AUTH_TOKEN

RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy workspace root files
COPY package.json bun.lock .npmrc ./

# Copy only relevant package.json files for caching
COPY packages/src/package.json packages/src/
COPY packages/server/package.json packages/server/

# Install all dependencies
RUN bun install --frozen-lockfile

# Copy the full monorepo
COPY . .

# Generate Prisma Client
RUN bun run --filter=./packages/server prisma:generate

# Build source and server packages
RUN bun run --filter=./packages/src build
RUN bun run --filter=./packages/server build

# ----------------------------
# Runtime Stage
# ----------------------------
FROM oven/bun:latest AS runtime

ARG NICKJMOSS_NPM_AUTH_TOKEN

# Install openssl for Prisma
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only what's needed for production
COPY --from=builder /app/dist/frontend-build ./frontend-build
COPY --from=builder /app/dist/server-build ./server-build
COPY --from=builder /app/packages/server/package.json ./server-build/package.json

# Copy .npmrc over from builder
COPY --from=builder /app/.npmrc ./server-build/.npmrc

# Copy generated Prisma client (essential for Prisma to work)
COPY --from=builder /app/node_modules/@prisma ./server-build/node_modules/@prisma
COPY --from=builder /app/node_modules/.prisma ./server-build/node_modules/.prisma

# Install only production deps for server
RUN cd server-build && bun install --production && rm .npmrc

# Change working directory to server-build
WORKDIR /app/server-build

# Expose app port
EXPOSE 4000

# Start app directly from the server-build directory
CMD ["bun", "run", "start:prod"]
