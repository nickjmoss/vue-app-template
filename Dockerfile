# Use Bun as the base image for building
FROM oven/bun:latest AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the root package.json, bun.lock (for caching), and workspace config
COPY package.json bun.lock .npmrc ./

# Copy only package.json files to leverage Docker caching for dependencies
COPY packages/src/package.json packages/src/
COPY packages/server/package.json packages/server/

# Install dependencies (hoisted in /node_modules) for the build steps
RUN bun install --frozen-lockfile

# Copy the entire workspace (excluding node_modules)
COPY . .

# ----------------------------------------------------------------------------------
# |                                                                                 |
# |  !!!IMPORTANT: Uncomment the following line once schema.prisma is populated!!!  |
# |                                                                                 |
# ----------------------------------------------------------------------------------
# RUN bun run server:prisma:generate

# Run build steps for each package
RUN bun run --filter=./packages/src build
RUN bun run --filter=./packages/server build

# Create a minimal runtime image
FROM oven/bun:latest AS runtime

# Set the working directory
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/package.json /app/bun.lock ./
COPY --from=builder /app/dist/frontend-build ./frontend-build
COPY --from=builder /app/packages/server/package.json ./server-build/package.json
COPY --from=builder /app/dist/server-build ./server-build

# copy .npmrc from builder stage to server-build temporarily
COPY --from=builder /app/.npmrc ./server-build/

# Install only production dependencies for the server-build since frontend dependencies are not needed
RUN cd server-build && bun install --production

# remove .npmrc since it is not needed in the runtime image
RUN rm ./server-build/.npmrc

# Expose the necessary ports
EXPOSE 4000

# Set the startup command
CMD ["bun", "run", "start:prod"]
