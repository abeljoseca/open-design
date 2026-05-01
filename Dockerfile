FROM node:24-alpine

WORKDIR /app

# Enable corepack para pnpm
RUN corepack enable

# Instalar dependencias
COPY . .
RUN corepack prepare pnpm@10.33.2 --activate
RUN pnpm install

# Build de producción
RUN pnpm build

# Exponer puertos
EXPOSE 3000 7456

# Comando de inicio
CMD ["sh", "-c", "pnpm tools-dev run web"]
