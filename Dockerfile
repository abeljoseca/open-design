FROM node:24-bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

COPY . .
RUN pnpm install --frozen-lockfile

# Build con output standalone
RUN pnpm build

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000

# Comando que Railway va a ejecutar
ENTRYPOINT []
CMD ["sh", "-c", "exec node apps/web/.next/standalone/server.js"]
