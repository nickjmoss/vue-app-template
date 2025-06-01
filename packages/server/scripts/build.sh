# Build server TS files and put them in dist/server-build
tsc && tsc-alias

# Copy Prisma files to dist/server-build
mkdir -p ../../dist/server-build/prisma
cp prisma/schema.prisma ../../dist/server-build/prisma/schema.prisma
cp -r prisma/migrations ../../dist/server-build/prisma

# DELETE IF NOT USING SQLITE
# Copy SQLite database to dist/server-build
cp prisma/dev.db ../../dist/server-build/prisma/dev.db