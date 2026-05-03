FROM node:24-bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm build

# Copiar archivos públicos necesarios
RUN cp -r apps/web/.next/static apps/web/.next/standalone/.next/ 2>/dev/null || true
RUN cp -r apps/web/public apps/web/.next/standalone/ 2>/dev/null || true

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000

# Modo producción
CMD ["node", "--no-deprecation", "apps/web/.next/standalone/server.js"]
