# Updated for Railway - copy source first, then install
FROM node:24-bullseye

WORKDIR /app

# Instalar Python y herramientas de compilación
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Enable corepack y pnpm
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

# PRIMERO: Copiar TODO el código (incluyendo scripts/)
COPY . .

# SEGUNDO: Instalar dependencias (ahora el postinstall script encontrará los archivos)
RUN pnpm install --frozen-lockfile

# Build de Next.js
RUN pnpm build

# Crear directorio para artifacts
RUN mkdir -p .od/artifacts

# Exponer puertos
EXPOSE 3000 7456

# Variables de entorno
ENV NODE_ENV=production
ENV PORT=3000

# Start
CMD ["pnpm", "tools-dev", "run", "web"]
