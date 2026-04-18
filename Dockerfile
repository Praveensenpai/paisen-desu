FROM oven/bun:latest AS builder
WORKDIR /app

# Use a wildcard so it doesn't crash if the lockfile is missing or named differently
COPY package.json bun.lock* ./

# Install without the --frozen-lockfile flag since you don't have a stable lock
RUN bun install

COPY . .
RUN bun run build

FROM oven/bun:latest AS runner
WORKDIR /app
COPY --from=builder /app/.output ./.output
ENV NODE_ENV=production

# SolidStart/Nitro listens on PORT env var automatically
CMD ["bun", ".output/server/index.mjs"]