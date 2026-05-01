FROM node:24-bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm build

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000

# Comando para correr Next.js en modo producción
CMD ["pnpm", "-C", "apps/web", "start"]
