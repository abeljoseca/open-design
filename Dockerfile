FROM node:24-bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

COPY . .
RUN pnpm install --frozen-lockfile

# Build daemon + web estático
RUN pnpm --filter @open-design/daemon build
RUN pnpm build

EXPOSE 7456

ENV NODE_ENV=production

# El daemon sirve el frontend estático él mismo
CMD ["node", "apps/daemon/dist/cli.js"]
