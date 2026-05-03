FROM node:24-bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

COPY . .
RUN pnpm install --frozen-lockfile

# 1. Build del daemon
RUN pnpm --filter @open-design/daemon build

# 2. Build de Next.js → genera apps/web/out/
RUN pnpm build

# Verificar que el out/ existe
RUN ls -la apps/web/out/

EXPOSE 7456

ENV NODE_ENV=production
ENV OD_DAEMON_PORT=7456
ENV ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

# El daemon sirve el static export él mismo en puerto 7456
CMD ["node", "apps/daemon/dist/cli.js", "--port", "7456"]
