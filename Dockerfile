# Use Bun base image
FROM oven/bun:latest AS builder

WORKDIR /app

# Copy config and lockfiles
COPY package.json bun.lockb ./

# Install deps
RUN bun install --frozen-lockfile

# Copy source and build using vinxi
COPY . .
RUN bun run build

# Final runner stage
FROM oven/bun:latest AS runner

WORKDIR /app

# Only copy the compiled output
COPY --from=builder /app/.output ./.output

# Render uses the PORT env var, Nitro/Vinxi picks it up automatically
ENV NODE_ENV=production

# Run the generated server
CMD ["bun", ".output/server/index.mjs"]