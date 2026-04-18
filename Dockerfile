FROM oven/bun:latest AS builder
WORKDIR /app

# Copy everything for the build
COPY . .
RUN bun install
RUN bun run build

FROM oven/bun:latest AS runner
WORKDIR /app

# Copy the built output
COPY --from=builder /app/.output ./.output
# Copy package.json and install ONLY production deps to satisfy 'srvx' and others
COPY --from=builder /app/package.json ./
RUN bun install --production

ENV NODE_ENV=production
# Force host to 0.0.0.0 to ensure Render can see the app
ENV HOST=0.0.0.0

CMD ["bun", ".output/server/index.mjs"]